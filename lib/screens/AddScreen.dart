import 'dart:io';

import 'package:contactappp/myComponents/MyTextField.dart';
import 'package:contactappp/provider/contactProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../models/contact.dart';
import '../myComponents/MySnackBar.dart';

class Addscreen extends StatefulWidget {
  const Addscreen({super.key});

  @override
  State<Addscreen> createState() => _AddscreenState();
}

class _AddscreenState extends State<Addscreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  ImagePicker imagePicker = ImagePicker();
  String?ImagePath ;



  @override
  Widget build(BuildContext context) {
    Future<void> _SaveContact() async {
      String firstName = firstNameController.text.trim();
      String lastName = lastNameController.text.trim();
      String phoneNumber = phoneNumberController.text.trim();
      String email = emailController.text.trim();
      if (firstName.isEmpty ||
          lastName.isEmpty ||
          phoneNumber.isEmpty ||
          email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          Mysnackbar().getMySnackbar(message: "Please fill all the fields",
            backgroundColor: Colors.red,),
        );
        return;
      }
      myContactModel con = myContactModel(
        firstName: firstName,
        lastName: lastName,
        phone: phoneNumber,
        email: email,
        photoUrl: ImagePath,
      );
      bool result = await Provider.of<ContactProvider>(context, listen: false).addContact(con, "contact");
      if (result) {
        ScaffoldMessenger.of(context).showSnackBar(Mysnackbar().getMySnackbar(
            message: "Contact is added successfully",
            backgroundColor: Colors.green));

        Navigator.pop(context);

      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(Mysnackbar().getMySnackbar(
            message: "Failed to add contact",
            backgroundColor: Colors.red));
      }
      print(
        "Contact Saved: $firstName $lastName, Phone: $phoneNumber, Email: $email",
      );
    }
    Future<String> _saveImageToLocalDirectory(XFile image)async{
      final appDir=await getApplicationDocumentsDirectory();
      final fileName="${DateTime.now().millisecondsSinceEpoch}.jpg";
      final saveImage=await File(image.path).copy("${appDir.path}/$fileName");
      print("Image saved to: $saveImage");
      return saveImage.path;
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create New Contact",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _SaveContact();
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: InkWell(
                  onTap: ()async {
                     final  XFile? image=await imagePicker.pickImage(source: ImageSource.gallery);
                    if(image != null) {
                      ImagePath=await _saveImageToLocalDirectory(image);
                    print(ImagePath);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        Mysnackbar().getMySnackbar(
                          message: "No image selected",
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[700],
                    child: ClipOval(
                      child: ImagePath != null
                          ? Image.file(
                        File(ImagePath!),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                          : Icon(
                        Icons.camera_alt,
                        size: 50,
                        color: Colors.grey[300],
                      ),
                    ),
                  )

                ),
              ),
              SizedBox(height: 20),
              Mytextfield(
                prefixIcon: Icons.person,
                hintText: "First Name",
                controller: firstNameController,
              ),
              SizedBox(height: 10),
              Mytextfield(
                prefixIcon: Icons.person,
                hintText: "Last Name",
                controller: lastNameController,
              ),
              SizedBox(height: 10),
              Mytextfield(
                prefixIcon: Icons.phone,
                hintText: "Phone Number",
                controller: phoneNumberController,
                textInputType: TextInputType.phone,
              ),
              SizedBox(height: 10),
              Mytextfield(
                prefixIcon: Icons.email,
                hintText: "Email",
                controller: emailController,
                textInputType: TextInputType.emailAddress,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );

  }


}
