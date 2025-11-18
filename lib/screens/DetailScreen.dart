import 'dart:io';

import 'package:contactappp/models/contact.dart';
import 'package:contactappp/myComponents/MySnackBar.dart';
import 'package:contactappp/screens/UpdateScreen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Detailscreen extends StatefulWidget {
  myContactModel Contact;
  Color color;

  Detailscreen({super.key, required this.Contact, required this.color});

  @override
  State<Detailscreen> createState() => _DetailscreenState();
}

class _DetailscreenState extends State<Detailscreen> {
  @override
  void initState() {
    super.initState();
    print("Contact first Name: ${widget.Contact.firstName}");
    print("Contact last Name: ${widget.Contact.lastName}");
    print("Contact Details: ${widget.Contact.phone}");
  }

  Future<void> _launchPhone(String phone) async {
    final Uri url = Uri(scheme: "tel", path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        Mysnackbar().getMySnackbar(
          message: 'Could not launch phone',
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _launchMessage(String phone) async {
    final Uri url = Uri(scheme: "sms", path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        Mysnackbar().getMySnackbar(
          message: 'Could not launch message',
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _launchWhatsApp(String phone) async {
    final Uri url = Uri(scheme: "https", host: "wa.me", path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        Mysnackbar().getMySnackbar(
          message: 'Could not launch WhatsApp',
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _launchTelegram(String phone) async {
    final Uri url = Uri(scheme: "https", host: "t.me", path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        Mysnackbar().getMySnackbar(
          message: 'Could not launch Telegram',
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Future<void>_launchIstagram() async {
  //   final Uri url = Uri(
  //     scheme: "https",
  //     host: "instagram.com",);
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url, mode: LaunchMode.externalApplication);
  //   }
  //   else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       Mysnackbar().getMySnackbar(
  //         message: 'Could not launch Instagram',
  //         backgroundColor: Colors.red,
  //       ),
  //     );
  //   }
  // }
  Future<void> _launchEmail(String email) async {
    final Uri url = Uri(scheme: "mailto", path: email);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        Mysnackbar().getMySnackbar(
          message: 'Could not launch Email',
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Contact Details"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Updatescreen(Contact: widget.Contact),
                ),
              ).then((_)=>setState(() {

              }));
            },
            icon: Icon(Icons.edit),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: widget.color,
                child: ClipOval(
                  child:
                      widget.Contact.photoUrl != null
                          ? Image.file(File(widget.Contact.photoUrl!))
                          : Text  ( "${widget.Contact.firstName?.isNotEmpty == true ? widget.Contact.firstName![0] : ''}"
                "${widget.Contact.lastName?.isNotEmpty == true ? widget.Contact.lastName![0] : ''}",
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(
              "${widget.Contact.firstName??""} ${widget.Contact.lastName??""}",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.Contact.phone, style: TextStyle(fontSize: 18)),

                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        _launchPhone(widget.Contact.phone);
                      },
                      icon: Icon(Icons.phone),
                    ),
                    SizedBox(width: 5),
                    IconButton(
                      onPressed: () {
                        _launchMessage(widget.Contact.phone);
                      },
                      icon: Icon(Icons.message),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                _launchWhatsApp(widget.Contact.phone);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "WhatsApp",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
            SizedBox(height: 15),
            InkWell(
              onTap: () {
                _launchTelegram(widget.Contact.phone);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Telegram",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
            SizedBox(height: 15),
            InkWell(
              onTap: () {
                _launchEmail(widget.Contact.email);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Email",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16),
                ],
              ),
            ),
            /* InkWell(
              onTap: () {
                _launchIstagram();
              },
              child: Text("Instagram"),
            )*/
          ],
        ),
      ),
    );
  }
}
