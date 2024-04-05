import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:helpinghands/config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DonorRegistrationScreen extends StatefulWidget {
  @override
  _DonorRegistrationScreenState createState() =>
      _DonorRegistrationScreenState();
}

class _DonorRegistrationScreenState extends State<DonorRegistrationScreen> {
  TextEditingController foodDescriptionController = TextEditingController();
  TextEditingController serversController = TextEditingController();
  DateTime? expiryDate;
  List<String> foodTypes = ['Leftover', 'Packed', 'Homemade', 'Other'];
  List<String> selectedFoodTypes = [];
  bool _isNotValidate = false;

  void donorreg() async {
    if (foodDescriptionController.text.isNotEmpty &&
        serversController.text.isNotEmpty &&
        expiryDate != null &&
        selectedFoodTypes.isNotEmpty) {
      var regBody = {
        "foodDescription": foodDescriptionController.text,
        "serves": serversController.text,
        "expiryDate": expiryDate!.toIso8601String(),
        "selectedFoodTypes": selectedFoodTypes,
      };

      var response = await http.post(
        Uri.parse(donorregistration),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regBody),
      );

      print(response);
    } else {
      setState(() {
        _isNotValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Request',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(0xFFFF7E67),
        elevation: 4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 16),
              Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFCDE6F6),
                child: Column(
                  children: [
                    Text(
                      "Food Types",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Column(
                      children: foodTypes.map((type) {
                        return CheckboxListTile(
                          title: Text(type),
                          value: selectedFoodTypes.contains(type),
                          onChanged: (newValue) {
                            setState(() {
                              if (newValue!) {
                                selectedFoodTypes.add(type);
                              } else {
                                selectedFoodTypes.remove(type);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFCDE6F6),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    controller: foodDescriptionController,
                    decoration: InputDecoration(
                      labelText: 'Food Description',
                      prefixIcon: Icon(Icons.food_bank_outlined),
                      border: InputBorder.none,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      labelStyle: GoogleFonts.openSans(),
                    ),
                    style: GoogleFonts.openSans(),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFCDE6F6),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextFormField(
                    controller: serversController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Serves',
                      prefixIcon: Icon(Icons.people_alt_outlined),
                      border: InputBorder.none,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      labelStyle: GoogleFonts.openSans(),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.keyboard_arrow_up),
                            onPressed: () {
                              int currentValue = int.tryParse(serversController.text) ?? 0;
                              setState(() {
                                serversController.text = (currentValue + 1).toString();
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.keyboard_arrow_down),
                            onPressed: () {
                              int currentValue = int.tryParse(serversController.text) ?? 0;
                              if (currentValue > 0) {
                                setState(() {
                                  serversController.text = (currentValue - 1).toString();
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    style: GoogleFonts.openSans(),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFFCDE6F6),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              DateTime? selectedDate = await showDatePicker(
                                context: context,
                                initialDate: expiryDate ?? DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(Duration(days: 365)),
                              );

                              if (selectedDate != null) {
                                setState(() {
                                  expiryDate = selectedDate;
                                });
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Expiry',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  Icon(
                                    Icons.calendar_today,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        if (expiryDate != null)
                          Container(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Expiry Date: ${expiryDate!.toLocal()}'.split(' ')[0],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  donorreg();
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFFFF7E67),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  elevation: 8,
                ),
                child: Text(
                  'Register as Donor',
                  style: GoogleFonts.openSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
