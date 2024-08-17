import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_mobile/config/config.dart';
import 'package:flutter_application_mobile/models/requset/customersLoginPostReq.dart';
import 'package:flutter_application_mobile/models/response/customersLoginPostRes.dart';
import 'package:flutter_application_mobile/pages/register.dart';
import 'package:flutter_application_mobile/pages/showtrip.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = '';
  int count = 0;
  bool icon = true;
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController passCtl = TextEditingController();

  // InitState Function ที่ทำงานเมื่อเปิดหน้านี้
  // 1.InitState จะทำงาน "ครั้งเดียว"  เมื่อเปิดหน้านี้
  // 2.มันจะไม่ทำงานเมื่อเราเรียก setState
  // 3. มันไม่สามารถทำงานเป็น async function ได้
  String url = '';

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then(
      (value) {
        log(value['apiEndpoint']);
        url = value['apiEndpoint'];
      },
    ).catchError((eer) {
      log(eer.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          GestureDetector(
              onDoubleTap: () {
                log('DoubleTap');
              },
              child: Image.asset('assets/images/logo.png')),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
                child: Column(
                  children: [
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "หมายเลขโทรศัพท์",
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                    TextField(
                      controller: phoneCtl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1))),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "รหัสผ่าน",
                            style: TextStyle(fontSize: 22),
                          ),
                        ],
                      ),
                    ),
                    // TextField(
                    //   controller: passCtl,
                    //   obscureText: icon,
                    //   // obscuringCharacter: '?',
                    //   decoration: InputDecoration(
                    //     suffixIcon: IconButton(onPressed: () => icon ? Icons.visibility_off : Icons.visibility)
                    //       ,border: const OutlineInputBorder(
                    //           borderSide: BorderSide(width: 1))),
                    // ),
                    TextField(
                      controller: passCtl,
                      obscureText: icon,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(icon
                              ? Icons.visibility_off
                              : Icons
                                  .visibility), // Corrected the Icon property
                          onPressed: () {
                            setState(() {
                              icon = !icon; // Corrected onPressed function
                            });
                          },
                        ),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(width: 1),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                              onPressed: register,
                              child: const Text('ลงทะเบียนใหม่',
                                  style: TextStyle(fontSize: 20))),
                          FilledButton(
                              onPressed: login,
                              child: const Text('เข้าสู่ระบบ',
                                  style: TextStyle(fontSize: 20))),
                        ],
                      ),
                    ),
                    Text(text)
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }

  void login() async {
    // Call login api
    // Create object (request Model)
    var req =
        CustomersLoginPostReq(phone: phoneCtl.text, password: passCtl.text);
    try {
      var value = await http.post(Uri.parse('$url/customers/login'),
          headers: {"Content-Type": "application/json; charaset=utf-8"},
          // Send json string of object model
          body: customersLoginPostReqToJson(req));
      // Convert Json String to Object (Model)
      CustomersLoginPostResponse customer =
          customersLoginPostResponseFromJson(value.body);
      log(customer.customer.fullname);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ShowTripPage(idx: customer.customer.idx),
        ),
      );
    } catch (e) {
      setState(() {
        text = 'Phone no or Password Incorrect';
      });
    }
  }

  void register() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegisterPage(),
        ));
  }
}
