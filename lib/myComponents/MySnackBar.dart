import 'package:flutter/material.dart';
class Mysnackbar {

  Mysnackbar();

  getMySnackbar({ required String message,required Color backgroundColor}){
    return SnackBar(content:Text(message),backgroundColor: backgroundColor,);
  }
}
