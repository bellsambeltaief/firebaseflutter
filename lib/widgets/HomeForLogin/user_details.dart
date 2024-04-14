import 'package:flutter/material.dart';
import 'package:smart/models/m_user.dart';
import 'package:smart/widgets/HomeForLogin/user_info_card.dart';

class UserDetails extends StatelessWidget {
  final MUser? user;
  const UserDetails({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          user!.firstName + user!.lastName,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        UserInfoCard(
          title: 'Salary',
          value: user!.salary,
          icon: Icons.monetization_on,
        ),
        UserInfoCard(
          title: 'Age',
          value: "${user!.age}",
          icon: Icons.cake,
        ),
        UserInfoCard(
          title: 'Marital Status',
          value: user!.maritalStatus,
          icon: Icons.favorite,
        ),
        UserInfoCard(
          title: 'Employment',
          value: user!.employment,
          icon: Icons.work,
        ),
      ],
    );
  }
}
