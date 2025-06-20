import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Added provider import
import 'package:smart_medic/Features/Auth/Presentation/view/login.dart';
import 'package:smart_medic/Features/Role_Selection/Role_Selection.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Profile/Widgets/Supervision_view.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Profile/Widgets/Edit_Profile.dart';
import 'package:smart_medic/Features/Users/Patient/Presentation/Profile/Widgets/rewardsView.dart';
import 'package:smart_medic/LocalProvider.dart';
import 'package:smart_medic/Services/firebaseServices.dart';
import 'package:smart_medic/ShowcaseProvider.dart'; // Import ShowcaseProvider
import 'package:smart_medic/core/utils/Colors.dart';
import 'package:smart_medic/core/utils/Style.dart';
import 'package:smart_medic/generated/l10n.dart';
import '../../../../../main.dart';
import 'package:showcaseview/showcaseview.dart';

class PatientProfileView extends StatefulWidget {
  const PatientProfileView({super.key});

  @override
  State<PatientProfileView> createState() => _PatientProfileViewState();
}

class _PatientProfileViewState extends State<PatientProfileView> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  Map<String, dynamic>? userProfile;
  bool _isLoading = true;
  bool _hasStartedShowcase = false; // Flag to prevent multiple showcase starts

  // 🔑 Showcase Keys
  final GlobalKey _editKey = GlobalKey();
  final GlobalKey _darkModeKey = GlobalKey();
  final GlobalKey _supervisorKey = GlobalKey();
  final GlobalKey _languageKey = GlobalKey();
  final GlobalKey _logoutKey = GlobalKey();
  final GlobalKey _rewardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  Future<void> _getUser() async {
    setState(() {
      _isLoading = true;
    });
    user = _auth.currentUser;
    if (user != null) {
      var result = await SmartMedicalDb.getPatientProfile(user!.uid);
      if (result['success']) {
        setState(() {
          userProfile = result['data'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'],
              style: TextStyle(color: AppColors.white),
            ),
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).Patient_Profile_view_Profile),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Provider.of<ShowcaseProvider>(context).isShowcaseEnabled
                  ? Icons.visibility_off
                  : Icons.help,
            ),
            onPressed: () {
              Provider.of<ShowcaseProvider>(context, listen: false)
                  .toggleShowcase();
            },
          ),
          Image.asset(
            'assets/pills.png',
            width: 60,
            height: 35,
          ),
        ],
      ),
      body: Consumer<ShowcaseProvider>(
        builder: (context, showcaseProvider, child) {
          // Start Showcase after profile data is loaded and UI is built
          if (!_isLoading &&
              !_hasStartedShowcase &&
              showcaseProvider.isShowcaseEnabled) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                ShowCaseWidget.of(context).startShowCase([
                  _editKey,
                  _darkModeKey,
                  _supervisorKey,
                  _rewardKey,
                  _languageKey,
                  _logoutKey,
                ]);
                setState(() {
                  _hasStartedShowcase = true;
                });
              }
            });
          }

          return _isLoading
              ? const Center(child: CircularProgressIndicator())
              : user == null
                  ? Center(
                      child: Text(
                        S
                            .of(context)
                            .Patient_Profile_view_Please_log_in_to_view_your_profile,
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          // Profile Card
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 1,
                                ),
                              ],
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.cointainerDarkColor
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                // Profile Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.asset(
                                    'assets/avatar1.png',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // User Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Name: ${userProfile?['name'] ?? user?.displayName ?? 'Unknown'}',
                                        style: getbodyStyle(
                                          color: AppColors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        'Age: ${userProfile?['age']?.toString() ?? 'Not set'}',
                                        style: getbodyStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Edit Button with Showcase
                                showcaseProvider.isShowcaseEnabled
                                    ? Showcase(
                                        key: _editKey,
                                        tooltipBackgroundColor:
                                            Theme.of(context).primaryColor,
                                        textColor:
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? AppColors.white
                                                : AppColors.black,
                                        descTextStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        tooltipPadding:
                                            const EdgeInsets.all(10),
                                        description: S
                                            .of(context)
                                            .Patient_Profile_view_Tap_here_to_edit_your_profile_information,
                                        child: _buildEditButton(),
                                      )
                                    : _buildEditButton(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Settings Section
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? AppColors.cointainerDarkColor
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Dark Mode Toggle with Showcase
                                showcaseProvider.isShowcaseEnabled
                                    ? Showcase(
                                        key: _darkModeKey,
                                        tooltipBackgroundColor:
                                            Theme.of(context).primaryColor,
                                        textColor:
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? AppColors.white
                                                : AppColors.black,
                                        descTextStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        tooltipPadding:
                                            const EdgeInsets.all(10),
                                        description: S
                                            .of(context)
                                            .Patient_Profile_view_Toggle_between_light_and_dark_themes,
                                        child: _buildDarkModeTile(),
                                      )
                                    : _buildDarkModeTile(),
                                const Divider(),
                                // Supervisor Section with Showcase
                                showcaseProvider.isShowcaseEnabled
                                    ? Showcase(
                                        key: _supervisorKey,
                                        tooltipBackgroundColor:
                                            Theme.of(context).primaryColor,
                                        textColor:
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? AppColors.white
                                                : AppColors.black,
                                        descTextStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        tooltipPadding:
                                            const EdgeInsets.all(10),
                                        description: S
                                            .of(context)
                                            .Patient_Profile_view_View_or_manage_your_supervisors,
                                        child: _buildSupervisorTile(),
                                      )
                                    : _buildSupervisorTile(),
                                const Divider(),
                                // Rewards Section with Showcase
                                showcaseProvider.isShowcaseEnabled
                                    ? Showcase(
                                        key: _rewardKey,
                                        tooltipBackgroundColor:
                                            Theme.of(context).primaryColor,
                                        textColor:
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? AppColors.white
                                                : AppColors.black,
                                        descTextStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        tooltipPadding:
                                            const EdgeInsets.all(10),
                                        description: S
                                            .of(context)
                                            .Patient_Profile_view_reward,
                                        child: _buildRewardsTile(),
                                      )
                                    : _buildRewardsTile(),
                                const Divider(),
                                // Language Change Option with Showcase
                                showcaseProvider.isShowcaseEnabled
                                    ? Showcase(
                                        key: _languageKey,
                                        tooltipBackgroundColor:
                                            Theme.of(context).primaryColor,
                                        textColor:
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? AppColors.white
                                                : AppColors.black,
                                        descTextStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        tooltipPadding:
                                            const EdgeInsets.all(10),
                                        description: S
                                            .of(context)
                                            .Patient_Profile_view_Switch_between_languages,
                                        child:
                                            _buildLanguageTile(localeProvider),
                                      )
                                    : _buildLanguageTile(localeProvider),
                                const Divider(),
                                // Log out with Showcase
                                showcaseProvider.isShowcaseEnabled
                                    ? Showcase(
                                        key: _logoutKey,
                                        tooltipBackgroundColor:
                                            Theme.of(context).primaryColor,
                                        textColor:
                                            Theme.of(context).brightness ==
                                                    Brightness.dark
                                                ? AppColors.white
                                                : AppColors.black,
                                        descTextStyle: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        tooltipPadding:
                                            const EdgeInsets.all(10),
                                        description: S
                                            .of(context)
                                            .Patient_Profile_view_Sign_out_of_your_account,
                                        child: _buildLogoutTile(),
                                      )
                                    : _buildLogoutTile(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
        },
      ),
    );
  }

  // Helper method for Edit Button
  Widget _buildEditButton() {
    return IconButton(
      icon: Icon(
        Icons.edit,
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.mainColorDark
            : AppColors.mainColor,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Edit_Profile(),
          ),
        ).then((_) => _getUser()); // Refresh profile after edit
      },
    );
  }

  // Helper method for Dark Mode Tile
  Widget _buildDarkModeTile() {
    return ListTile(
      leading: Icon(
        Icons.dark_mode,
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.mainColorDark
            : AppColors.mainColor,
      ),
      title: Text(S.of(context).Patient_Profile_view_Dark_Mode),
      trailing: ValueListenableBuilder<ThemeMode>(
        valueListenable: MainApp.themeNotifier,
        builder: (context, currentMode, child) {
          return Switch(
            value: currentMode == ThemeMode.dark,
            onChanged: (value) {
              MainApp.themeNotifier.value =
                  value ? ThemeMode.dark : ThemeMode.light;
            },
          );
        },
      ),
    );
  }

  // Helper method for Supervisor Tile
  Widget _buildSupervisorTile() {
    return ListTile(
      leading: Icon(
        Icons.supervisor_account,
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.mainColorDark
            : AppColors.mainColor,
      ),
      title: Text(S.of(context).Patient_Profile_view_Supervisor),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const SupervisorsScreen(),
          ),
        );
      },
    );
  }

  // Helper method for Rewards Tile
  Widget _buildRewardsTile() {
    return ListTile(
      leading: Icon(
        Icons.card_giftcard,
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.mainColorDark
            : AppColors.mainColor,
      ),
      title: Text(S.of(context).Patient_Profile_view_Rewards),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RewardsView(patientId: user!.uid),
          ),
        );
      },
    );
  }

  // Helper method for Language Tile
  Widget _buildLanguageTile(LocaleProvider localeProvider) {
    return ListTile(
      leading: Icon(
        Icons.language,
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.mainColorDark
            : AppColors.mainColor,
      ),
      title: Text(S.of(context).Patient_Profile_view_Change_Language),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        if (localeProvider.locale.languageCode == 'en') {
          localeProvider.setLocale(const Locale('ar'));
        } else {
          localeProvider.setLocale(const Locale('en'));
        }
      },
    );
  }

  // Helper method for Logout Tile
  Widget _buildLogoutTile() {
    return ListTile(
      leading: Icon(
        Icons.logout,
        color: Theme.of(context).brightness == Brightness.dark
            ? AppColors.mainColorDark
            : AppColors.mainColor,
      ),
      title: Text(S.of(context).Patient_Profile_view_Log_out),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: _signOut,
    );
  }
}
