import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_mobile/config/config.dart';
import 'package:flutter_application_mobile/models/response/customerIdxGetRes.dart';
import 'package:flutter_application_mobile/pages/showtrip.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  int idx = 0;
  ProfilePage({super.key, required this.idx});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late CustomerIdxGetResponse customer;
  late Future<void> loadData;

  TextEditingController fullnameCtl = TextEditingController();
  TextEditingController phoneCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController imgCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadData = loadDataAsyc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ข้อมูลส่วนตัว'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'delete') {
                showDialog(
                  context: context,
                  builder: (context) => SimpleDialog(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'ยืนยันการยกเลิกสมาชิก?',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('ปิด')),
                          FilledButton(
                              onPressed: delete, child: const Text('ยืนยัน'))
                        ],
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('ยกเลิกสมาชิก'),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: loadData,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              fullnameCtl.text = customer.fullname;
              phoneCtl.text = customer.phone;
              emailCtl.text = customer.email;
              imgCtl.text = customer.image;
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Text(customer.fullname),
                    SizedBox(width: 150, child: Image.network(customer.image)),
                    const Row(
                      children: [
                        Text('ชื่อ-นามสกุล'),
                      ],
                    ),
                    TextField(
                      controller: fullnameCtl,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Text('หมายเลขโทรศัพท์'),
                        ],
                      ),
                    ),
                    TextField(
                      controller: phoneCtl,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Text('อีเมล์'),
                        ],
                      ),
                    ),
                    TextField(
                      controller: emailCtl,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Text('รูปภาพ'),
                        ],
                      ),
                    ),
                    TextField(
                      controller: imgCtl,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: FilledButton(
                          onPressed: update, child: const Text('บันทึกข้อมูล')),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  // Function for loading data from API
  Future<void> loadDataAsyc() async {
    var value = await Configuration.getConfig();
    var url = value['apiEndpoint'];
    var data = await http.get(Uri.parse('$url/customers/${widget.idx}'));

    // http.get(Uri.parse('$url/trips'));
    customer = customerIdxGetResponseFromJson(data.body);
  }

  void update() async {
    var json = {
      "fullname": fullnameCtl.text,
      "phone": phoneCtl.text,
      "email": emailCtl.text,
      "image": imgCtl.text
    };
    var value = await Configuration.getConfig();
    var url = value['apiEndpoint'];

    try {
      var data = await http.put(Uri.parse('$url/customers/${widget.idx}'),
          headers: {"Content-Type": "application/json; charaset=utf-8"},
          body: jsonEncode(json));
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('สำเร็จ'),
          content: const Text('บันทึกข้อมูลเรียบร้อย'),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('ปิด'))
          ],
        ),
      );

      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => ShowTripPage(
      //         idx: widget.idx,
      //       ),
      //     ));
    } catch (eer) {}
  }

  void delete() async {
    var value = await Configuration.getConfig();
    var url = value['apiEndpoint'];
    try {
      var data = await http.delete(Uri.parse('$url/customers/${widget.idx}'));
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('สำเร็จ'),
          content: const Text('ลบข้อมูลเรียบร้อย'),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                child: const Text('ปิด'))
          ],
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ผิดพลาด'),
          content: Text('ลบข้อมูลไม่สำเร็จ'),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('ปิด'))
          ],
        ),
      );
    }

  }
}
