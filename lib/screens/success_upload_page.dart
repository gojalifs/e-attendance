import 'package:flutter/material.dart';

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

class SuccessScanPage extends StatefulWidget {
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
  State<SuccessScanPage> createState() => _SuccessScanPageState();
}

class _SuccessScanPageState extends State<SuccessScanPage> {
  /// TODO edit
  // late UserModel user;

  // late Future future;
  // Future getUser() async {
  //   LocalDbHelper localDb = LocalDbHelper();
  //   user = await localDb.getUser();
  // }

  // @override
  // void initState() {
  //   future = getUser().then((value) => user = value);
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: FutureBuilder(
          /// TODO
          // future: future,
          future: Future.delayed(const Duration(seconds: 1)),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Padding(padding: EdgeInsets.only(bottom: 20)),
                        Container(
                          width: 50,
                          height: 50,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: Image.asset('assets/images/success.gif'),
                        ),
                        const _SuccessBody(text1: 'Nama', text2: 'Rudi'),
                        const Divider(
                          thickness: 2,
                          color: Colors.black38,
                          indent: 10,
                          endIndent: 10,
                        ),
                        _SuccessBody(
                            text1: 'Jam ${widget.check}', text2: widget.time),
                        const Divider(
                          thickness: 2,
                          color: Colors.black38,
                          indent: 10,
                          endIndent: 10,
                        ),
                        const _SuccessBody(text1: 'Status', text2: 'Sukses'),
                        const Divider(
                          thickness: 2,
                          color: Colors.black38,
                          indent: 10,
                          endIndent: 10,
                        ),
                        widget.image
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
