import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(children: [Image.asset("images/home.jpg",width:MediaQuery.of(context).size.width, height:200,
        fit: BoxFit.cover,)]),
      ),
    );
  }
}
