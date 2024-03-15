import 'package:decimal/config/theme.dart';
import 'package:decimal/screens/home/widgets/profile_contacts.dart';
import 'package:decimal/screens/home/widgets/profile_description.dart';
import 'package:decimal/screens/home/widgets/profile_pics.dart';
import 'package:decimal/screens/home/widgets/publications.dart';
import 'package:decimal/screens/home/widgets/profile_stories.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String type = 'posts';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: AppColors.primaryBackground,
        child: Column(
          children: [
            const ProfileDescription(),
            const ProfileStories(),
            const ProfilePics(),
            const ProfileContacts(),
            Publications(type: type),
          ],
        ),
      ),
    );
  }
}