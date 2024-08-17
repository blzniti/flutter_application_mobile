import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_mobile/config/config.dart';
import 'package:flutter_application_mobile/models/requset/customersPostReq.dart';
import 'package:flutter_application_mobile/models/response/customersGetRes.dart';
import 'package:flutter_application_mobile/pages/login.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController passCtl = TextEditingController();
  TextEditingController passconCtl = TextEditingController();

  String url = '';

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then(
      (value) {
        log(value['apiEndpoint']);
        url = value['apiEndpoint'];
      },
    ).catchError((eer){
      log(eer.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ลงทะเบียนสมาชิกใหม่'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ชื่อ - นามสกุล'),
                  TextField(
                      controller: nameCtl,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1)))),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text('หมายเลขโทรศัพท์'),
                  ),
                  TextField(
                      controller: phoneCtl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1)))),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text('อีเมล์'),
                  ),
                  TextField(
                      controller: emailCtl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1)))),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text('รหัสผ่าน'),
                  ),
                  TextField(
                      controller: passCtl,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1)))),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text('ยืนยันรหัสผ่าน'),
                  ),
                  TextField(
                      controller: passconCtl,
                      obscureText: true,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: BorderSide(width: 1)))),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        FilledButton(
                            style: FilledButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 60)),
                            onPressed: register,
                            child: const Text('สมัครสมาชิก')),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: login,
                          child: const Text(
                            'หากมีบัญชีอยู่แล้ว?',
                            style: TextStyle(color: Colors.black),
                          )),
                      TextButton(
                          onPressed: login, child: const Text('เข้าสู่ระบบ')),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void register() async {
    ScaffoldMessenger.of(context).clearSnackBars();
    if (nameCtl.text.isEmpty ||
        phoneCtl.text.isEmpty ||
        emailCtl.text.isEmpty ||
        passCtl.text.isEmpty ||
        passconCtl.text.isEmpty) {
      // แจ้งเตือนผู้ใช้ว่าข้อมูลไม่ครบ
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (passCtl.text != passconCtl.text) {
      // แจ้งเตือนผู้ใช้ว่ารหัสผ่านไม่ตรงกัน
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    // Get data Customer from API
    var data = await http.get(Uri.parse('$url/customers'),
        headers: {"Content-Type": "application/json; charset=utf-8"});
    List<CustomersGetResponse> listcustomer =
        customersGetResponseFromJson(data.body);

    bool isDuplicate = false;
    String email = emailCtl.text;
    String phone = phoneCtl.text;
    for (var customer in listcustomer) {
      if (customer.email == email || customer.phone == phone) {
        isDuplicate = true;
        break;
      }
    }

    // กรณีที่ email or phone ซ้ำ ให้แจ้งเตือน user
    if (isDuplicate) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('This email or phone number is already registered.')),
      );
      return;
    }

    // Create object (request Model)
    var req = CustomersPostRequest(
      fullname: nameCtl.text,
      phone: phoneCtl.text,
      email: emailCtl.text,
      image: "",
      password: passCtl.text,
    );

    // Call login register
    http
        .post(Uri.parse('$url/customers'),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            // Send json string of object model
            body: customersPostRequestToJson(req))
        .then(
      (value) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
        );
      },
    ).catchError((eee) {
      setState(() {
        // ignore: unused_local_variable
        var text = 'Phone number or Password is incorrect';
      });
    });
  }

  void login() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ));
  }
}
