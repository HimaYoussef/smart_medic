import 'package:flutter/material.dart';
import 'package:smart_medic/core/utils/Style.dart';

class NoScheduledWidget extends StatelessWidget {
  const NoScheduledWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/_booking_success.png',
            width: MediaQuery.of(context).size.width,
          ),
          Text('You didn\'t book any pitch', style: getbodyStyle()),
        ],
      ),
    );
  }
}
