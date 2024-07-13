import 'dart:async';
import 'dart:convert';

import 'package:dealsdray_assignment/otp_verification_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

final formKey = GlobalKey<FormState>();

class mainScreen extends StatefulWidget {
  final String? deviceid;
  const mainScreen({super.key, @required this.deviceid});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  final List<bool> _selected = [true, false];
  String? _deviceID, _userID;

  TextEditingController tec = TextEditingController();

  Future<void> sendData() async {
    Response res = await post(
        Uri.parse("http://devapiv4.dealsdray.com/api/v2/user/otp"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          "mobileNumber": tec.text,
          "deviceId": _deviceID!
        }));

    Map data = jsonDecode(res.body);
    _userID = data['data']['userId'];
  }

  bool type = true;

  @override
  void initState() {
    super.initState();
    _deviceID = widget.deviceid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 100.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/OIP.jpg",
                  width: 200,
                  height: 200,
                  opacity: const AlwaysStoppedAnimation(.5)),
              ToggleButtons(
                  selectedColor: Colors.white,
                  fillColor: Colors.red,
                  isSelected: _selected,
                  renderBorder: false,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _selected[0] = !_selected[0];
                          _selected[1] = !_selected[1];
                          type = !type;
                        });
                      },
                      style: TextButton.styleFrom(
                          foregroundColor:
                              _selected[0] ? Colors.white : Colors.black,
                          backgroundColor:
                              _selected[0] ? Colors.red : Colors.white,
                          minimumSize: const Size(20, 50),
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)))),
                      child: const Text("Phone"),
                    ),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _selected[1] = !_selected[1];
                            _selected[0] = !_selected[0];
                            type = !type;
                          });
                        },
                        style: TextButton.styleFrom(
                            foregroundColor:
                                _selected[1] ? Colors.white : Colors.black,
                            backgroundColor:
                                _selected[1] ? Colors.red : Colors.white,
                            minimumSize: const Size(20, 50),
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10)))),
                        child: const Text("Email")),
                  ]),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Glad to see you!",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ),
              Text(
                type
                    ? "Please provide your phone number"
                    : "Please provide your Email address",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black45),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60.0, vertical: 30),
                child: Form(
                  key: formKey,
                  child: TextFormField(
                    controller: tec,
                    keyboardType: type
                        ? TextInputType.number
                        : TextInputType.emailAddress,
                    decoration:
                        InputDecoration(hintText: type ? "Phone" : "Email"),
                    validator: (name) {
                      if (name!.length < 10) {
                        return "Please add a valid phone number";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await sendData();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtpVerificationScreen(
                              userId: _userID!,
                              deviceId: _deviceID!,
                              contact: tec.text,
                            ),
                          ));
                      // Navigator.pushNamed(context, '/registration');
                    }
                  },
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red[300],
                      minimumSize: const Size(double.infinity, 50),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)))),
                  child: const Text("SEND CODE"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


// {
//     "status": 1,
//     "data": {
//         "message": "Successfully Added",
//         "deviceId": "66910962158b17dd939ec4ac"
//     }
// }

// {
//     "status": 1,
//     "data": {
//         "message": "OTP send successfully ",
//         "userId": "66910d253292360c6daa053d",
//         "deviceId": "66910962158b17dd939ec4ac"
//     }
// }