import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:dealsdray_assignment/main_screnn.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart';
import 'package:geolocator/geolocator.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  List<dynamic>? _deviceID;
  List<dynamic>? _values;
  String? myID, _type, _brand, _version, _ipAddress;
  Position? pos;
  String? _body;

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    pos = await Geolocator.getCurrentPosition();
  }

  Future<void> _getDeviceID() async {
    final deviceInfoPlugin = DeviceInfoPlugin();

    final result = await deviceInfoPlugin.deviceInfo;

    List<NetworkInterface> res = await NetworkInterface.list(
        includeLoopback: true, type: InternetAddressType.IPv4);

    await _determinePosition();

    setState(() {
      _deviceID = result.data.keys.toList();
      _values = result.data.values.toList();
      if (Platform.isAndroid) {
        _type = "android";
        _brand = _values![18];
        myID = _values![17];
        _version = _values![7]['release'];
        _ipAddress = res[1].addresses[0].address;
      }
    });

    Response resp = await post(
        Uri.parse("http://devapiv4.dealsdray.com/api/v2/user/device/add"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, dynamic>{
          "deviceType": _type,
          "deviceId": myID,
          "deviceName": _brand,
          "deviceOSVersion": _version,
          "deviceIPAddress": _ipAddress,
          "lat": "${pos!.latitude}",
          "long": "${pos!.longitude}",
          "buyer_gcmid": "",
          "buyer_pemid": "",
          "app": {
            "version": "1.20.5",
            "installTimeStamp": DateTime.now().toString(),
            "uninstallTimeStamp": DateTime.now().toString(),
            "downloadTimeStamp": DateTime.now().toString()
          }
        }));

    Map resBody = jsonDecode(resp.body);
    _body = resBody['data']['deviceId'];

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => mainScreen(
            deviceid: _body,
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    _getDeviceID();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.red,
              size: 40,
            ),
          ),
          Center(
            child: Image.asset(
              "assets/OIP.jpg",
            ),
          ),
        ],
      ),
    );
  }
}
