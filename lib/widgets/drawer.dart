
import 'package:expenses_tracker/widgets/about.dart';
import 'package:expenses_tracker/widgets/expences_screen.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Nishar Ahmad"),
            accountEmail: const Text("ahmadnishar1132@gmail.comm"),
            currentAccountPicture: CircleAvatar(
                child: ClipOval(
              child: Image.asset(
                'assets/user.jpg',
                width: 60,
                fit: BoxFit.cover,
              ),
            )),
            decoration: const BoxDecoration(color: Colors.greenAccent),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home Page"),
            onTap: () {
              // Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Expenses(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.person_2),
            title: const Text("About"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AboutApp(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
