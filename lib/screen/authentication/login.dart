import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plantify/screen/authentication/register.dart';
import 'package:plantify/screen/home/main.dart';
import 'package:plantify/theme/colors.dart';
import 'package:plantify/theme/fonts.dart';
import 'package:plantify/util/container.dart';
import 'package:plantify/util/form.dart';
import 'package:plantify/util/layout.dart';
import 'package:plantify/util/text.dart';
import 'package:icons_flutter/icons_flutter.dart';

import '../../backend/firebase/authenication.dart';
import '../../backend/firestore/firestore.dart';
import '../../main.dart';
import '../../storage/preferences.dart';
import '../../util/navigation.dart';
import '../../util/snackbar.dart';
import '../../util/string.dart';
import '../home/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuthService firebaseAuthService = FirebaseAuthService();
  FirestoreService firestoreService = FirestoreService();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String error = "";

  bool showPassword = false;

  void login() async {
    String result;
    String email = extractFromController(emailController);
    String password = extractFromController(passwordController);
    result = await firebaseAuthService.login(
      email,
      password,
    );
    if (result == "Success") {
      setState(() {
        error = "";
      });
      showSnackBar();

      Map<String, dynamic> userData = firestoreService.getOnlyFromMap(await firestoreService.loadWhere(
        collection: 'users',
        field: 'email',
        isEqualTo: email,
      ));

      savePreferencesOnMap('userData', userData);
      savePreferencesOnBool('isLogin', true);

      navigateTo(
        context,
        animationType: NavAnimation.slideLeft,
        duration: preferredAnimations.getDuration(),
        replace: true,
        page: MainHomeScreen(),
      );
    } else {
      setState(() {
        error = result;
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
        "Logged In!",
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
          margin: EdgeInsets.symmetric(horizontal: 30, vertical: 72),
          children: [
            //header
            UtilFlexBox(
              gap: 5,
              children: [
                UtilText(
                  "Welcome Back!",
                  color: colorAccent.primaryText,
                  size: 30,
                  family: Fonts.defaultFontBold,
                ),
                UtilText(
                  "Login to continue managing your plants, track your plants, and build your digital garden.",
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
                      "Email",
                      color: colorAccent.primaryText,
                      size: 19,
                      family: Fonts.defaultFontRegular,
                    ),
                    UtilInputBox(
                      controller: emailController,
                      height: 60,
                      width: double.maxFinite,
                      color: colorAccent.cardLight,
                      borderRadius: BorderRadius.circular(12),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      prefix: Icon(
                        Icons.email_outlined,
                        size: 20,
                        color: colorAccent.cardDark,
                      ),
                      hint: "Enter your Email",
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
                      "Password",
                      color: colorAccent.primaryText,
                      size: 19,
                      family: Fonts.defaultFontRegular,
                    ),
                    UtilInputBox(
                      controller: passwordController,
                      height: 60,
                      width: double.maxFinite,
                      color: colorAccent.cardLight,
                      borderRadius: BorderRadius.circular(12),
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      prefix: Icon(
                        Icons.lock_outline_rounded,
                        size: 20,
                        color: colorAccent.cardDark,
                      ),
                      suffix: UtilContainer(
                        onTap: () => {
                          setState(() {
                            showPassword = !showPassword;
                          }),
                        },
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                        borderRadius: BorderRadius.circular(50),
                        child: Icon(
                          showPassword
                              ? MaterialCommunityIcons.eye_outline
                              : MaterialCommunityIcons.eye_off_outline,
                          size: 20,
                          color: colorAccent.cardDark,
                        ),
                      ),
                      hint: "Enter your Password",
                      fontSize: 18,
                      obscureText: !showPassword,
                      textColor: colorAccent.primaryText,
                      hintColor: colorAccent.cardDark,
                      fonts: Fonts.defaultFontRegular,
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
                login();
              },
              height: 60,
              width: double.maxFinite,
              borderRadius: BorderRadius.circular(100),
              color: colorAccent.primary,
              alignment: Alignment.center,
              child: UtilText(
                "Log In",
                family: Fonts.defaultFontThin,
                size: 18,
                color: colorAccent.white,
              ),
            ),

            UtilText(
              "Don't have an account? Sign In",
              onTap: () => navigateTo(
                context,
                animationType: NavAnimation.slideLeft,
                duration: preferredAnimations.getDuration(),
                replace: true,
                page: RegisterScreen(),
              ),
              align: TextAlign.center,
              color: colorAccent.secondaryText,
              size: 17,
              family: Fonts.defaultFontRegular,
            ),

            UtilContainer(
              height: 60,
              width: double.maxFinite,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: colorAccent.cardDark, width: 1.3),
              alignment: Alignment.center,
              child: UtilText(
                "Continue with Google",
                prefix: UtilContainer(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  height: 35,
                  width: 35,
                  child: SvgPicture.asset('assets/images/icons/svg/google.svg'),
                ),
                family: Fonts.defaultFontThin,
                color: colorAccent.primaryText,
                size: 18,
              ),
            ),

            UtilFlexBox(
              margin: EdgeInsets.symmetric(vertical: 10),
              direction: Axis.horizontal,
              gap: 20,
              main: MainAxisAlignment.spaceEvenly,
              children: [
                UtilText(
                  "Privacy Policy",
                  onTap: () => debugPrint("sss"),
                  align: TextAlign.center,
                  color: colorAccent.secondaryText,
                  size: 17,
                  family: Fonts.defaultFontRegular,
                ),
                UtilText(
                  "Terms of Service",
                  onTap: () => debugPrint("sss"),
                  align: TextAlign.center,
                  color: colorAccent.secondaryText,
                  size: 17,
                  family: Fonts.defaultFontRegular,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
