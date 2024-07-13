import 'dart:convert';

import 'package:dealsdray_assignment/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:http/http.dart';

final formKey = GlobalKey<FormState>();

class OtpVerificationScreen extends StatefulWidget {
  final String userId, deviceId, contact;
  const OtpVerificationScreen(
      {super.key,
      required this.deviceId,
      required this.userId,
      required this.contact});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  int minute = 1, seconds = 59;
  String? _Otp;
  TextEditingController txt1 = TextEditingController();
  TextEditingController txt2 = TextEditingController();
  TextEditingController txt3 = TextEditingController();
  TextEditingController txt4 = TextEditingController();

  void timer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        seconds--;
        if (seconds == 1) {
          seconds = 60;
          minute--;
        }
        if (minute == 0 && seconds == 1) {
          timer.cancel();
          minute = 0;
          seconds = 0;
        }
      });
    });
  }

  Future<void> senddata() async {
    Response res = await post(
        Uri.parse("http://devapiv4.dealsdray.com/api/v2/user/otp/verification"),
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          "otp": _Otp!,
          "deviceId": widget.deviceId,
          "userId": widget.userId
        }));

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => RegistrationPage(
            userId: widget.userId,
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    timer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.message,
                  size: 100,
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "OTP Verification",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                ),
                const Text(
                  "We have sent a unique number",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black45),
                ),
                Text(
                  "to your mobile ${widget.contact}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black45),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 40, top: 30),
            child: Form(
              key: formKey,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 58,
                    width: 54,
                    child: TextFormField(
                      controller: txt1,
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 2),
                            borderRadius: BorderRadius.circular(15),
                          )),
                      style: const TextStyle(
                        fontSize: 30,
                      ),
                      textAlignVertical: TextAlignVertical.top,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 58,
                    width: 54,
                    child: TextFormField(
                      controller: txt2,
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 2),
                            borderRadius: BorderRadius.circular(15),
                          )),
                      style: const TextStyle(
                        fontSize: 30,
                      ),
                      textAlignVertical: TextAlignVertical.top,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 58,
                    width: 54,
                    child: TextFormField(
                      controller: txt3,
                      onChanged: (value) {
                        if (value.length == 1) {
                          FocusScope.of(context).nextFocus();
                        }
                      },
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 2),
                            borderRadius: BorderRadius.circular(15),
                          )),
                      style: const TextStyle(
                        fontSize: 30,
                      ),
                      textAlignVertical: TextAlignVertical.top,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 58,
                    width: 54,
                    child: TextFormField(
                      controller: txt4,
                      onChanged: (value) async {
                        if (value.length == 1) {
                          _Otp = txt1.text + txt2.text + txt3.text + txt4.text;
                          await senddata();
                        }
                      },
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(width: 2),
                            borderRadius: BorderRadius.circular(15),
                          )),
                      style: const TextStyle(
                        fontSize: 30,
                      ),
                      textAlignVertical: TextAlignVertical.top,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(1),
                        FilteringTextInputFormatter.digitsOnly
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("0$minute : $seconds"),
                  TextButton(onPressed: () {}, child: const Text("Send again"))
                ],
              ))
        ],
      ),
    );
  }
}
