import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'notificationService.dart';

class RewardsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final LocalNotificationService _notificationService = LocalNotificationService();

  // List of pharmacies
  final List<String> _pharmacies = [
    'Al-Shifa Pharmacy',
    'Al-Noor Pharmacy',
    'Al-najah Pharmacy',
    'Future Pharmacy',
    'Al-salama Pharmacy',
    'Al\'aml Pharmacy',
    'Al-haqiqa Pharmacy',
    'El-Ezaby Pharmacy',
  ];

  // Generate random promo code
  String _generatePromoCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        8, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  // Select random pharmacy
  String _selectRandomPharmacy() {
    return _pharmacies[Random().nextInt(_pharmacies.length)];
  }

// Check reward eligibility and generate reward
  Future<void> checkRewardEligibility(String patientId, int currentStreak) async {
    final milestones = {5: 5, 10: 10, 15: 15, 20: 20, 25: 25, 30: 30};
    if (milestones.containsKey(currentStreak)) {
      await _generateReward(patientId, milestones[currentStreak]!);
    }
    // Reset streak after 30
    if (currentStreak == 30) {
      await _firestore.collection('users').doc(patientId).update({
        'currentStreak': 0,
      });
    }
  }

  // Generate reward
  Future<void> _generateReward(String patientId, int discountPercentage) async {
    final reward = {
      'patientId': patientId,
      'discountPercentage': discountPercentage,
      'promoCode': _generatePromoCode(),
      'pharmacyName': _selectRandomPharmacy(),
      'earnedAt': Timestamp.now(),
      'expiryDate': Timestamp.fromDate(DateTime.now().add(const Duration(days: 30))),
      'status': 'pending',
    };
    final rewardRef = await _firestore.collection('rewards').add(reward);

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'rewards_channel',
      'Rewards Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

    await LocalNotificationService.flutterLocalNotificationsPlugin.show(
      reward['promoCode'].hashCode,
      'Congratulations You\'ve earned a reward!',
      'discount $discountPercentage% in ${reward['pharmacyName']}. Code: ${reward['promoCode']}',
      notificationDetails,
      payload: 'reward|${rewardRef.id},$patientId',
    );
  }

// Mark reward as used
  Future<void> markRewardAsUsed(String rewardId) async {
    await _firestore.collection('rewards').doc(rewardId).update({
      'status': 'used',
    });
  }
}