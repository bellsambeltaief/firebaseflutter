import 'package:flutter/material.dart';
import 'package:smart/widgets/HomeForLogin/user_info_card.dart';

class UserDetails extends StatelessWidget {
  const UserDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        Text(
          'John Doe | ID 278',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20),
        UserInfoCard(
          title: 'Salary',
          value: '\$2937.15',
          icon: Icons.monetization_on,
        ),
        UserInfoCard(
          title: 'Age',
          value: '28',
          icon: Icons.cake,
        ),
        UserInfoCard(
          title: 'Marital Status',
          value: 'Single',
          icon: Icons.favorite,
        ),
        UserInfoCard(
          title: 'Employment',
          value: 'Software Engineer',
          icon: Icons.work,
        ),
      ],
    );
  }
}
