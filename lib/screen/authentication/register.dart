import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:plantify/backend/firestore/firestore.dart';
import 'package:plantify/screen/authentication/setup.dart';
import 'package:plantify/theme/colors.dart';
import 'package:plantify/theme/fonts.dart';
import 'package:plantify/util/container.dart';
import 'package:plantify/util/form.dart';
import 'package:plantify/util/layout.dart';
import 'package:plantify/util/string.dart';
import 'package:plantify/util/text.dart';
import 'package:icons_flutter/icons_flutter.dart';

import '../../main.dart';
import '../../util/navigation.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  FirestoreService firestoreService = FirestoreService();
  
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String error = "";

  bool showPassword = false;
  bool showConfirmPassword = false;

  void signUp() async {
  String email = extractFromController(emailController);
  String password = extractFromController(passwordController);
  String confirmPassword = extractFromController(confirmPasswordController);

  // ── Validation (no async needed) ─────────────────────────
  if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
    setState(() => error = "Please fill all the inputs.");
    return;
  }

  if (!isValidEmail(email)) {
    setState(() => error = "Invalid email format.");
    return;
  }

  if (password.length < 6) {
    setState(() => error = "Password must be more than 6 characters.");
    return;
  }

  if (password != confirmPassword) {
    setState(() => error = "Password confirmation does not match.");
    return;
  }

  // ── Internet check ───────────────────────────────────────
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isEmpty || result[0].rawAddress.isEmpty) {
      setState(() => error = "No internet connection.");
      return;
    }
  } on SocketException {
    setState(() => error = "No internet connection.");
    return;
  }

  // ── Firebase check ───────────────────────────────────────
  try {
    final emails = await firestoreService.loadAllPickKey<String>(
      collection: 'users',
      key: 'email',
    );

    if (emails.contains(email)) {
      setState(() => error = "Email is already taken.");
      return;
    }
  } catch (e) {
    setState(() => error = "Something went wrong. Please try again.");
    return;
  }

  setState(() => error = "");
  navigateTo(
    context,
    animationType: NavAnimation.slideLeft,
    duration: preferredAnimations.getDuration(),
    page: SetupScreen(email: email, password: password),
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
                  "Ready to Grow?",
                  color: colorAccent.primaryText,
                  size: 30,
                  family: Fonts.defaultFontBold,
                ),
                UtilText(
                  "Sign up to explore plant guides, track your plants, and build your digital garden.",
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

                UtilFlexBox(
                  gap: 10,
                  children: [
                    UtilText(
                      "Confirm Password",
                      color: colorAccent.primaryText,
                      size: 19,
                      family: Fonts.defaultFontRegular,
                    ),
                    UtilInputBox(
                      controller: confirmPasswordController,
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
                            showConfirmPassword = !showConfirmPassword;
                          }),
                        },
                        height: 30,
                        width: 30,
                        alignment: Alignment.center,
                        borderRadius: BorderRadius.circular(50),
                        child: Icon(
                          showConfirmPassword
                              ? MaterialCommunityIcons.eye_outline
                              : MaterialCommunityIcons.eye_off_outline,
                          size: 20,
                          color: colorAccent.cardDark,
                        ),
                      ),
                      hint: "Confirm your Password",
                      fontSize: 18,
                      obscureText: !showConfirmPassword,
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
                signUp();
              },
              height: 60,
              width: double.maxFinite,
              borderRadius: BorderRadius.circular(100),
              color: colorAccent.primary,
              alignment: Alignment.center,
              child: UtilText(
                "Sign Up",
                family: Fonts.defaultFontThin,
                size: 18,
                color: colorAccent.white,
              ),
            ),

            UtilText(
              "Already have an account? Log In",
              onTap: () => navigateTo(
                context,
                animationType: NavAnimation.slideLeft,
                duration: preferredAnimations.getDuration(),
                replace: true,
                page: LoginScreen(),
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
                  onTap: () {},
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
