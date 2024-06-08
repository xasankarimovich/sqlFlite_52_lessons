import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lessons_52/services/db_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contact Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ContactListPage(),
    );
  }
}

class ContactListPage extends StatefulWidget {
  @override
  _ContactListPageState createState() => _ContactListPageState();
}

class _ContactListPageState extends State<ContactListPage> {
  List<Map<String, dynamic>> _contacts = [];

  @override
  void initState() {
    super.initState();
    _refreshContactList();
  }

  void _refreshContactList() async {
    final data = await DatabaseHelper.instance.queryAllContacts();
    setState(() {
      _contacts = data;
    });
  }

  void _addContact(String name, String phone) async {
    await DatabaseHelper.instance.insertContact({'name': name, 'phone': phone});
    _refreshContactList();
  }

  void _updateContact(int id, String name, String phone) async {
    await DatabaseHelper.instance
        .updateContact({'id': id, 'name': name, 'phone': phone});
    _refreshContactList();
  }

  void _deleteContact(int id) async {
    await DatabaseHelper.instance.deleteContact(id);
    _refreshContactList();
  }

  void _showForm({Map<String, dynamic>? contact}) {
    final _nameController =
    TextEditingController(text: contact != null ? contact['name'] : '');
    final _phoneController =
    TextEditingController(text: contact != null ? contact['phone'] : '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(contact == null ? 'Add Contact' : 'Edit Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (contact == null) {
                _addContact(_nameController.text, _phoneController.text);
              } else {
                _updateContact(
                    contact['id'], _nameController.text, _phoneController.text);
              }
              Navigator.of(context).pop();
            },
            child: Text('Save'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Manager'),
      ),
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];

          return ListTile(
            leading: CircleAvatar(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Image.network(
                  "https://randomuser.me/api/portraits/men/${Random().nextInt(100)}.jpg",
                ),
              ),
            ),
            title: Text(contact['name']),
            subtitle: Text(contact['phone']),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showForm(contact: contact),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteContact(contact['id']),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: Icon(Icons.add),
      ),
    );
  }
}
