import 'package:chess_game/screens/login_ui/login_with_phone_ui/phone_otp.dart';
import 'package:flutter/material.dart';
import 'package:chess_game/constants/colors.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class PhoneNumber extends StatefulWidget {
  const PhoneNumber({super.key});

  @override
  State<PhoneNumber> createState() => _PhoneNumberState();
}

class _PhoneNumberState extends State<PhoneNumber> {
  final _numberController = TextEditingController();
  bool _isLoading = false;

  Future sendOtp() async {
    String number = _numberController.text.trim();
    if (number.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('number is empty')));
    } else if (number.length != 10) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('number shuld be 10 digits')));
    } else {
      try {
        print(number.length);
        _isLoading = true;
        await FirebaseAuth.instance.verifyPhoneNumber(
            verificationCompleted: (phoneAuthCredential) {},
            verificationFailed: (error) {},
            codeSent: (otp, token) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhoneOtp(
                      otp: otp,
                    ),
                  ));
            },
            codeAutoRetrievalTimeout: (otp) {},
            phoneNumber: '+977 $number');
      } catch (err) {
        print('The error is : $err');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login with Number"),
        backgroundColor: MyColor.mediumBlue300,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: MyColor.lightBlue100,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              height: 220,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: MyColor.mediumBlue300,
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Enter your phone number for OTP",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    controller: _numberController,
                    decoration: const InputDecoration(
                      labelText: "Phone number",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: MyColor.blue),
                          onPressed: () async {
                            await sendOtp();
                          },
                          child: const Text("Send OTP"),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
