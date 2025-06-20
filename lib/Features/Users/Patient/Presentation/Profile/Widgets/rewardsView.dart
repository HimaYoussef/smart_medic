import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/utils/Style.dart';
import 'package:smart_medic/generated/l10n.dart';
import '../../../../../../Services/firebaseServices.dart';
import '../../../../../../Services/rewardsService.dart';


class RewardsView extends StatefulWidget {
  final String patientId;
  const RewardsView({super.key, required this.patientId});

  @override
  State<RewardsView> createState() => _RewardsViewState();
}

class _RewardsViewState extends State<RewardsView> {
  final RewardsService _rewardsService = RewardsService();
  late Future<Map<String, dynamic>> _userData;

  @override
  void initState() {
    super.initState();
    _userData = SmartMedicalDb.getPatientProfile(widget.patientId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(S.of(context).rewardsView_Rewards),
        centerTitle: true,
        elevation: 0,
        actions: [
          Image.asset(
            'assets/pills.png',
            width: 60,
            height: 35,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Progress Indicator with Markers
            FutureBuilder<Map<String, dynamic>>(
              future: _userData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (snapshot.hasError || !snapshot.hasData || !snapshot.data!['success']) {
                  return  Text(S.of(context).rewardsView_Error_loading_Rewards);
                }
                final currentStreak = snapshot.data!['data']['currentStreak'] ?? 0;
                final progress = currentStreak / 30.0;

                return Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Circular Progress with Markers
                        CustomPaint(
                          size: const Size(120, 120),
                          painter: ProgressPainter(
                            progress: progress,
                            milestones: [5, 10, 15, 20, 25, 30],
                            maxStreak: 30,
                            context: context,
                          ),
                        ),
                        Text(
                          '$currentStreak/30',
                          style: getbodyStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                     S.of(context).rewardsView_your_streak,
                      style: getbodyStyle(fontSize: 14),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
            // Rewards Grid
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('rewards')
                    .where('patientId', isEqualTo: widget.patientId)
                    .where('status', isEqualTo: 'pending')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return  Center(child: Text(S.of(context).rewardsView_Error_loading_Rewards));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return  Center(child: Text(S.of(context).rewardsView_No_rewards_available));
                  }

                  final rewards = snapshot.data!.docs;

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemCount: rewards.length,
                    itemBuilder: (context, index) {
                      final reward = rewards[index].data() as Map<String, dynamic>;
                      final rewardId = rewards[index].id;
                      final expiryDate = (reward['expiryDate'] as Timestamp).toDate();
                      final isExpired = expiryDate.isBefore(DateTime.now());

                      if (isExpired && reward['status'] == 'pending') {
                        FirebaseFirestore.instance
                            .collection('rewards')
                            .doc(rewardId)
                            .update({'status': 'expired'});
                        return const SizedBox.shrink();
                      }

                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reward['pharmacyName'],
                                style: getbodyStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? AppColors.white
                                      : AppColors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'discount ${reward['discountPercentage']}%',
                                style: getbodyStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Code: ${reward['promoCode']}',
                                style: getbodyStyle(fontSize: 12),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                'Until expiration: ${expiryDate.day}/${expiryDate.month}/${expiryDate.year}',
                                style: getbodyStyle(fontSize: 12, color: Colors.grey),
                              ),
                              const Spacer(),
                              Center(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await _rewardsService.markRewardAsUsed(rewardId);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                       SnackBar(content: Text(S.of(context).rewardsView_Rewards_has_been_used)),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).brightness == Brightness.dark
                                        ? AppColors.mainColorDark
                                        : AppColors.mainColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    S.of(context).rewardsView_Use,
                                    style: getbodyStyle(color: AppColors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter for Circular Progress with Markers
class ProgressPainter extends CustomPainter {
  final double progress;
  final List<int> milestones;
  final int maxStreak;
  final BuildContext context;

  ProgressPainter({
    required this.progress,
    required this.milestones,
    required this.maxStreak,
    required this.context,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 8.0;

    // Background Circle
    final backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress Arc
    final progressPaint = Paint()
      ..color = Theme.of(context).brightness == Brightness.dark
          ? AppColors.mainColorDark
          : AppColors.mainColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      progressPaint,
    );

    // Milestones Markers
    final markerPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;
    for (var milestone in milestones) {
      final milestoneProgress = milestone / maxStreak;
      final angle = 2 * pi * milestoneProgress - pi / 2;
      final markerOffset = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      canvas.drawCircle(markerOffset, 4, markerPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}