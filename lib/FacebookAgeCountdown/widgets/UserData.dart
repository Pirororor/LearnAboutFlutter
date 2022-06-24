import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserData extends StatelessWidget {
  final Map<String, dynamic> profileData;
  final void Function() onLogout;

  const UserData({Key? key, required this.profileData, required this.onLogout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final salutation = profileData['gender'] == 'male' ? "Dude" : "Ma'am";
    final birthday = DateFormat('MM/DD/yyyy').parse(profileData['birthday']);

    final now = DateTime.now();
    final birthdayThisYear = DateTime(now.year, birthday.month, birthday.day);

    final nextBirthday = birthdayThisYear.isAfter(now)
        ? birthdayThisYear
        : DateTime(now.year + 1, birthday.month, birthday.day);
    final int age = now.difference(birthday).inDays ~/ 365;
    final int daysToBirthday = nextBirthday.difference(now).inDays;

    return ListView(
      children: <Widget>[
        const SizedBox(height: 100.0),
        Container(
          height: 100.0,
          width: 100.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.contain,
              image: NetworkImage(
                profileData['picture']['data']['url'],
              ),
            ),
          ),
        ),
        const SizedBox(height: 28.0),
        Center(
            child: Text(
          'Welcome ${profileData['name']}, $salutation!',
          style: const TextStyle(
            fontSize: 20.0,
          ),
        )),
        const SizedBox(height: 28.0),
        Center(child: Text('Wow, $age years old liao!')),
        Center(child: Text('Only $daysToBirthday days to next milestone!')),
        const SizedBox(height: 28.0),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: ElevatedButton(
            child: Text('Logout'),
            onPressed: onLogout,
          ),
        )
      ],
    );
  }
}
