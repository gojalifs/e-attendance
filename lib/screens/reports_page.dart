import 'package:async/async.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:e_presention/data/models/today_presention.dart';
import 'package:e_presention/data/providers/presention_provider.dart';
import 'package:e_presention/utils/common_widget.dart';

import '../env/env.dart';

class ReportPage extends StatefulWidget {
  static const routeName = '/report';
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  CalendarFormat calFormat = CalendarFormat.week;
  late DateTime selectedDate;
  late DateTime focusedDate;
  DateTime now = DateTime.now();
  var format = DateFormat('y-M-d');

  @override
  void initState() {
    selectedDate = now;
    focusedDate = now;
    cancelableFuture = CancelableOperation.fromFuture(
      Provider.of<PresentProvider>(context, listen: false)
          .getTodayReportPresention(focusedDate),
      onCancel: () => debugPrint('cancelled'),
    );
    getPresention();
    super.initState();
  }

  late CancelableOperation cancelableFuture;

  Future getPresention() async {
    if (cancelableFuture.isCanceled) {
      return;
    }

    // cancelableFuture = CancelableOperation.fromFuture(
    await Provider.of<PresentProvider>(context, listen: false)
        .getTodayReportPresention(focusedDate);
    // ,
    // onCancel: () => print('cancelled'),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Harian Anda'),
      ),
      body: ListView(
        children: [
          Consumer<PresentProvider>(
            builder: (context, value, child) {
              return TableCalendar(
                locale: 'id-ID',
                calendarFormat: calFormat,
                onFormatChanged: (format) {
                  setState(() {
                    calFormat = format;
                  });
                },
                focusedDay: focusedDate,
                firstDay: DateTime(2023, 1, 1),
                lastDay: DateTime(DateTime.now().year, DateTime.now().month,
                    DateTime.now().day + 7),
                selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                onDaySelected: (selectedDay, focusedDay) async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return Dialog(
                        backgroundColor: Colors.black.withOpacity(0),
                        insetPadding:
                            const EdgeInsets.symmetric(horizontal: 200),
                        child: const CircularProgressIndicator.adaptive(),
                      );
                    },
                  );
                  selectedDate = selectedDay;
                  focusedDate = focusedDay;
                  getPresention().then((value) => Navigator.of(context).pop());
                  setState(() {});
                },
              );
            },
          ),
          const SizedBox(height: 10),
          CustomWidget.divider,
          Padding(
            padding: const EdgeInsets.all(10),
            child: Card(
              child: Consumer<PresentProvider>(
                builder: (context, value, child) {
                  List<TodayPresention> daily = value.todayReports;
                  if (value.state == ConnectionState.done) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('ID Presensi'),
                              daily.isNotEmpty
                                  ? Text(
                                      daily[0].presentionId!.isEmpty
                                          ? 'Belum absen'
                                          : daily[0].presentionId!,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    )
                                  : const Text(
                                      'Tidak Ada Data',
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Waktu Presensi'),
                              daily.isNotEmpty
                                  ? Text(
                                      daily[0].time!.isNotEmpty
                                          ? daily[0].time!
                                          : 'belum absen',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    )
                                  : const Text(
                                      'Tidak Ada Data',
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(child: Text('Foto Anda')),
                              daily.isNotEmpty
                                  ? daily[0].imgPath!.isNotEmpty
                                      ? Image.network(
                                          '${Env.imageUrl}/${daily[0].imgPath}',
                                          width: 100,
                                          height: 100,
                                        )
                                      : const Text(
                                          'Tidak ada data',
                                          style: TextStyle(
                                            color: Colors.black54,
                                          ),
                                        )
                                  : const Text(
                                      'Tidak Ada Data',
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: CustomWidget.divider,
                          ),

                          /// out section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('ID Presensi'),
                              daily.isNotEmpty
                                  ? Text(
                                      daily[1].presentionId!.isEmpty
                                          ? 'Belum absen'
                                          : daily[1].presentionId!,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    )
                                  : const Text(
                                      'Tidak Ada Data',
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Waktu Presensi'),
                              daily.isNotEmpty
                                  ? Text(
                                      daily[1].time!.isNotEmpty
                                          ? daily[1].time!
                                          : 'Anda belum absen',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    )
                                  : const Text(
                                      'Tidak Ada Data',
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(child: Text('Foto Anda')),
                              daily.isNotEmpty
                                  ? daily[1].imgPath!.isNotEmpty
                                      ? Image.network(
                                          '${Env.imageUrl}/${daily[1].imgPath}',
                                          width: 100,
                                          height: 100,
                                        )
                                      : const Text(
                                          'Tidak ada data',
                                          style: TextStyle(
                                            color: Colors.black54,
                                          ),
                                        )
                                  : const Text(
                                      'Tidak Ada Data',
                                      style: TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: CustomWidget.divider,
                          ),
                        ],
                      ),
                    );
                  }
                  return Column(
                    children: [
                      const CustomShimmer(),
                      const CustomShimmer(),
                      const CustomShimmer(),
                      CustomWidget.divider,
                      const CustomShimmer(),
                      const CustomShimmer(),
                      const CustomShimmer(),
                    ],
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CustomShimmer extends StatelessWidget {
  const CustomShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: FadeShimmer(
              height: 20,
              width: double.infinity,
              radius: 25,
              millisecondsDelay: 10,
              highlightColor: Color.fromARGB(255, 187, 187, 187),
              baseColor: Color(0xffE6E8EB),
            ),
          ),
          Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 1,
            child: FadeShimmer(
              height: 20,
              width: 150,
              radius: 20,
              millisecondsDelay: 20,
              highlightColor: Color.fromARGB(255, 187, 187, 187),
              baseColor: Color(0xffE6E8EB),
            ),
          ),
        ],
      ),
    );
  }
}
