import 'dart:io';

import 'package:chat_mate_messanger/theme/app_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPasswordPage extends StatefulWidget {
  ResetPasswordPage({Key? key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController emailController = TextEditingController();
  FocusNode emailNode = FocusNode();
  bool isValidEmail = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        emailNode.unfocus();
        setState(() {});
      },
      child: Scaffold(
        backgroundColor: AppTheme.scaffoldBacgroundColor,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: AppTheme.scaffoldBacgroundColor,
          title: Text(
            "Reset Password", // Change the title to "Reset Password"
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
              // Email TextField for resetting password
              Container(
                height: 50,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 8.0),
                decoration: BoxDecoration(
                  color: emailNode.hasFocus
                      ? AppTheme.textfieldActiveColor
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: emailNode.hasFocus
                        ? AppTheme.textfieldActiveBorderColor
                        : Colors.transparent,
                  ),
                ),
                child: TextField(
                  controller: emailController,
                  focusNode: emailNode,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (text) {
                    setState(() {
                      isValidEmail = isEmailValid(text);
                    });
                  },
                  onTap: () {
                    setState(() {});
                  },
                  decoration: InputDecoration(
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
              // Reset Password button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CupertinoButton(
                    borderRadius: BorderRadius.circular(10),
                    color: AppTheme.mainColor,
                    child: Text(
                      "Reset Password", // Change button text to "Reset Password"
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      if (isValidEmail) {
                        // Add your reset password logic here.
                      } else {
                        Get.snackbar("Error", "Enter a valid email");
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isEmailValid(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }
}
