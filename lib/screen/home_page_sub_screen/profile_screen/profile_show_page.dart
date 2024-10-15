import 'package:flutter/material.dart';
import 'package:spark_up/route.dart';

class ProfileShowPage extends StatefulWidget {
  const ProfileShowPage({super.key});

  @override
  State<ProfileShowPage> createState() => _ProfileShowPageState();
}

class _ProfileShowPageState extends State<ProfileShowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("A"),
      ),
      body:Center(
        child: ElevatedButton(
          onPressed:()=>Navigator.pushNamed(context, RouteMap.editProfile),
          child: Text("Go to event type profile"),  
        ),
      )
    );
  }
}