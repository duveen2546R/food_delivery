import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:savor_go1/screens/MainScreen.dart';

const String BASE_URL = "http://127.0.0.1:5000";

class LocationPickerScreen extends StatefulWidget {
  final String userId; // ✅ Accept User_ID from login

  LocationPickerScreen({required this.userId});

  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  late final MapController _mapController;
  LatLng _selectedLocation = LatLng(13.0827, 80.2707); // Default location
  TextEditingController _addressController = TextEditingController(); // Address input
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  Future<void> saveAddress() async {
    if (_addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your address")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse("$BASE_URL/add_address"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "User_ID": widget.userId,
          "address": _addressController.text,
          "latitude": _selectedLocation.latitude,
          "longitude": _selectedLocation.longitude,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Address saved successfully!")),
        );

        Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (context) => MainScreen( 
      userId: widget.userId,
      selectedLocation: _selectedLocation.toString(),
      enteredAddress: _addressController.text,
    ),
  ),
  (Route<dynamic> route) => false, 
);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data["error"])));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error saving address!")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select Your Delivery Location")),
      body: Column(
        children: [
          Expanded(
            child: Focus(
              autofocus: true,
              onKey: (FocusNode node, RawKeyEvent event) {
                if (event is RawKeyDownEvent) {
                  if (event.logicalKey == LogicalKeyboardKey.minus) {
                    _mapController.move(_mapController.center, _mapController.zoom - 1);
                  } else if (event.logicalKey == LogicalKeyboardKey.equal) {
                    _mapController.move(_mapController.center, _mapController.zoom + 1);
                  }
                }
                return KeyEventResult.handled;
              },
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: _selectedLocation,
                  zoom: 10.0,
                  onTap: (tapPosition, point) {
                    setState(() {
                      _selectedLocation = point;
                    });
                    _mapController.move(point, _mapController.zoom);
                  },
                ),
                children: [
                  TileLayer(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                    subdomains: ['a', 'b', 'c'],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _selectedLocation,
                        width: 40.0,
                        height: 40.0,
                        child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: "Enter your address",
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // Floating Action Buttons
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    _mapController.move(_mapController.center, _mapController.zoom + 1);
                  },
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  child: const Icon(Icons.remove),
                  onPressed: () {
                    _mapController.move(_mapController.center, _mapController.zoom - 1);
                  },
                ),
                const SizedBox(width: 10),
                FloatingActionButton.extended(
                  icon: const Icon(Icons.check),
                  label: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Confirm"),
                  onPressed: isLoading ? null : saveAddress,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}