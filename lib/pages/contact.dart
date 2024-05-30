import 'package:flutter/material.dart';
import 'package:tp_synthse_flutter/models/contact.dart';

class ContactsPage extends StatefulWidget {
  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];

  void _addContact(Contact contact) {
    setState(() {
      contacts.add(contact);
    });
  }

  void _editContact(int index, Contact contact) {
    setState(() {
      contacts[index] = contact;
    });
  }

  void _deleteContact(int index) {
    setState(() {
      contacts.removeAt(index);
    });
  }

  void _showContactDialog({int? index}) {
    String name = index == null ? '' : contacts[index!].name;
    String phoneNumber = index == null ? '' : contacts[index!].phoneNumber;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(index == null ? 'Ajouter un contact' : 'Modifier le contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  name = value;
                },
                controller: TextEditingController(text: name),
                decoration: InputDecoration(labelText: 'Nom'),
              ),
              TextField(
                onChanged: (value) {
                  phoneNumber = value;
                },
                controller: TextEditingController(text: phoneNumber),
                decoration: InputDecoration(labelText: 'Numéro de téléphone'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                if (name.isNotEmpty && phoneNumber.isNotEmpty) {
                  if (index == null) {
                    _addContact(Contact(name: name, phoneNumber: phoneNumber));
                  } else {
                    _editContact(index!, Contact(name: name, phoneNumber: phoneNumber));
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text('Enregistrer'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact App'),
      ),
      body: Stack(
        children: [
          ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ListTile(
                title: Text(contact.name),
                subtitle: Text(contact.phoneNumber),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () => _showContactDialog(index: index),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteContact(index),
                    ),
                  ],
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () => _showContactDialog(),
                child: Text('Ajouter un contact'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.blueAccent,
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
