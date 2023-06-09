import 'package:e_presention/data/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';

import '../data/providers/exit_permit_provider.dart';
import '../utils/common_widget.dart';

class ExitPermitPage extends StatefulWidget {
  static String routeName = '/exit_permit';

  const ExitPermitPage({super.key});

  @override
  State<ExitPermitPage> createState() => _ExitPermitPageState();
}

class _ExitPermitPageState extends State<ExitPermitPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController reasonController = TextEditingController();
  DateTime date = DateTime.now();
  TimeOfDay outTime = TimeOfDay.now();
  TimeOfDay backTime = TimeOfDay.now();
  bool box = false;

  @override
  void initState() {
    Provider.of<ExitPermitProvider>(context, listen: false).fetchPermit();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajukan Izin Keluar'),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: RefreshIndicator(
            onRefresh: () async {
              await Provider.of<ExitPermitProvider>(context, listen: false)
                  .fetchPermit();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
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
                  box
                      ? Consumer<ExitPermitProvider>(
                          builder: (context, exit, child) => Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      const Text('Pilih Jam Keluar'),
                                      InkWell(
                                        onTap: () async {
                                          outTime = (await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ))!;
                                          setState(() {});
                                        },
                                        child: Container(
                                          width: 75,
                                          height: 75,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${outTime.hour}:${outTime.minute}',
                                              style:
                                                  const TextStyle(fontSize: 25),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const Text('Pilih Jam Kembali'),
                                      InkWell(
                                        onTap: () async {
                                          backTime = (await showTimePicker(
                                            context: context,
                                            initialTime: TimeOfDay.now(),
                                          ))!;
                                          setState(() {});
                                        },
                                        child: Container(
                                          width: 75,
                                          height: 75,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${backTime.hour}:${backTime.minute}',
                                              style:
                                                  const TextStyle(fontSize: 25),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Form(
                                key: formKey,
                                child: TextFormField(
                                  controller: reasonController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Tidak boleh kosong';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    labelText: 'Alasan',
                                    alignLabelWithHint: true,
                                  ),
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
                                            .uploadCreatePermit(
                                          date,
                                          outTime,
                                          backTime,
                                          reasonController.text,
                                        )
                                            .then(
                                          (value) {
                                            MotionToast.success(
                                              description: const Text(
                                                  'Sukses mengajukan izin keluar'),
                                            ).show(context);
                                            box = !box;
                                            formKey.currentState!.reset();
                                            setState(() {});
                                          },
                                        );
                                        await exit.fetchPermit();
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
                        )
                      : const Text(
                          '''Silahkan tekan kotak di atas untuk mengajukan '''
                          '''permintaan izin keluar yang baru''',
                          style: TextStyle(color: Colors.black26),
                        ),
                  CustomWidget.divider,
                  const Text(
                    'Riwayat Izin Keluar Anda',
                    textAlign: TextAlign.center,
                  ),
                  Consumer<ExitPermitProvider>(
                    builder: (context, permit, child) => SingleChildScrollView(
                      primary: false,
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('')),
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Tanggal')),
                          DataColumn(label: Text('Alasan')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Jam Keluar')),
                          DataColumn(label: Text('Jam Kembali')),
                        ],
                        rows: permit.permit.map(
                          (e) {
                            String status = e.status == 0
                                ? 'Belum Disetujui'
                                : e.status == 1
                                    ? 'Disetujui'
                                    : 'Ditolak';
                            return DataRow(cells: [
                              DataCell(
                                Icon(
                                  Icons.done_all_rounded,
                                  color:
                                      e.status == 1 ? Colors.green : Colors.red,
                                ),
                              ),
                              DataCell(Text('${e.id!}')),
                              DataCell(Text(e.date!)),
                              DataCell(Text(e.alasan!)),
                              DataCell(Text(status)),
                              DataCell(Text(e.jamKeluar!)),
                              DataCell(Text(e.jamKembali!)),
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
        ),
      ),
    );
  }
}
