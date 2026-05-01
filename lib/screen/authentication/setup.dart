import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:plantify/backend/firebase/authenication.dart';
import 'package:plantify/backend/firestore/firestore.dart';
import 'package:plantify/screen/home/main.dart';
import 'package:plantify/storage/preferences.dart';
import 'package:plantify/theme/colors.dart';
import 'package:plantify/theme/fonts.dart';
import 'package:plantify/util/container.dart';
import 'package:plantify/util/date.dart';
import 'package:plantify/util/form.dart';
import 'package:plantify/util/layout.dart';
import 'package:plantify/util/miscellaneous.dart';
import 'package:plantify/util/string.dart';
import 'package:plantify/util/text.dart';
import 'package:icons_flutter/icons_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../main.dart';
import '../../util/navigation.dart';
import '../../util/snackbar.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key, required this.email, required this.password});

  final String email;
  final String password;

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  FirestoreService firestoreService = FirestoreService();
  var uuid = Uuid();

  String error = "";
  int age = 0;
  bool birthdateUpdated = false;
  final usernameController = TextEditingController();
  final birthdateController = UtilDateController(null);

  Future<void> submit() async {
    String username = extractFromController(usernameController);
    DateTime? birthdate = birthdateController.value;
    String authResult;
    String email = widget.email;
    String password = widget.password;

    if (username.isEmpty || birthdateController.value == null) {
      setState(() {
        error = "Please fill all the inputs.";
      });
      return;
    }

    String uuidTemp = uuid.v4();
    DateTime nowTemp = DateTime.now();

    Map<String, dynamic> userData = {
        'uuid': uuidTemp,
        'email': email,
        'username': username,
        'birthdate': birthdate?.toString(),
        'age':age,
        'createdAt': nowTemp.toString(),
        'garden':'[]',
        'reminder':'[]',
        'preferredWeather': '',
        'profile_url':''
      };

    authResult = await firebaseAuthService.signUp(email, password);

    firestoreService.addData(
      collection: 'users',
      data: userData,
    );

    if (authResult == "Success") {
      setState(() {
        error = "";
      });
      showSnackBar();

      savePreferencesOnMap('userData', userData);
      savePreferencesOnBool('isLogin', true);

      debugPrint("\n\n\n\n\n\n\n\n${await loadPreferencesOnString('userData', '')}");

      navigateTo(
        context,
        animationType: NavAnimation.slideLeft,
        duration: preferredAnimations.getDuration(),
        page: MainHomeScreen(),
      );
    } else {
      setState(() {
        error = authResult;
      });
    }
  }

  void showSnackBar() {
    showUtilSnackBar(
      context,
      duration: 2000,
      animationDuration: 200,
      color: colorAccent.cardDark,
      boxShadow: [
        BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.3), blurRadius: 5),
      ],
      width: 300,
      content: UtilText(
        "Account Created Successfully!",
        align: TextAlign.center,
        family: Fonts.defaultFontRegular,
        color: colorAccent.primaryText,
        size: 15,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorAccent.background,
      body: SingleChildScrollView(
        child: UtilFlexBox(
          direction: Axis.vertical,
          cross: CrossAxisAlignment.stretch,
          gap: 25,
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 90),
          children: [
            //header
            UtilFlexBox(
              gap: 5,
              children: [
                UtilText(
                  "Almost there!",
                  color: colorAccent.primaryText,
                  size: 30,
                  family: Fonts.defaultFontBold,
                ),
                UtilText(
                  widget.email,
                  color: colorAccent.secondaryText,
                  size: 18,
                  family: Fonts.defaultFontThin,
                ),
                UtilText(
                  "Just your name and birthdate, and we’re ready to go.",
                  color: colorAccent.secondaryText,
                  size: 15,
                  family: Fonts.defaultFontThin,
                ),
              ],
            ),

            //form
            UtilFlexBox(
              gap: 10,
              children: [
                UtilFlexBox(
                  gap: 10,
                  children: [
                    UtilText(
                      "Enter your Username",
                      color: colorAccent.primaryText,
                      size: 19,
                      family: Fonts.defaultFontRegular,
                    ),
                    UtilInputBox(
                      controller: usernameController,
                      height: 60,
                      width: double.maxFinite,
                      color: colorAccent.cardLight,
                      borderRadius: BorderRadius.circular(12),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      prefix: Icon(
                        Icons.person_2_rounded,
                        size: 20,
                        color: colorAccent.cardDark,
                      ),
                      suffix: UtilContainer(
                        onTap: () => {
                          setState(() {
                            usernameController.text = generateUsername();
                          }),
                        },
                        height: 40,
                        width: 40,
                        alignment: Alignment.center,
                        borderRadius: BorderRadius.circular(50),
                        child: Icon(
                          FontAwesome5Icon.dice,
                          size: 20,
                          color: colorAccent.cardDark,
                        ),
                      ),
                      hint: "Enter your Username",
                      fontSize: 18,
                      textColor: colorAccent.primaryText,
                      hintColor: colorAccent.cardDark,
                      fonts: Fonts.defaultFontRegular,
                    ),
                  ],
                ),

                UtilFlexBox(
                  gap: 10,
                  children: [
                    UtilText(
                      "Enter your Birthdate",
                      color: colorAccent.primaryText,
                      size: 19,
                      family: Fonts.defaultFontRegular,
                    ),
                    if (birthdateUpdated)
                      UtilText(
                        "You are $age years old",
                        color: colorAccent.secondaryText,
                        size: 13,
                        family: Fonts.defaultFontRegular,
                      ),
                    UtilDateInput(
                      controller: birthdateController,
                      height: 60,
                      width: double.maxFinite,
                      color: colorAccent.cardLight,
                      borderRadius: BorderRadius.circular(12),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      prefix: Icon(
                        Icons.calendar_month_rounded,
                        size: 20,
                        color: colorAccent.cardDark,
                      ),
                      fontSize: 18,
                      fonts: Fonts.defaultFontRegular,
                      textColor: colorAccent.primaryText,
                      lastDate: DateTime.now(),
                      onChanged: (date) {
                        age = calculateAge(date);
                        birthdateUpdated = true;
                        setState(() {});
                      },
                    ),
                  ],
                ),
                UtilText(
                  error,
                  color: colorAccent.error,
                  size: 15,
                  family: Fonts.defaultFontThin,
                ),
              ],
            ),

            UtilContainer(
              onTap: () {
                submit();
              },
              height: 60,
              width: double.maxFinite,
              borderRadius: BorderRadius.circular(100),
              color: colorAccent.primary,
              alignment: Alignment.center,
              child: UtilText(
                "Submit",
                family: Fonts.defaultFontThin,
                size: 18,
                color: colorAccent.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
