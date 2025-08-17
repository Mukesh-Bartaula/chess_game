import 'package:chess_game/screens/game_board.dart';
import 'package:flutter/material.dart';
import 'package:chess_game/constants/colors.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class PhoneOtp extends StatefulWidget {
  String otp;
  PhoneOtp({super.key, required this.otp});

  @override
  State<PhoneOtp> createState() => _PhoneOtpState();
}

class _PhoneOtpState extends State<PhoneOtp> {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor.lightBlue100,
      appBar: AppBar(title: const Text("Login Number")),
      body: Container(
        decoration: BoxDecoration(
          color: MyColor.lightBlue100,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Container(
              height: 240,
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
                    controller: _otpController,
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
                            String OTP = _otpController.text.trim();
                            if (OTP.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('OTP is empty')));
                            } else {
                              try {
                                PhoneAuthCredential credential =
                                    PhoneAuthProvider.credential(
                                        verificationId: widget.otp,
                                        smsCode: OTP);
                                await FirebaseAuth.instance
                                    .signInWithCredential(credential)
                                    .then(
                                      (value) => {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const GameBoard(),
                                            ))
                                      },
                                    );
                              } catch (err) {
                                print('$err');
                              }
                            }
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
