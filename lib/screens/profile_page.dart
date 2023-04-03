import 'package:e_presention/data/providers/auth_provider.dart';
import 'package:e_presention/screens/login/login_page.dart';
import 'package:e_presention/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            children: [
              Hero(
                tag: 'avatar',
                child: CircleAvatar(
                  radius: 100,
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/user.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Consumer<AuthProvider>(
                builder: (context, value, child) => Text(
                  value.user!.nama!,
                ),
              ),
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
                  itemCount: _list.length,
                ),
              ),
            ],
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Consumer<AuthProvider>(
                  builder: (context, value, child) => ElevatedButton(
                      onPressed: () async {
                        await value.logout();
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, LoginPage.routeName, (route) => false);
                        }
                      },
                      child: const Text('Logout')),
                ),
              )),
        ],
      ),
    );
  }
}
