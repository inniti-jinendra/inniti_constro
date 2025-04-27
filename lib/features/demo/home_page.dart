import 'package:flutter/material.dart';
import 'package:inniti_constro/features/demo/network_manager/rest_client.dart';
import 'package:inniti_constro/features/demo/models/user_list_in_objects.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = true;
  UserListInObjects? userListInObjects;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final response = await RestClient.getUserList();
    if (response != null) {
      setState(() {
        userListInObjects = response;
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load users')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users List')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : userListInObjects == null || userListInObjects!.data == null
          ? const Center(child: Text('No users found'))
          : ListView.builder(
        itemCount: userListInObjects!.data!.length,
        itemBuilder: (context, index) {
          var user = userListInObjects!.data![index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.avatar ?? ''),
            ),
            title: Text('${user.firstName} ${user.lastName}'),
            subtitle: Text(user.email ?? ''),
          );
        },
      ),
    );
  }
}
