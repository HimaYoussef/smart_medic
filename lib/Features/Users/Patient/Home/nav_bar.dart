import 'package:flutter/material.dart';
import 'package:smart_medic/Features/Users/Patient/Home/Patient_Main_view.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Awareness/Patient_Awareness_view.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Logs/Patient_Logs_View..dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Profile/Patient_Profile_view.dart';
import 'package:smart_medic/core/utils/Colors.dart';

class PatientHomeView extends StatefulWidget {
  const PatientHomeView({super.key});

  @override
  _PatientHomeViewState createState() => _PatientHomeViewState();
}

class _PatientHomeViewState extends State<PatientHomeView> {
  int currentIndex = 0;

  final List<Widget> screens = [
    const PatientMainView(),
    const PatientLogsView(),
    const PatientAwarenessView(),
    const PatientProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
        height: 53,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 4,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index)=>setState(() => currentIndex= index,),
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.nav_parColor
                : AppColors.nav_parColor,
            elevation: 0,
            items:  [
              BottomNavigationBarItem(
                icon:const SizedBox(height:18,child: Icon(Icons.home,),),
                label: "",
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.mainColorDark
                    : AppColors.nav_parColor,
              ),
              BottomNavigationBarItem(
                icon: const SizedBox(height:18,child: Icon(Icons.access_time,),),
                label: "",
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.mainColorDark
                    : AppColors.nav_parColor,
              ),
              BottomNavigationBarItem(
                icon:const SizedBox(height:18,child: Icon(Icons.article, ),),
                label: "",
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.mainColorDark
                    : AppColors.nav_parColor,
              ),
               BottomNavigationBarItem(
                icon:const SizedBox(height:18,child: Icon(Icons.person,),),
                label: "",
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? AppColors.mainColorDark
                    : AppColors.nav_parColor,
              ),
            ],
          ),
        ),
      ),
      body: screens[currentIndex],
    );
  }
}