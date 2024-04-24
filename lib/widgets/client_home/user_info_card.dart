import 'package:flutter/material.dart';

class UserInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const UserInfoCard({
    Key? key,
    required this.title,
    required this.value,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.blue[800],
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.blue[800],
            fontSize: 18,
          ),
        ),
        trailing: Text(
          value,
          style: TextStyle(
            color: Colors.blue[800],
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
