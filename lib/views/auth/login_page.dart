import 'dart:io';

import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../routes/route_class.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passController = TextEditingController();

  FocusNode emaiNode = FocusNode();

  FocusNode passNode = FocusNode();
  bool isPasswordVisible = false;
  bool acceptedTcs = false;

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  bool isWeakPassword(String password) {
    if (password.length < 6) {
      return true;
    }

    final commonPasswords = [
      '123456',
      'password',
      'qwerty',
      'abc123',
    ];

    if (commonPasswords.contains(password.toLowerCase())) {
      return true;
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        emaiNode.unfocus();
        passNode.unfocus();
        setState(() {});
      },
      child: Scaffold(
        backgroundColor: AppTheme.scaffoldBacgroundColor,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: AppTheme.scaffoldBacgroundColor,
          title: Text(
            "Login to your account",
            style: GoogleFonts.lato(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
                Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              //Email TextField
              Container(
                height: 50,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: emaiNode.hasFocus
                      ? AppTheme.textfieldActiveColor
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: emaiNode.hasFocus
                        ? AppTheme.textfieldActiveBorderColor
                        : Colors.transparent,
                  ),
                ),
                child: TextField(
                  controller: emailController,
                  focusNode: emaiNode,
                  keyboardType: TextInputType.emailAddress,
                  onTap: () {
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      FontAwesomeIcons.at,
                      size: 18,
                    ),
                    border: InputBorder.none,
                    hintText: "Email",
                  ),
                ),
              ),
              const SizedBox(height: 10),
              //Password TextFiled.
              Container(
                height: 50,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: passNode.hasFocus
                      ? AppTheme.textfieldActiveColor
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: passNode.hasFocus
                        ? AppTheme.textfieldActiveBorderColor
                        : Colors.transparent,
                  ),
                ),
                child: TextField(
                  controller: passController,
                  focusNode: passNode,
                  obscureText: !isPasswordVisible,
                  keyboardType: TextInputType.text,
                  onTap: () {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      FontAwesomeIcons.lock,
                      size: 18,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      icon: isPasswordVisible
                          ? const Icon(
                              FontAwesomeIcons.eye,
                              size: 18,
                            )
                          : const Icon(
                              FontAwesomeIcons.eyeSlash,
                              size: 18,
                            ),
                    ),
                    border: InputBorder.none,
                    hintText: "Password",
                  ),
                ),
              ),
              const SizedBox(height: 20),
              //Terms & Conditions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      activeColor: AppTheme.mainColor,
                      value: acceptedTcs,
                      onChanged: (value) {
                        acceptedTcs = value ?? false;
                        setState(() {});
                      },
                    ),
                    RichText(
                      text: TextSpan(
                        text: "I Accept ",
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: "terms & conditions",
                            style: GoogleFonts.lato(
                              color: AppTheme.mainColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              //Continue button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CupertinoButton(
                    borderRadius: BorderRadius.circular(10),
                    color: AppTheme.mainColor,
                    child: Text(
                      "Login",
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      if (emailController.text.trim().isEmpty ||
                          !isValidEmail(emailController.text) ||
                          passController.text.trim().isEmpty ||
                          !acceptedTcs) {
                        String errorMessage =
                            emailController.text.trim().isEmpty
                                ? "Enter your email"
                                : !isValidEmail(emailController.text)
                                    ? "Enter a valid email"
                                    : passController.text.trim().isEmpty
                                        ? "Enter your password"
                                        : "Accept Ts & Cs";

                        Get.snackbar("Error", errorMessage);
                      } else if (isWeakPassword(passController.text)) {
                        Get.snackbar("Warning", "Password is too weak");
                      } else {
                        // Continue sign-in.
                        Get.offAllNamed(RouteClass.homePage);
                      }
                    },
                  ),
                ),
              ),
              //Reset password button.
              GestureDetector(
                onTap: () {
                  Get.toNamed(RouteClass.resetPasswordPage);
                },
                child: Container(
                  height: 30,
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Forgot password? ",
                        style: GoogleFonts.lato(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: " Reset now",
                            style: GoogleFonts.lato(
                              color: AppTheme.mainColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
