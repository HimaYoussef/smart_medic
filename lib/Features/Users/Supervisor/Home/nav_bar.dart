import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_medic/Features/Users/Supervisor/Home/Supervior_Main_view.dart';
import 'package:smart_medic/Features/Users/Supervisor/Presentation/Awareness/Supervior_Awareness_view.dart';
import 'package:smart_medic/Features/Users/Supervisor/Presentation/Profile/Supervior_Profile_view.dart';
import 'package:smart_medic/core/utils/Colors.dart';

class SupervisorHomeView extends StatefulWidget {
  const SupervisorHomeView({super.key});

  @override
  _SupervisorHomeViewState createState() => _SupervisorHomeViewState();
}

class _SupervisorHomeViewState extends State<SupervisorHomeView> {
  int currentIndex = 0;

  final List<Widget> screens = [
    const Supervior_Main_view(),
    const Supervisor_Awareness_View(),
    const Supervior_Profile_view(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 17, vertical: 20),
        height: 53,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.nav_parColor
              : AppColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
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
                ? AppColors.mainColorDark
                : AppColors.white,
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
