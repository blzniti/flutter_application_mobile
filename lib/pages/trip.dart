import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_application_mobile/config/config.dart';
import 'package:flutter_application_mobile/models/response/tripIdxGetRes.dart';
import 'package:http/http.dart' as http;

class TripPage extends StatefulWidget {
  // Attribute of TripPage
  int idx = 0;
  TripPage({super.key, required this.idx});
  // TripPage({super.key, idx}){
  //   this.idx = idx;
  // };

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  // Attribute of _TripPageState

  late TripsIdxGetResponse trip;
  late Future<void> loadData;

  @override
  void initState() {
    super.initState();
    log(widget.idx.toString());
    loadData = loadDataAsyc();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายละเอียดทริป'),
      ),
      body: FutureBuilder(
          future: loadData,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(trip.name,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Row(
                      children: [
                        Text(trip.country),
                      ],
                    ),
                    Image.network(trip.coverimage),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('ราคา ${trip.price.toString()} บาท'),
                          Text('โซน${trip.destinationZone}'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(trip.detail),
                    ),
                    Center(
                      child: FilledButton(
                          onPressed: () {}, child: const Text('จองเลย!!')),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  // Function for loading data from API
  Future<void> loadDataAsyc() async {
    var value = await Configuration.getConfig();
    var url = value['apiEndpoint'];

    http.get(Uri.parse('$url/trips'));

    var data = await http.get(Uri.parse('$url/trips/${widget.idx}'));
    trip = tripsIdxGetResponseFromJson(data.body);

    //  return Future.delayed(const Duration(seconds: 5));
  }
}
