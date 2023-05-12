import 'package:e_presention/data/providers/leave_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';

import '../../data/providers/auth_provider.dart';
import '../../utils/common_widget.dart';

class LeavePage extends StatefulWidget {
  static String routeName = '/leave';
  const LeavePage({super.key});

  @override
  State<LeavePage> createState() => _LeavePageState();
}

class _LeavePageState extends State<LeavePage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController reasonController = TextEditingController();
  bool box = false;
  DateTime date = DateTime.now();
  DateTime endDate = DateTime.now();
  bool isPaidLeave = false;
  String reason = '';

  @override
  void initState() {
    Provider.of<LeaveProvider>(context, listen: false).fetchLeave();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ketidakhadiran Anda'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Provider.of<LeaveProvider>(context, listen: false)
                .fetchLeave();
          },
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              Consumer<AuthProvider>(
                builder: (context, value, child) => BiodataWidget(
                  title: 'Nama',
                  subtitle: value.user!.nama!,
                  column: '',
                  isProfilePage: false,
                ),
              ),
              Consumer<AuthProvider>(
                builder: (context, value, child) => BiodataWidget(
                  title: 'HP',
                  subtitle: value.user!.telp!,
                  column: '',
                  isProfilePage: false,
                ),
              ),
              CheckboxListTile(
                title: Text(
                  'Ajukan Baru',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                value: box,
                onChanged: (value) {
                  box = !box;
                  setState(() {});
                },
              ),
              if (box)
                AnimatedOpacity(
                  opacity: box ? 1 : 0,
                  duration: const Duration(milliseconds: 5000),
                  child: Consumer<LeaveProvider>(
                    builder: (context, exit, child) => Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Expanded(
                                flex: 1, child: Text('Pilih Tanggal Mulai')),
                            Expanded(
                              flex: 1,
                              child: InkWell(
                                onTap: () async {
                                  DateTime newDate = (await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2023),
                                        lastDate: DateTime(DateTime.now().year,
                                            DateTime.now().month + 3),
                                      )) ??
                                      date;

                                  if (newDate != date) {
                                    date = newDate;
                                  }

                                  setState(() {});
                                },
                                child: Container(
                                  // width: 200,
                                  height: 40,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat.yMMMMd('id_ID').format(date),
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const IconButton(
                                        onPressed: null,
                                        icon: Icon(
                                          Icons.edit_calendar_rounded,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Expanded(
                                child: Text('Pilih Tanggal Selesai')),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  DateTime newDate = (await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2023),
                                        lastDate: DateTime(DateTime.now().year,
                                            DateTime.now().month + 3),
                                      )) ??
                                      endDate;

                                  if (newDate != endDate) {
                                    endDate = newDate;
                                  }
                                  setState(() {});
                                },
                                child: Container(
                                  width: 200,
                                  height: 40,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(),
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat.yMMMMd('id_ID')
                                            .format(endDate),
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const IconButton(
                                        onPressed: null,
                                        icon: Icon(
                                          Icons.edit_calendar_rounded,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CheckboxListTile(
                          title: Text(
                            'Potong Cuti',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          value: isPaidLeave,
                          onChanged: (value) {
                            isPaidLeave = !isPaidLeave;
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 20),
                        Form(
                          key: formKey,
                          child: TextFormField(
                            controller: reasonController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: 'Alasan',
                              alignLabelWithHint: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Tidak boleh kosong';
                              }
                              return null;
                            },
                            maxLines: 5,
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  await exit
                                      .uploadCreateLeave(
                                    date,
                                    endDate,
                                    isPaidLeave,
                                    reasonController.text,
                                  )
                                      .then(
                                    (value) {
                                      reasonController.clear();
                                      MotionToast.success(
                                        description: const Text(
                                            'Sukses mengajukan Cuti/informasi tidak hadir'),
                                      ).show(context);
                                      box = !box;
                                      setState(() {});
                                    },
                                  );
                                  await exit.fetchLeave();
                                }
                              },
                              child: const Text('Ajukan'),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              onPressed: () {
                                box = !box;
                                setState(() {});
                              },
                              child: const Text('Batal'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              else
                const Text(
                  '''Silahkan tekan kotak di atas untuk mengajukan '''
                  '''permintaan Cuti/informasi tidak hadir yang baru''',
                  style: TextStyle(color: Colors.black26),
                ),
              CustomWidget.divider,
              const Text(
                'Riwayat Cuti/informasi tidak hadir Anda',
                textAlign: TextAlign.center,
              ),
              Consumer<LeaveProvider>(
                builder: (context, leave, child) => SingleChildScrollView(
                  primary: false,
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('')),
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Tanggal Mulai')),
                      DataColumn(label: Text('Tanggal Selesai')),
                      DataColumn(label: Text('Alasan')),
                      DataColumn(label: Text('Potong Cuti')),
                      DataColumn(label: Text('Status')),
                    ],
                    rows: leave.leave.map(
                      (e) {
                        String status = e.status == 0
                            ? 'Belum Disetujui'
                            : e.status == 1
                                ? 'Disetujui'
                                : 'Ditolak';
                        return DataRow(cells: [
                          DataCell(Icon(
                            Icons.done_all_rounded,
                            color: e.status == 1 ? Colors.green : Colors.red,
                          )),
                          DataCell(Text('${e.id!}')),
                          DataCell(Text(e.date!)),
                          DataCell(Text(e.endDate ?? '-')),
                          DataCell(Text(e.alasan!)),
                          DataCell(Text(e.potongCuti!)),
                          DataCell(Text(status)),
                        ]);
                      },
                    ).toList(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
