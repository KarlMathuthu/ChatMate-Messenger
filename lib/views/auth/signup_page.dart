import 'dart:io';

import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:chat_mate_messanger/views/auth/profile_setup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/remove_spaces_formatter.dart';

class CreateAccountPage extends StatefulWidget {
  CreateAccountPage({Key? key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();

  FocusNode emaiNode = FocusNode();
  FocusNode nameNode = FocusNode();
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
        nameNode.unfocus();
        passNode.unfocus();
        setState(() {});
      },
      child: Scaffold(
        backgroundColor: AppTheme.scaffoldBacgroundColor,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: AppTheme.scaffoldBacgroundColor,
          title: Text(
            "Create Account",
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
              // Email TextField
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
              // Name TextField
              Container(
                height: 50,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: nameNode.hasFocus
                      ? AppTheme.textfieldActiveColor
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: nameNode.hasFocus
                        ? AppTheme.textfieldActiveBorderColor
                        : Colors.transparent,
                  ),
                ),
                child: TextField(
                  controller: nameController,
                  focusNode: nameNode,
                  keyboardType: TextInputType.text,
                  inputFormatters: [NoSpaceFormatter()],
                  onTap: () {
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      FontAwesomeIcons.user,
                      size: 18,
                    ),
                    border: InputBorder.none,
                    hintText: "username",
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Password TextField
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
              // Terms & Conditions
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
              // Continue button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CupertinoButton(
                    borderRadius: BorderRadius.circular(10),
                    color: AppTheme.mainColor,
                    child: Text(
                      "Continue",
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      if (emailController.text.trim().isEmpty ||
                          !isValidEmail(emailController.text) ||
                          nameController.text
                              .trim()
                              .isEmpty || // Check for Name
                          passController.text.trim().isEmpty ||
                          !acceptedTcs) {
                        String errorMessage = emailController.text
                                .trim()
                                .isEmpty
                            ? "Enter your email"
                            : !isValidEmail(emailController.text)
                                ? "Enter a valid email"
                                : nameController.text
                                        .trim()
                                        .isEmpty // Update error message for Name
                                    ? "Enter your name" // Update error message for Name
                                    : passController.text.trim().isEmpty
                                        ? "Enter your password"
                                        : "Accept Ts & Cs";

                        Get.snackbar("Error", errorMessage);
                      } else if (isWeakPassword(passController.text)) {
                        Get.snackbar("Warning", "Password is too weak");
                      } else {
                        Get.to(
                          () => ProfileSetupPage(
                            email: emailController.text.trim(),
                            password: passController.text.trim(),
                            userName: nameController.text.trim(),
                          ),
                          transition: Transition.rightToLeft,
                        );
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              //Terms & conditions.
              RichText(
                textAlign: TextAlign.start,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "By clicking continue you agree to",
                      style: GoogleFonts.lato(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                    TextSpan(
                      text: " Our terms & conditions",
                      style: GoogleFonts.lato(
                        color: AppTheme.mainColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
