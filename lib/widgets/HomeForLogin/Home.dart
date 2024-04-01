import 'package:flutter/material.dart';
import 'package:smart/widgets/HomeForLogin/balance_card.dart';
import 'package:smart/widgets/HomeForLogin/purchase_button.dart';
import 'package:smart/widgets/HomeForLogin/user_details.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    Color blue800 = Colors.blue[800] ?? Colors.blue;
    Color blue300 = Colors.blue[300] ?? Colors.lightBlue;

    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [blue800, blue300],
              stops: const [0.2, 1],
            ),
          ),
          child: const SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 40),
                BalanceCard(),
                SizedBox(height: 20),
                UserDetails(),
                PurchaseButton(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
