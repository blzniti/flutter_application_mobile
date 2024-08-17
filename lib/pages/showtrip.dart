import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_mobile/config/config.dart';
import 'package:flutter_application_mobile/models/response/tripsGetRes.dart';
import 'package:flutter_application_mobile/pages/login.dart';
import 'package:flutter_application_mobile/pages/profile.dart';
import 'package:flutter_application_mobile/pages/trip.dart';
import 'package:http/http.dart' as http;

class ShowTripPage extends StatefulWidget {
  int idx = 0;
  ShowTripPage({super.key, required this.idx});

  @override
  State<ShowTripPage> createState() => _ShowTripPageState();
}

class _ShowTripPageState extends State<ShowTripPage> {
  List<TripsGetResponse> trips = [];

  // 3. Use loadDataAsync()
  late Future<void> loadData;

  String url = '';
  @override
  void initState() {
    super.initState();
    // 4. Assign loadData
    loadData = loadDataAsyc();

    // Configuration.getConfig().then(
    //   (config) {
    //     url = config['apiEndpoint'];
    //     // getTrips();
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการทริป'),
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              log(value);
              if (value == 'profile') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(idx: widget.idx),
                    ));
              } else if (value == 'logout') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginPage(),
                    ));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('ปลายทาง'),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                FilledButton(
                    onPressed: () => getTrips(null),
                    child: const Text('ทั้งหมด')),
                const SizedBox(
                  width: 10,
                ),
                FilledButton(
                    onPressed: () => getTrips('เอเชีย'),
                    child: const Text('เอเชีย')),
                const SizedBox(
                  width: 10,
                ),
                FilledButton(
                    onPressed: () => getTrips('ยุโรป'),
                    child: const Text('ยุโรป')),
                const SizedBox(
                  width: 10,
                ),
                FilledButton(
                    onPressed: () => getTrips('เอเชียตะวันออกเฉียงใต้'),
                    child: const Text('อาเซียน')),
                const SizedBox(
                  width: 10,
                ),
                FilledButton(
                    onPressed: () => getTrips('ประเทศไทย'),
                    child: const Text('ประเทศไทย')),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: FutureBuilder(
                  future: loadData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Column(
                      // crossAxisAlignment: CrossAxisAlignment.s,
                      children: trips
                          .map(
                            (trip) => Card(
                              color: const Color.fromARGB(255, 240, 225, 243),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(
                                        trip.name,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 180,
                                          height: 140,
                                          child: Image.network(
                                            trip.coverimage,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text('ประเทศ${trip.country}',
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                                Text(
                                                    'ระยะเวลา ${trip.duration} วัน'),
                                                Text('${trip.price}'),
                                                FilledButton(
                                                    onPressed: () =>
                                                        goToTripPage(trip.idx),
                                                    child: const Text(
                                                        'รายละเอียดเพิ่มเติม')),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  // Function for loading data from API
  Future<void> loadDataAsyc() async {
    var value = await Configuration.getConfig();
    url = value['apiEndpoint'];

    http.get(Uri.parse('$url/trips'));

    var data = await http.get(Uri.parse('$url/trips'));
    trips = tripsGetResponseFromJson(data.body);

    //  return Future.delayed(const Duration(seconds: 5));
  }

  // Zone can be null
  void getTrips(String? zone) {
    http.get(Uri.parse('$url/trips')).then((value) {
      log(value.body);
      trips = tripsGetResponseFromJson(value.body);
      List<TripsGetResponse> filteredTrips = [];
      if (zone != null) {
        for (var trip in trips) {
          if (trip.destinationZone == zone) {
            filteredTrips.add(trip);
          }
        }
        trips = filteredTrips;
      }
      setState(() {});
      log(trips.length.toString());
    }).catchError((err) {
      log(err.toString());
    });
  }

  goToTripPage(int idx) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TripPage(idx: idx),
        ));
  }
}
