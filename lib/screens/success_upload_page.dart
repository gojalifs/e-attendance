import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import 'package:e_presention/data/providers/auth_provider.dart';
import 'package:e_presention/data/providers/photo_provider.dart';
import 'package:e_presention/utils/common_widget.dart';

import '../env/env.dart';

class SuccessPage extends StatelessWidget {
  static const routeName = '/success_page';
  const SuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sukses'),
      ),
      body: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).popUntil((route) => route.isFirst);
          return false;
        },
        child: SuccessScanPage(),
      ),
    );
  }
}

class SuccessScanPage extends StatelessWidget {
  String baseUrl = Env.url.replaceAll(RegExp(r'api'), '');

  SuccessScanPage({
    Key? key,
    this.check = 'Masuk',
    this.time = 'Jam Skrg',
    // this.image,
  }) : super(key: key);

  final String check;
  final String time;
  final Image image = Image.network(
      'https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHw%3D&w=1000&q=80');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: FutureBuilder(
          future: Future.delayed(const Duration(seconds: 1)),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
                  child: Consumer2<PhotoProvider, AuthProvider>(
                    builder: (context, scan, auth, child) => Column(
                      // mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(padding: EdgeInsets.only(bottom: 20)),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: auth.user?.avaPath != '-'
                              ? CircleAvatar(
                                  radius: 100,
                                  backgroundImage: NetworkImage(
                                    '${Env.imageUrl}/${auth.user!.avaPath!}',
                                  ),
                                )
                              : const Icon(
                                  Icons.account_circle_rounded,
                                  size: 100,
                                ),
                        ),
                        _SuccessBody(text1: 'Nama', text2: auth.user!.nama!),
                        CustomWidget.divider,
                        _SuccessBody(
                          text1: 'Jam $check',
                          text2: scan.presentionDetail.time!,
                        ),
                        CustomWidget.divider,
                        const _SuccessBody(text1: 'Status', text2: 'Sukses'),
                        CustomWidget.divider,
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Consumer<PhotoProvider>(
                            builder: (context, value, child) =>
                                Image.file(File(scan.images!.path)),
                          ),
                        ),
                        CustomWidget.divider,
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Consumer<PhotoProvider>(
                            builder: (context, value, child) => MapWidget(
                              long: double.parse(value.long),
                              lat: double.parse(value.lat),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return const Center(child: CircularProgressIndicator.adaptive());
          },
        ),
      ),
    );
  }
}

class _SuccessBody extends StatelessWidget {
  const _SuccessBody({
    Key? key,
    required this.text1,
    required this.text2,
  }) : super(key: key);

  final String text1;
  final String text2;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              text1,
              style: const TextStyle(
                fontSize: 25,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              text2,
              style: const TextStyle(
                fontSize: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MapWidget extends StatelessWidget {
  final double long;
  final double lat;

  const MapWidget({
    Key? key,
    required this.long,
    required this.lat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: FlutterMap(
        options: MapOptions(
          center: LatLng(lat, long),
          zoom: 15,
        ),
        nonRotatedChildren: const [
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                // onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              ),
            ],
          ),
        ],
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.e_presention',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(lat, long),
                builder: (context) {
                  return const Icon(
                    Icons.location_on,
                    color: Colors.red,
                  );
                },
              )
            ],
          ),
        ],
      ),
    );
  }
}
