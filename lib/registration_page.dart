import 'dart:async';
import 'dart:convert';

import 'package:dealsdray_assignment/product_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

final formKey = GlobalKey<FormState>();

class RegistrationPage extends StatefulWidget {
  final userId;
  const RegistrationPage({super.key, required this.userId});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController tecEmail = TextEditingController();
  TextEditingController tecPassword = TextEditingController();
  TextEditingController tecReferral = TextEditingController();

  Future<void> sendData() async {
    Response res = await post(
        Uri.parse("http://devapiv4.dealsdray.com/api/v2/user/email/referral"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "email": tecEmail.text,
          "password": tecPassword.text,
          "referralCode": null,
          "userId": widget.userId
        }));
    Map data = jsonDecode(res.body);
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductScreen(),
        ));
  }

  bool type = true;
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20.0),
        child: FloatingActionButton(
          backgroundColor: Colors.red[500],
          onPressed: () {
            if (formKey.currentState!.validate()) {
              sendData();
            }
          },
          child: const Icon(
            Icons.arrow_right_alt,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
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
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text(
                  "Lets begin!",
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ),
              const Text(
                "Please enter your credentials to proceed",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black45),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60.0, vertical: 30),
                child: Column(
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: tecEmail,
                            keyboardType: TextInputType.emailAddress,
                            decoration:
                                const InputDecoration(hintText: "Your Email"),
                            validator: (name) {
                              if (name!.length < 5) {
                                return "please add a valid email id";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: tecPassword,
                            obscureText: passwordVisible,
                            keyboardType: TextInputType.visiblePassword,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(
                              hintText: "Create password",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(
                                    () {
                                      passwordVisible = !passwordVisible;
                                    },
                                  );
                                },
                                icon: Icon(passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                              ),
                            ),
                            validator: (name) {
                              if (name!.length < 5) {
                                return "please add a valid email id";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: tecReferral,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                hintText: "Referral code(optional)"),
                            validator: (name) {},
                          ),
                        ],
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
