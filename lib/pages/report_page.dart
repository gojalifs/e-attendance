import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ReportPage extends StatefulWidget {
  static const routeName = '/report';
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String dropValue = 'Januari';

  String period = DateFormat('MMMM', 'ID').format(DateTime.now());
  @override
  void initState() {
    print(period);
    dropValue = period;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Anda'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text('Nama'),
                Text('Rudi'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Pilih Periode'),
                DropdownButton(
                  style: style.textTheme.bodyMedium,
                  items: const [
                    DropdownMenuItem(
                      value: 'Januari',
                      child: Text('Januari'),
                    ),
                    DropdownMenuItem(
                      value: 'Februari',
                      child: Text('Februari'),
                    ),
                    DropdownMenuItem(
                      value: 'Maret',
                      child: Text('Maret'),
                    ),
                  ],
                  onChanged: (value) {
                    dropValue = value!;
                    setState(() {});
                  },
                  value: dropValue,
                ),
              ],
            ),
            const Divider(
              thickness: 2,
              color: Colors.black,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Tanggal')),
                  DataColumn(label: Text('Jam Masuk')),
                  DataColumn(label: Text('Jam Keluar')),
                ],
                rows: [
                  DataRow(
                    cells: [
                      DataCell(Text(DateFormat('dd MMMM yy', 'id_ID')
                          .format(DateTime.now()))),
                      const DataCell(Text('data')),
                      const DataCell(Text('data')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text(DateFormat('dd MMMM yy', 'id_ID')
                          .format(DateTime.now()))),
                      const DataCell(Text('data')),
                      const DataCell(Text('data')),
                    ],
                  ),
                  DataRow(
                    cells: [
                      DataCell(Text(DateFormat('dd MMMM yy', 'id_ID')
                          .format(DateTime.now()))),
                      const DataCell(Text('data')),
                      const DataCell(Text('data')),
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
}
