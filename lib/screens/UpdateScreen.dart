import 'dart:io';
import 'package:contactappp/services/DbServices.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../models/contact.dart';
import '../myComponents/MySnackBar.dart';
import '../myComponents/MyTextField.dart';

class Updatescreen extends StatefulWidget {
  myContactModel Contact;

  Updatescreen({super.key, required this.Contact});

  @override
  State<Updatescreen> createState() => _UpdatescreenState();
}

class _UpdatescreenState extends State<Updatescreen> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  ImagePicker imagePicker = ImagePicker();
  String? ImagePath;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ImagePath = widget.Contact.photoUrl;
    firstNameController.text = widget.Contact.firstName??"";
    lastNameController.text = widget.Contact.lastName??"";
    phoneNumberController.text = widget.Contact.phone;
    emailController.text = widget.Contact.email;
    print(ImagePath);
  }

  // _getContact() async{
  //   DbServices dbServices = DbServices();
  //   Contact =  await dbServices.getDataById(widget.id, "contact");
  //   print("Fetching contact with id: ${widget.id}");
  //   print("Contact fetched: ${Contact!.firstName} ${Contact!.lastName}");
  // }
  Future<String> _saveImageToLocalDirectory(XFile image) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String fileName =
        DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';
    final saveImage = await File(
      image.path,
    ).copy("${directory.path}/$fileName");

    return saveImage.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Edit Contact"),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: ()async {
              bool res=await _updateContact();

              if(res&&mounted){
                Navigator.pop(context,true);
              }
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
                  onTap: () async {
                    final XFile? image = await imagePicker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (image != null) {
                      ImagePath = await _saveImageToLocalDirectory(image);
                      setState(() {
                         });
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
                      child:
                          ImagePath != null
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
                  ),
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
  _deletePreviousImage()async{
    if(widget.Contact.photoUrl!=null){
      final Directory directory = await getApplicationDocumentsDirectory();
      print(directory.path);
      File file = File(widget.Contact.photoUrl!);
      print("Deleting previous image: ${file.path}");
      if(await file.exists()){
        await file.delete();
        print("Previous image deleted");
      }else{
        print("Previous image not found");
      }
    }
  }

  Future <bool>_updateContact() async{
    if (firstNameController.text.isEmpty ||
        lastNameController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        Mysnackbar().getMySnackbar(
          message: "Please fill all fields",
          backgroundColor: Colors.red,
        ),
      );

      return  false;
    } else {
      print("in Updated function");

      if(ImagePath != widget.Contact.photoUrl) {
        print("Deleting previous image");
        await _deletePreviousImage();
      }
      myContactModel NewContact=myContactModel(
        firstName: firstNameController.text.trim(),
        id: widget.Contact.id!,
        lastName: lastNameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneNumberController.text.trim(),
        photoUrl: ImagePath,
      );
      print("Previous passed id is :  ${widget.Contact.id!}");
      DbServices dbServices=DbServices();
      print(NewContact.toMap());
      int result=await dbServices.updateData(widget.Contact.id!,NewContact , "contact");
      if(result!=-1){
        ScaffoldMessenger.of(context).showSnackBar(
          Mysnackbar().getMySnackbar(
            message: "Contact updated successfully",
            backgroundColor: Colors.green,
          ),
        );
        return true;
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          Mysnackbar().getMySnackbar(
            message: "failed to update contact",
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    }

  }
}
