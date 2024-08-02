import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:helpinghands/config.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class DonorRegistrationScreen extends StatefulWidget {
  final String userEmail;
  @override
  _DonorRegistrationScreenState createState() =>
      _DonorRegistrationScreenState();
  const DonorRegistrationScreen({Key? key, required this.userEmail}) : super(key: key);

}

class _DonorRegistrationScreenState extends State<DonorRegistrationScreen> {
  TextEditingController pickUpLocationController = TextEditingController();
  TextEditingController foodDescriptionController = TextEditingController();
  TextEditingController serversController = TextEditingController();
  DateTime? expiryDate;
  List<String> foodTypes = ['Leftover', 'Packed', 'Homemade', 'Other'];
  List<String> selectedFoodTypes = [];
  LatLng? selectedLocation;
  bool _isNotValidate = false;


  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, prompt the user to enable them.
      // You can show a dialog or snackbar to inform the user.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle the case where location permissions are denied.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Location permissions are permanently denied.');
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return position;
    } catch (e) {
      // Handle any other errors that may occur when obtaining the location.
      return Future.error('Error getting location: $e');
    }
  }

  void donorreg() async {
    if (foodDescriptionController.text.isNotEmpty &&
        serversController.text.isNotEmpty &&
        expiryDate != null &&
        selectedFoodTypes.isNotEmpty &&
        pickUpLocationController.text.isNotEmpty) {
      var regBody = {
        "foodDescription": foodDescriptionController.text,
        "serves": serversController.text,
        "expiryDate": expiryDate!.toIso8601String(),
        "selectedFoodTypes": selectedFoodTypes,
        "pickUpLocation": pickUpLocationController.text,
        "userEmail": widget.userEmail,
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
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: pickUpLocationController,
                          decoration: InputDecoration(
                            labelText: 'Pick-up Location',
                            prefixIcon: Icon(Icons.gps_fixed_rounded),
                            border: InputBorder.none,
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            labelStyle: GoogleFonts.openSans(),
                          ),
                          style: GoogleFonts.openSans(),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        final status = await Permission.location.request();
                        if (status.isGranted) {
                          try {
                            Position position = await determinePosition();
                            List<Placemark> placemarks = await placemarkFromCoordinates(
                                position.latitude, position.longitude);

                            if (placemarks.isNotEmpty) {
                              Placemark placemark = placemarks[0];
                              // Build the complete address by combining address components
                              String address = '';
                              if (placemark.name != null) {
                                address += placemark.name! + ', ';
                              }
                              if (placemark.street != null) {
                                address += placemark.street! + ', ';
                              }
                              if (placemark.subLocality != null) {
                                address += placemark.subLocality! + ', ';
                              }
                              if (placemark.locality != null) {
                                address += placemark.locality! + ', ';
                              }
                              if (placemark.administrativeArea != null) {
                                address += placemark.administrativeArea! + ' ';
                              }
                              if (placemark.postalCode != null) {
                                address += placemark.postalCode!;
                              }

                              // Update the pick-up location controller with the complete address
                              pickUpLocationController.text = address;

                            } else {
                              pickUpLocationController.text = "Location not found";
                            }
                          } catch (e) {
                            // Handle any errors that occur when obtaining the location
                            print('Error obtaining location: $e');
                          }
                        } else {
                          // Handle the case where the user denied location permissions
                          print('Location permissions denied by the user.');
                        }
                      },
                      icon: Icon(Icons.gps_fixed_rounded),
                      color: Color(0xFF07689F), // Adjust the icon color
                    ),
                  ],
                ),
              ),
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