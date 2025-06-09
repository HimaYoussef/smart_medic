import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_blue_classic/flutter_blue_classic.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'firebaseServices.dart';

class BluetoothManager {
  static bool needsSync = false;
  static final BluetoothManager _instance = BluetoothManager._internal();
  factory BluetoothManager() => _instance;
  BluetoothManager._internal();

  final _flutterBlueClassic = FlutterBlueClassic();
  BluetoothConnection? _connection;
  StreamSubscription? _scanSubscription;
  StreamSubscription? _readSubscription;
  StreamSubscription? _adapterStateSubscription;
  StreamSubscription? _scanningStateSubscription;
  Database? _database;

  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  bool _isScanning = false;
  final Set<BluetoothDevice> _scanResults = {};

  final _responseStream = StreamController<String>.broadcast();
  String _buffer = "";

  bool get isConnected => _connection != null && _connection!.isConnected;

  Future<void> requestPermissions() async {
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.location.request();
  }

  Future<void> initDatabase() async {
    String path = join(await getDatabasesPath(), 'bluetooth_queue.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE queue(id INTEGER PRIMARY KEY, data TEXT, timestamp TEXT)',
        );
      },
    );
  }

  Future<void> initBluetooth() async {
    await requestPermissions();
    await initDatabase();

    try {
      _adapterState = await _flutterBlueClassic.adapterStateNow;
      _adapterStateSubscription = _flutterBlueClassic.adapterState.listen((current) {
        print("Bluetooth Adapter State: $current");
        _adapterState = current;
        if (_adapterState == BluetoothAdapterState.on && !_isScanning) {
          startScan();
        }
      });

      _scanningStateSubscription = _flutterBlueClassic.isScanning.listen((isScanning) {
        print("Scanning State: $isScanning");
        _isScanning = isScanning;
      });

      _scanSubscription = _flutterBlueClassic.scanResults.listen((device) {
        print("Found device: ${device.name}");
        _scanResults.add(device);
        if (device.name == "HC-05") {
          connectToDevice(device);
        }
      });

      if (_adapterState == BluetoothAdapterState.on) {
        startScan();
      } else {
        print("Bluetooth is off, turning on...");
        _flutterBlueClassic.turnOn();
      }

      startRetryTimer();
    } catch (e) {
      print("Error initializing Bluetooth: $e");
    }
  }

  Future<void> startScan() async {
    if (_isScanning) {
      print("Scan already in progress");
      return;
    }
    try {
      _scanResults.clear();
      _flutterBlueClassic.startScan();
      print("Started scanning for devices...");
    } catch (e) {
      print("Error starting scan: $e");
    }
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      if (_connection != null && _connection!.isConnected) {
        print("Already connected to a device");
        return;
      }

      _connection = await _flutterBlueClassic.connect(device.address);
      if (_connection != null && _connection!.isConnected) {
        print("Connected to ${device.name}");
        listenToDevice();
        if (needsSync) {
          await sendAllMedicationsToArduino();
        }
      } else {
        print("Failed to connect to ${device.name}");
      }
    } catch (e) {
      print("Connection error: $e");
    }
  }

  Future<bool> startHandshake() async {
    if (_connection == null || !_connection!.isConnected) {
      print("Cannot start handshake: Bluetooth not connected");
      return false;
    }

    try {
      _connection!.writeString("SEND_DATA\n");
      print("Sent SEND_DATA request");

      String response = await _responseStream.stream
          .firstWhere((res) => res.trim() == "READY", orElse: () => "");
      if (response.trim() != "READY") {
        print("Expected READY, got: $response");
        return false;
      }
      print("Received READY from Arduino");
      return true;
    } catch (e) {
      print("Handshake error: $e");
      return false;
    }
  }

  Future<bool> sendDataWithHandshake(String data) async {
    if (_connection == null || !_connection!.isConnected) {
      print("Cannot send data: Bluetooth not connected");
      await addToQueue(data);
      return false;
    }

    try {
      String dataWithNewline = "$data\n";
      _connection!.writeString(dataWithNewline);
      print("Data sent: $dataWithNewline");

      String response = await _responseStream.stream
          .firstWhere((res) => res.trim() == "READY_FOR_NEXT", orElse: () => "");
      if (response.trim() != "READY_FOR_NEXT") {
        print("Expected READY_FOR_NEXT, got: $response");
        await addToQueue(data);
        return false;
      }
      return true;
    } catch (e) {
      print("Send error with handshake: $e");
      await addToQueue(data);
      return false;
    }
  }

  Future<Map<String, dynamic>> sendAllMedicationsToArduino() async {
    try {
      print('Starting sendAllMedicationsToArduino...');
      QuerySnapshot medicationsSnapshot = await FirebaseFirestore.instance
          .collection('medications')
          .where('patientId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      List<Map<String, dynamic>> medications = medicationsSnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        String name = data["name"]?.toString() ?? "Unknown";
        int dosage = data["dosage"] ?? 0;
        int scheduleType = data["scheduleType"] ?? 0;
        int scheduleValue = data["scheduleValue"] ?? 0;
        List<String> times = (data["times"] as List<dynamic>?)?.cast<String>() ?? [];
        List<int> bitmaskDays = (data["bitmaskDays"] as List<dynamic>?)?.cast<int>() ?? [0, 0, 0, 0, 0, 0, 0];
        int pillsLeft = data["pillsLeft"] ?? 0;
        int compartmentNumber = data["compartmentNumber"] ?? 0;

        return {
          "id": doc.id,
          "name": name,
          "dosage": dosage,
          "scheduleType": scheduleType,
          "scheduleValue": scheduleValue,
          "times": times,
          "bitmaskDays": bitmaskDays,
          "pillsLeft": pillsLeft,
          "compartmentNumber": compartmentNumber,
        };
      }).toList();

      if (isConnected) {
        bool handshakeSuccess = await startHandshake();
        if (!handshakeSuccess) {
          for (var med in medications) {
            String dataToSend = jsonEncode({"medication": med});
            await addToQueue(dataToSend);
            await SmartMedicalDb.updateMedicationSyncStatus(
              medId: med['id'],
              syncStatus: 'Pending',
            );
          }
          return {
            "success": false,
            "message": "Failed to start handshake with Arduino. Data will be sent later.",
            "medicationsSynced": false,
          };
        }

        // إرسال أمر UPDATE_MEDS مع أرقام الحجرات
        List<int> compartmentNumbers = medications.map((med) => med['compartmentNumber'] as int).toList();
        String updateMedsCommand = "UPDATE_MEDS ${compartmentNumbers.join(',')}\n";
        bool updateMedsSuccess = await sendDataWithHandshake(updateMedsCommand);
        if (!updateMedsSuccess) {
          for (var med in medications) {
            String dataToSend = jsonEncode({"medication": med});
            await addToQueue(dataToSend);
            await SmartMedicalDb.updateMedicationSyncStatus(
              medId: med['id'],
              syncStatus: 'Pending',
            );
          }
          return {
            "success": false,
            "message": "Failed to send UPDATE_MEDS command.",
            "medicationsSynced": false,
          };
        }

        // إرسال بيانات كل دواء
        for (var med in medications) {
          String dataToSend = jsonEncode(med);
          print("Preparing to send data to Arduino: $dataToSend");
          bool success = await sendDataWithHandshake(dataToSend);
          if (success) {
            await SmartMedicalDb.updateMedicationSyncStatus(
              medId: med['id'],
              syncStatus: 'Synced',
            );
          } else {
            await SmartMedicalDb.updateMedicationSyncStatus(
              medId: med['id'],
              syncStatus: 'Pending',
            );
            await addToQueue(dataToSend);
            return {
              "success": false,
              "message": "Failed to send ${med['name']} to Arduino",
              "medicationsSynced": false,
            };
          }
        }

        needsSync = false; // إعادة تعيين الـ flag بعد الإرسال الناجح
        print("All medications synced, needs sync: $needsSync");
        return {
          "success": true,
          "message": "All medications synced successfully.",
          "medicationsSynced": true,
        };
      }
      else {
        for (var med in medications) {
          String dataToSend = jsonEncode({"medication": med});
          await addToQueue(dataToSend);
          await SmartMedicalDb.updateMedicationSyncStatus(
            medId: med['id'],
            syncStatus: 'Pending',
          );
        }
        return {
          "success": false,
          "message": "Bluetooth not connected. Data will be sent later.",
          "medicationsSynced": false,
        };
      }
    } catch (e) {
      print("Error in sendAllMedicationsToArduino: $e");
      QuerySnapshot medicationsSnapshot = await FirebaseFirestore.instance
          .collection('medications')
          .where('patientId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();
      for (var doc in medicationsSnapshot.docs) {
        await SmartMedicalDb.updateMedicationSyncStatus(
          medId: doc.id,
          syncStatus: 'Pending',
        );
      }
      return {
        "success": false,
        "message": "Error syncing medications: $e",
        "medicationsSynced": false,
      };
    }
  }

  Future<void> addToQueue(String data) async {
    if (_database == null || _database!.isOpen == false) {
      await initDatabase();
    }
    await _database!.insert('queue', {
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    });
    print("Data added to queue: $data");
  }

  Future<void> retrySendingFromQueue() async {
    if (_database == null || _database!.isOpen == false) {
      await initDatabase();
    }
    if (needsSync) {
      await sendAllMedicationsToArduino();
    }
  }

  void listenToDevice() {
    _readSubscription = _connection?.input?.listen((event) async {
      String receivedChunk = utf8.decode(event);
      _buffer += receivedChunk;

      int newlineIndex = _buffer.indexOf('\n');
      while (newlineIndex != -1) {
        String receivedData = _buffer.substring(0, newlineIndex);
        _buffer = _buffer.substring(newlineIndex + 1);

        _responseStream.add(receivedData);
        print("Received and processed: $receivedData");

        try {
          List<dynamic> logList = jsonDecode(receivedData);
          if (logList.isNotEmpty) {
            Map<String, dynamic> logData = logList[0];
            await uploadLogToFirebase(logData);
          }
        } catch (e) {
          print("Error parsing log: $e");
        }

        newlineIndex = _buffer.indexOf('\n');
      }
    }, onError: (error) {
      print("Error listening to device: $error");
    });
  }

  Future<void> uploadLogToFirebase(Map<String, dynamic> logData) async {
    try {
      int logType = logData['type'];

      if (logType == 0) {
        int compartmentNumber = logData['medicineID'];
        String? medicationId;
        QuerySnapshot medicationsSnapshot = await FirebaseFirestore.instance
            .collection('medications')
            .where('patientId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('compartmentNumber', isEqualTo: compartmentNumber)
            .get();

        if (medicationsSnapshot.docs.isNotEmpty) {
          medicationId = medicationsSnapshot.docs.first.id;
        } else {
          medicationId = "unknown";
        }

        await SmartMedicalDb.addLog(
          logId: DateTime.now().millisecondsSinceEpoch.toString(),
          patientId: FirebaseAuth.instance.currentUser!.uid,
          medicationId: medicationId,
          status: logData['isConfirmed'] == 0 ? 'missed' : 'taken',
          spo2: logData['oxygen'] != -1 ? (logData['oxygen'] as num).toDouble() : null,
          heartRate: logData['heartRate'] != -1 ? (logData['heartRate'] as num).toDouble() : null,
          dayOfYear: logData['dayOfYear'],
          minutesMidnight: logData['minutesMidnight'],
        );
      } else if (logType == 1) {
        await SmartMedicalDb.addLog(
          logId: DateTime.now().millisecondsSinceEpoch.toString(),
          patientId: FirebaseAuth.instance.currentUser!.uid,
          medicationId: null,
          status: null,
          spo2: logData['oxygen'] != -1 ? (logData['oxygen'] as num).toDouble() : null,
          heartRate: logData['heartRate'] != -1 ? (logData['heartRate'] as num).toDouble() : null,
          dayOfYear: logData['dayOfYear'],
          minutesMidnight: logData['minutesMidnight'],
        );
      } else {
        print("Unknown log type: $logType, skipping...");
        return;
      }
    } catch (e) {
      print("Error uploading log: $e");
    }
  }

  void startRetryTimer() {
    Timer.periodic(const Duration(seconds: 30), (timer) async {
      if (_connection != null && _connection!.isConnected && needsSync) {
        await sendAllMedicationsToArduino();
      }
    });
  }

  void dispose() {
    _scanSubscription?.cancel();
    _readSubscription?.cancel();
    _adapterStateSubscription?.cancel();
    _scanningStateSubscription?.cancel();
    _connection?.dispose();
    _database?.close();
    _responseStream.close();
  }
}