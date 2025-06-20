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

  // متغيرات لتتبع حالة البلوتوث والـ Scan
  BluetoothAdapterState _adapterState = BluetoothAdapterState.unknown;
  bool _isScanning = false;
  final Set<BluetoothDevice> _scanResults = {};

  // Getter لمعرفة إذا كان البلوتوث متصل
  bool get isConnected => _connection != null && _connection!.isConnected;

  // طلب الإذونات
  Future<void> requestPermissions() async {
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
    await Permission.location.request();
  }

  // Initialize database for queue
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

  // Initialize Bluetooth
  Future<void> initBluetooth() async {
    // طلب الإذونات قبل أي حاجة
    await requestPermissions();

    await initDatabase();

    // مراقبة حالة البلوتوث
    try {
      _adapterState = await _flutterBlueClassic.adapterStateNow;
      _adapterStateSubscription = _flutterBlueClassic.adapterState.listen((current) {
        print("Bluetooth Adapter State: $current");
        _adapterState = current;
        if (_adapterState == BluetoothAdapterState.on && !_isScanning) {
          startScan();
        }
      });

      // مراقبة حالة الـ Scan
      _scanningStateSubscription = _flutterBlueClassic.isScanning.listen((isScanning) {
        print("Scanning State: $isScanning");
        _isScanning = isScanning;
      });

      // مراقبة نتايج الـ Scan
      _scanSubscription = _flutterBlueClassic.scanResults.listen((device) {
        print("Found device: ${device.name}");
        _scanResults.add(device);
        if (device.name == "HC-05") {
          connectToDevice(device);
        }
      });

      // ابدأ الـ Scan لو البلوتوث مفعّل
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

  // Scan for devices
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

  // Connect to device
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
        await retrySendingFromQueue();
      } else {
        print("Failed to connect to ${device.name}");
      }
    } catch (e) {
      print("Connection error: $e");
    }
  }

  // Send data
  Future<void> sendData(String data) async {
    if (_connection != null && _connection!.isConnected) {
      try {
        try {
          jsonDecode(data);
          print("Sending valid JSON: $data");
        } catch (e) {
          print("Invalid JSON to send: $data, Error: $e");
          return;
        }

        String dataWithNewline = "$data\n";
        _connection!.writeString(dataWithNewline);
        print("Data sent: $dataWithNewline");

        // إضافة تأخير بسيط عشان الـ HC-05 يستقبل البيانات كاملة
        await Future.delayed(const Duration(milliseconds: 500));
      } catch (e) {
        print("Send error: $e");
        await addToQueue(data);
      }
    } else {
      print("Cannot send data: Bluetooth not connected");
      await addToQueue(data);
    }
  }
  // Add to queue
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

  // Retry sending from queue
  Future<void> retrySendingFromQueue() async {
    if (_database == null || _database!.isOpen == false) {
      await initDatabase();
    }
    List<Map> queuedData = await _database!.query('queue');
    for (var item in queuedData) {
      await sendData(item['data']);
      await _database!.delete('queue', where: 'id = ?', whereArgs: [item['id']]);
    }
  }

// Listen to incoming data
  void listenToDevice() {
    String buffer = "";
    _readSubscription = _connection?.input?.listen((event) async {
      String receivedChunk = utf8.decode(event);
      buffer += receivedChunk;

      int newlineIndex = buffer.indexOf('\n');
      while (newlineIndex != -1) {
        String receivedData = buffer.substring(0, newlineIndex);
        buffer = buffer.substring(newlineIndex + 1);

        print("Received: $receivedData");
        try {
          // Parse the received data as a JSON array
          List<dynamic> logList = jsonDecode(receivedData);
          if (logList.isNotEmpty) {
            // Take the first log entry (since it's an array with one element)
            Map<String, dynamic> logData = logList[0];
            await uploadLogToFirebase(logData);
          }
        } catch (e) {
          print("Error parsing log: $e");
        }

        newlineIndex = buffer.indexOf('\n');
      }
    });
  }

// Upload log to Firebase
  Future<void> uploadLogToFirebase(Map<String, dynamic> logData) async {
    try {
      // Extract the type to determine how to handle the log
      int logType = logData['type'];

      if (logType == 0) {
        // Log type 0: Medication log
        // Extract the compartmentNumber (received as medicineID in the log)
        int compartmentNumber = logData['medicineID'];

        // Query the database to find the medication with this compartmentNumber
        String? medicationId;
        QuerySnapshot medicationsSnapshot = await FirebaseFirestore.instance
            .collection('medications')
            .where('patientId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .where('compartmentNumber', isEqualTo: compartmentNumber)
            .get();

        if (medicationsSnapshot.docs.isNotEmpty) {
          // Take the first matching medication
          medicationId = medicationsSnapshot.docs.first.id;
          print("Found medication with compartmentNumber $compartmentNumber, medicationId: $medicationId");
        } else {
          print("No medication found for compartmentNumber: $compartmentNumber");
          medicationId = "unknown";
        }

        // Save the medication log
        await SmartMedicalDb.addLog(
          logId: DateTime.now().millisecondsSinceEpoch.toString(),
          patientId: FirebaseAuth.instance.currentUser!.uid,
          medicationId: medicationId,
          status: logData['isConfirmed'] == 0 ? 'missed' : 'taken',
          spo2: logData['oxygen'] != -1 ? (logData['oxygen'] as num).toDouble() : null, // تحويل من int إلى double
          heartRate: logData['heartRate'] != -1 ? (logData['heartRate'] as num).toDouble() : null, // تحويل من int إلى double
          dayOfYear: logData['dayOfYear'],
          minutesMidnight: logData['minutesMidnight'],
        );
        print("Medication Log uploaded successfully with medicationId: $medicationId, compartmentNumber: $compartmentNumber");
      } else if (logType == 1) {
        // Log type 1: Vital signs log (heartRate, oxygen)
        await SmartMedicalDb.addLog(
          logId: DateTime.now().millisecondsSinceEpoch.toString(),
          patientId: FirebaseAuth.instance.currentUser!.uid,
          medicationId: null, // مافيش دواء مرتبط بالـ Log ده
          status: null, // مافيش حالة دواء
          spo2: logData['oxygen'] != -1 ? (logData['oxygen'] as num).toDouble() : null, // تحويل من int إلى double
          heartRate: logData['heartRate'] != -1 ? (logData['heartRate'] as num).toDouble() : null, // تحويل من int إلى double
          dayOfYear: logData['dayOfYear'],
          minutesMidnight: logData['minutesMidnight'],
        );
        print("Vital Signs Log uploaded successfully: heartRate=${logData['heartRate']}, oxygen=${logData['oxygen']}");
      } else {
        // Log type غير معروف
        print("Unknown log type: $logType, skipping...");
        return;
      }
    } catch (e) {
      print("Error uploading log: $e");
    }
  }

  // Retry timer
  void startRetryTimer() {
    Timer.periodic(Duration(seconds: 30), (timer) async {
      if (_connection != null && _connection!.isConnected) {
        await retrySendingFromQueue();
      }
    });
  }

  // Cleanup
  void dispose() {
    _scanSubscription?.cancel();
    _readSubscription?.cancel();
    _adapterStateSubscription?.cancel();
    _scanningStateSubscription?.cancel();
    _connection?.dispose();
    _database?.close();
  }
}