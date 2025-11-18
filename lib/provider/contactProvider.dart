import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/properties/email.dart';
import 'package:flutter_contacts/properties/phone.dart';
import 'package:flutter/material.dart';

import '../models/contact.dart';
import '../services/DbServices.dart';

class ContactProvider with ChangeNotifier {
  final DbServices _dbServices = DbServices();

  List<myContactModel> _contacts = [];
  List<myContactModel> _backUpContacts = [];
  List<Contact> deviceContacts = [];

  List<myContactModel> get contacts => _contacts;

  ContactProvider() {
    // Initialize backup list
    _backUpContacts = List.from(_contacts);
  }

  // ---------------- GET CONTACTS ----------------
  Future<List<myContactModel>> getContacts() async {
    final value = await _dbServices.getData("contact");
    _contacts = value;
    _backUpContacts = List.from(_contacts);
    notifyListeners();
    return _contacts;
  }

  // ---------------- ADD SINGLE CONTACT ----------------
  Future<bool> addContact(myContactModel contact, String tableName) async {
    final id = await _dbServices.insertSingleData(contact, tableName);
    if (id == -1) return false;

    contact.id = id;
    _contacts.add(contact);
    _backUpContacts.add(contact); // update backup

    // Add to device contacts
    final newCont = Contact()
      ..name.first = contact.firstName ?? ""
      ..name.last = contact.lastName ?? ""
      ..phones.add(Phone(contact.phone))
      ..emails.add(Email(contact.email));

    final res = await newCont.insert();
    deviceContacts.add(res);

    notifyListeners();
    return true;
  }

  // ---------------- DELETE CONTACT ----------------
  Future<bool> deleteContact(int id, String tableName) async {
    final result = await _dbServices.deleteRecord(id, tableName);
    if (result == -1) return false;

    _contacts.removeWhere((c) => c.id == id);
    _backUpContacts.removeWhere((c) => c.id == id);
    notifyListeners();
    return true;
  }

  // ---------------- DELETE ALL ----------------
  Future<bool> deleteAllContacts(String tableName) async {
    final result = await _dbServices.deleteAllData(tableName);
    if (result == -1) return false;

    _contacts.clear();
    _backUpContacts.clear();
    notifyListeners();
    return true;
  }

  // ---------------- UPDATE CONTACT ----------------
  Future<bool> updateContact(int id, myContactModel data, String tableName) async {
    final result = await _dbServices.updateData(id, data, tableName);
    if (result == -1) return false;

    final index = _contacts.indexWhere((c) => c.id == id);
    if (index != -1) _contacts[index] = data;

    final backupIndex = _backUpContacts.indexWhere((c) => c.id == id);
    if (backupIndex != -1) _backUpContacts[backupIndex] = data;

    notifyListeners();
    return true;
  }

  // ---------------- CLOSE DATABASE ----------------
  Future<bool> closeDatabase() async {
    final result = await _dbServices.closeDatabase();
    if (!result) return false;

    _contacts.clear();
    _backUpContacts.clear();
    notifyListeners();
    return true;
  }

  // ---------------- SET DEVICE CONTACTS ----------------
  void setDeviceContacts(List<Contact> contacts) {
    deviceContacts = contacts;
  }

  // ---------------- SEARCH ----------------
  void searchListByName(String name) {
    if (name.isEmpty) {
      _contacts = List.from(_backUpContacts);
    } else {
      final search = name.toLowerCase();
      _contacts = _backUpContacts.where((contact) {
        final first = (contact.firstName ?? "").toLowerCase();
        final last = (contact.lastName ?? "").toLowerCase();
        return first.contains(search) || last.contains(search);
      }).toList();
    }
    notifyListeners();
  }

  // ---------------- DELETE DATABASE ----------------
  Future<bool> deleteDb() async {
    final result = await _dbServices.deleteDb();
    if (!result) return false;

    _contacts.clear();
    _backUpContacts.clear();
    notifyListeners();
    return true;
  }

  // ---------------- ADD MULTIPLE CONTACTS ----------------
  Future<bool> addMultipleData(List<myContactModel> contacts, String tableName) async {
    final result = await _dbServices.insertMultipleData(contacts, tableName);
    if (result.isEmpty) return false;

    for (int i = 0; i < result.length; i++) {
      contacts[i].id = result[i];
    }

    _contacts.addAll(contacts);
    _backUpContacts.addAll(contacts); // update backup

    notifyListeners();
    return true;
  }
}
