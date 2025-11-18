import 'dart:async';
import 'dart:io';

import 'package:contactappp/provider/contactProvider.dart';
import 'package:contactappp/screens/AddScreen.dart';
import 'package:contactappp/screens/DetailScreen.dart';
import 'package:contactappp/screens/Settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/contact.dart';
import '../myComponents/MySnackBar.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  List<myContactModel> myContacts = [];
  List<Color> colors = [];
  bool isSearchActive = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _getContacts();
      await _contactsPermission();
    });

    isSearchActive = false;
  }

  Future<void> _getContacts() async {
    Provider.of<ContactProvider>(context, listen: false).getContacts();
  }

  Future<void> _lauchPhone(String phNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phNumber);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        Mysnackbar().getMySnackbar(
          message: 'Could not launch phone',
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _contactsPermission() async {
    var status = await Permission.contacts.request();

    if (!mounted) return;

    if (status.isGranted) {
      List<myContactModel> deviceContacts = await _getContactsFromDevice();

      if (!mounted) return;

      Provider.of<ContactProvider>(
        context,
        listen: false,
      ).addMultipleData(deviceContacts, "contact");
    } else {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        Mysnackbar().getMySnackbar(
          message: "Permission Denied. Open settings to continue.",
          backgroundColor: Colors.red,
        ),
      );

      await openAppSettings();
    }
  }

  Future<List<myContactModel>> _getContactsFromDevice() async {
    var DeviceContacts = await FlutterContacts.getContacts(withProperties: true);

    if (!mounted) return [];

    Provider.of<ContactProvider>(
      context,
      listen: false,
    ).setDeviceContacts(DeviceContacts);

    List<myContactModel> contactList = [];

    for (Contact item in DeviceContacts) {
      String phone = item.phones.isNotEmpty ? item.phones.first.number : "";
      String email = item.emails.isNotEmpty ? item.emails.first.address : "";
      String firstName = item.name.first.isEmpty ? "" : item.name.first;
      String lastName = item.name.last.isEmpty ? "" : item.name.last;

      contactList.add(
        myContactModel(
          firstName: firstName,
          lastName: lastName,
          email: email,
          phone: phone,
        ),
      );
    }

    return contactList;
  }

  @override
  Widget build(BuildContext context) {
    colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("My personal Contact App"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                isSearchActive = !isSearchActive;
              });
            },
          ),
        ],
        leading:IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Settings(),));
        }, icon: Icon(Icons.settings)),
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Addscreen()),
          );
        },
      ),
/*      persistentFooterButtons: [
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            print(
              Provider.of<ContactProvider>(
                context,
                listen: false,
              ).getContacts(),
            );
          },
        ),
        IconButton(
          icon: Icon(CupertinoIcons.restart),
          onPressed: () async {
            bool result =
            await Provider.of<ContactProvider>(
              context,
              listen: false,
            ).deleteDb();

            if (!mounted) return;

            if (result) {
              ScaffoldMessenger.of(context).showSnackBar(
                Mysnackbar().getMySnackbar(
                  message: 'Database closed successfully',
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
        ),
        ElevatedButton(
          child: Text("Test Haptics"),
          onPressed: () async {
            await HapticFeedback.vibrate();
          },
        ),
      ],*/
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Column(
          children: [
            if (isSearchActive) ...[
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: "Search Contacts",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                autocorrect: true,
                key: ValueKey("search"),
                textInputAction: TextInputAction.search,
                onChanged: (value) {
                  Provider.of<ContactProvider>(
                    context,
                    listen: false,
                  ).searchListByName(value);
                },
              ),
              SizedBox(height: 10),
            ],
            Consumer<ContactProvider>(
              builder: (context, conProvider, child) {
                if (conProvider.contacts.isEmpty) {
                  return Center(child: Text("No contact is available"));
                }
                return Expanded(
                  child: ListView.builder(
                    itemCount: conProvider.contacts.length,
                    itemBuilder: (context, index) {
                      final contact = conProvider.contacts[index];
                      final color = colors[index % colors.length];

                      return Dismissible(
                        key: Key(contact.id.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),
                        dragStartBehavior: DragStartBehavior.start,
                        movementDuration: Duration(seconds: 1),

                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                              title: Text("Delete Contact"),
                              content: Text(
                                "Are you sure you want to delete ${contact.firstName}?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.of(context).pop(false),
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: Text("Delete"),
                                ),
                              ],
                            ),
                          );
                        },

                        onDismissed: (direction) async {
                          await conProvider.deleteContact(contact.id!, "contact");

                          if (!mounted) return;

                          final deviceContacts =
                              Provider.of<ContactProvider>(
                                context,
                                listen: false,
                              ).deviceContacts;

                          final matched = deviceContacts.where((element) {
                            final phone = element.phones.isNotEmpty
                                ? element.phones.first.number
                                : null;
                            return element.name.first == contact.firstName &&
                                element.name.last == contact.lastName &&
                                phone == contact.phone;
                          });

                          if (matched.isNotEmpty) {
                            await matched.first.delete();
                          }

                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Deleted ${contact.firstName}")),
                          );

                          HapticFeedback.vibrate();
                        },

                        child: ListTile(
                          title: Text("${contact.firstName} ${contact.lastName}"),
                          leading: CircleAvatar(
                            backgroundColor: color,
                            child: ClipOval(
                              child:
                              contact.photoUrl != null
                                  ? Image.file(
                                File(contact.photoUrl!),
                                fit: BoxFit.cover,
                              )
                                  : Text(
                                (contact.firstName!.isNotEmpty
                                    ? contact.firstName![0]
                                    .toUpperCase()
                                    : '') +
                                    (contact.lastName!.isNotEmpty
                                        ? contact.lastName![0]
                                        .toUpperCase()
                                        : ''),
                              ),
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              _lauchPhone(contact.phone);
                            },
                            icon: Icon(Icons.phone),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder:
                                    (context) => Detailscreen(
                                  Contact: contact,
                                  color: color,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
