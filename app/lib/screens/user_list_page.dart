import 'package:app/providers/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserListPage extends StatefulWidget {
  @override
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    // Handle loading state
    if (userProvider.loading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Users'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Handle error state
    if (userProvider.errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Users'),
        ),
        body: Center(
          child: Text('Error: ${userProvider.errorMessage}'),
        ),
      );
    }

    // Filter the list of users based on the search query
    final filteredUsers = userProvider.users
        .where((user) =>
            user.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search by name',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white60),
          ),
          style: TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
        backgroundColor: Colors.blue,
      ),
      body: RefreshIndicator(
        onRefresh: () => userProvider.fetchUsers(),
        child: filteredUsers.isEmpty
            ? Center(child: Text('No users found'))
            : ListView.builder(
                itemCount: filteredUsers.length,
                itemBuilder: (context, index) {
                  final user = filteredUsers[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.avatarUrl),
                    ),
                    title: Text(user.name),
                    subtitle: Text(user.email),
                  );
                },
              ),
      ),
    );
  }
}
