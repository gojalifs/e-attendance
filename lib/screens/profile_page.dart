import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  static const routeName = '/profile';
  const ProfilePage({super.key});

  static final List<String> _list = ['a', 'b', 'a', 'b', 'a', 'b'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun'),
      ),
      // backgroundColor: Colors.white70,
      body: ListView(
        shrinkWrap: true,
        children: [
          CircleAvatar(
            radius: 100, // ukuran CircleAvatar
            child: ClipOval(
              child: Image.asset(
                'assets/images/user.jpeg', // URL gambar
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              color: Colors.grey.shade300,
              border: const Border.symmetric(),
            ),
            child: ListView.separated(
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      _list[index],
                      style: const TextStyle(color: Colors.black54),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit_square),
                      onPressed: () {},
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(
                      thickness: 1,
                    ),
                  );
                },
                itemCount: _list.length),
          ),
        ],
      ),
    );
  }
}
