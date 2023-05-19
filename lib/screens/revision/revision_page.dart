import 'package:e_presention/data/providers/revise_provider.dart';
import 'package:e_presention/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:provider/provider.dart';

import 'package:e_presention/utils/common_widget.dart';

import '../../data/providers/auth_provider.dart';

enum _RevisionGroup { masuk, keluar }

class RevisionPage extends StatefulWidget {
  static String routeName = '/revision';
  const RevisionPage({super.key});

  @override
  State<RevisionPage> createState() => _RevisionPageState();
}

class _RevisionPageState extends State<RevisionPage> {
  ApiService apiService = ApiService();
  final formKey = GlobalKey<FormState>();
  TextEditingController reasonController = TextEditingController();

  bool box = false;

  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  @override
  void initState() {
    Provider.of<ReviseProvider>(context, listen: false)
      ..fetchRevision()
      ..removeImage();
    super.initState();
  }

  _RevisionGroup revision = _RevisionGroup.masuk;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajukan Revisi Absen'),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: RefreshIndicator(
            onRefresh: () async {
              await Provider.of<ReviseProvider>(context, listen: false)
                  .fetchRevision();
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
                CheckboxListTile.adaptive(
                  value: box,
                  onChanged: (bool? value) {
                    setState(() {
                      box = value!;
                    });
                  },
                  title: Text(
                    'Ajukan Baru',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                const SizedBox(height: 20),
                box
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text('Pilih Tanggal Untuk Revisi'),
                              ),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () async {
                                    DateTime newDate = (await showDatePicker(
                                          context: context,
                                          initialDate: date,
                                          firstDate: DateTime(2023),
                                          lastDate: DateTime.now(),
                                        )) ??
                                        date;

                                    if (newDate != date) {
                                      date = newDate;
                                    }

                                    setState(() {});
                                  },
                                  child: Container(
                                    height: 40,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
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
                                          DateFormat.yMMMMd('id_ID')
                                              .format(date),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Expanded(
                                  child: Text('Revisi masuk atau keluar?')),
                              const SizedBox(width: 20),
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: RadioListTile(
                                        value: _RevisionGroup.masuk,
                                        contentPadding: EdgeInsets.zero,
                                        title: const Text(
                                          'Masuk',
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        groupValue: revision,
                                        onChanged: (value) {
                                          revision = value!;
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: RadioListTile(
                                        value: _RevisionGroup.keluar,
                                        contentPadding: EdgeInsets.zero,
                                        title: const Text(
                                          'Pulang',
                                          style: TextStyle(fontSize: 17),
                                        ),
                                        groupValue: revision,
                                        onChanged: (value) {
                                          revision = value!;
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Expanded(
                                flex: 1,
                                child: Text('Jam masuk/pulang'),
                              ),
                              Expanded(
                                flex: 1,
                                child: InkWell(
                                  onTap: () async {
                                    TimeOfDay reviseTime =
                                        (await showTimePicker(
                                                context: context,
                                                initialTime: time)) ??
                                            time;

                                    if (time != reviseTime) {
                                      time = reviseTime;
                                    }

                                    setState(() {});
                                  },
                                  child: Container(
                                    height: 40,
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        time.format(context),
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const Expanded(
                                  child: Text('Upload Bukti (JPG/PNG)')),
                              Expanded(
                                child: Consumer<ReviseProvider>(
                                  builder: (context, value, child) => Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              value.getPictCamera();
                                            },
                                            icon: const Icon(
                                                Icons.photo_camera_rounded),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              value.getPictGallery();
                                            },
                                            icon: const Icon(Icons.filter),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Consumer<ReviseProvider>(
                            builder: (context, value, child) => value.images ==
                                    null
                                ? const SizedBox()
                                : Row(
                                    children: [
                                      const Expanded(child: SizedBox()),
                                      Expanded(
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2,
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            border: Border.all(
                                                color: Colors.black26),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            value.images?.path
                                                    .split('/')
                                                    .last
                                                    .split('_compressed')
                                                    .first ??
                                                '',
                                            style: const TextStyle(
                                              color: Colors.black26,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
                          const SizedBox(height: 20),
                          Consumer<ReviseProvider>(
                            builder: (context, value, child) => ElevatedButton(
                              onPressed: value.state == ConnectionState.active
                                  ? null
                                  : () async {
                                      await apiService.getUser();
                                      if (!mounted) {
                                        return;
                                      }
                                      if (value.images == null) {
                                        MotionToast.warning(
                                          description: const Text(
                                              'Mohon untuk upload bukti'),
                                        ).show(context);
                                        return;
                                      }
                                      if (formKey.currentState!.validate()) {
                                        String reviseType =
                                            revision.toString().split('.').last;
                                        await value
                                            .addRevise(date, time, reviseType,
                                                reasonController.text, context)
                                            .then(
                                              (value) => MotionToast.info(
                                                description: const Text(
                                                    'Sukses mengajukan revisi'),
                                              ).show(context),
                                            )
                                            .onError((error, stackTrace) =>
                                                MotionToast.error(
                                                  description: Text(
                                                      'Terjadi error $error'),
                                                ).show(context));
                                      }
                                      await value.fetchRevision();
                                    },
                              child: value.state == ConnectionState.active
                                  ? const SizedBox(
                                      width: 50,
                                      child: LinearProgressIndicator(
                                        color: Colors.blue,
                                      ),
                                    )
                                  : const Text('Submit'),
                            ),
                          ),
                        ],
                      )
                    : const Text(
                        '''Silahkan ajukan revisi absen di sini apabila anda lupa '''
                        '''tidak melakukan absensi atau ada kesalahan. '''
                        '''Admin akan segera mengkonfimasi''',
                        style: TextStyle(color: Colors.black26),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: CustomWidget.divider,
                ),
                const Text(
                  'Riwayat Revisi Absensi Anda',
                  textAlign: TextAlign.center,
                ),
                Consumer<ReviseProvider>(
                  builder: (context, value, child) {
                    return SingleChildScrollView(
                      primary: false,
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('')),
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('Tanggal')),
                          DataColumn(label: Text('Jam')),
                          DataColumn(label: Text('Yang Direvisi')),
                          DataColumn(label: Text('Alasan')),
                          DataColumn(label: Text('Status')),
                        ],
                        rows: value.revisi.map(
                          (e) {
                            String status = e.isApproved == 0
                                ? 'Belum Disetujui'
                                : e.isApproved == 1
                                    ? 'Disetujui'
                                    : 'Ditolak';
                            return DataRow(cells: [
                              DataCell(Icon(
                                Icons.done_all_rounded,
                                color: e.isApproved == 1
                                    ? Colors.green
                                    : Colors.red,
                              )),
                              DataCell(Text('${e.id!}')),
                              DataCell(Text(e.date!)),
                              DataCell(Text(e.time ?? '-')),
                              DataCell(Text(e.revised!)),
                              DataCell(Text(e.reason!)),
                              DataCell(Text(status)),
                            ]);
                          },
                        ).toList(),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
