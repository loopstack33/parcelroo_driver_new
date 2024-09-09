import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapSample extends StatefulWidget {
  final double lat,lng;
  final String title;
  final String location;
  const MapSample({Key? key,required this.lat,required this.lng,required this.title,required this.location}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  late GoogleMapController mapController;

  final Set<Marker> _markers = {};

  void addMarker(String data,String loc,double lat,double lng) {
    _markers.clear();
   if(mounted){
     setState(() {
       _markers.add(Marker(
         markerId: MarkerId(data.toString()),
         position: LatLng(lat,lng),
         infoWindow: InfoWindow(
           title: data,
           snippet:loc,
         ),
       ));
     });
   }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(

        markers: _markers,

        initialCameraPosition: const CameraPosition(
          target: LatLng(0.0,0.0),
          zoom: 15,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          mapController = controller;
          addMarker(widget.title.toString(),widget.location.toString(), widget.lat, widget.lng);
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(widget.lat,widget.lng),
                zoom: 16,
              ),
            ),
          );
        },
      ),
    );
  }


}