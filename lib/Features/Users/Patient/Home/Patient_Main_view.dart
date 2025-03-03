import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_medic/Features/Users/Patient/Home/Widgets/Add_New_Medicine.dart';
import 'package:smart_medic/Features/Users/Patient/Home/Widgets/Refill_Medicine.dart';
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/utils/Style.dart';
import 'package:smart_medic/core/widgets/CustomBoxFilled.dart';
import 'package:smart_medic/core/widgets/CustomBoxIcon.dart';

class PatientMainView extends StatefulWidget {
  const PatientMainView({super.key});

  @override
  State<PatientMainView> createState() => _PatientMainViewState();
}

class _PatientMainViewState extends State<PatientMainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        title: Text(
          'Home Page',
          style: getTitleStyle(
              color: AppColors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        actions: [
          Image.asset(
            'assets/pills.png',
            width: 60,
            height: 35,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double itemHeight =
                (constraints.maxHeight - 55) / 4.7; // Keeps original size
            double itemWidth = (constraints.maxWidth - 36) / 2;
            double aspectRatio = itemWidth / itemHeight;

            return GridView.builder(
              physics: constraints.maxHeight > 650
                  ? const NeverScrollableScrollPhysics()
                  : const BouncingScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: aspectRatio,

              ),
              itemCount: 8,
              itemBuilder: (context, index) {
                return index == 0
                    ? CustomBoxFilled(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Refill_Medicine(),
                          ),
                        ),
                      )
                    : CustomBoxIcon(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const Add_new_Medicine(),
                          //   ),
                          // );
                        },
                        iconSize: 60, // Increase plus (+) size here
                      );
              },
            );
          },
        ),
      ),
    );
  }
}
