import 'package:decimal/bloc/profile_content/profile_content_bloc.dart';
import 'package:decimal/config/constants.dart';
import 'package:decimal/config/theme.dart';
import 'package:decimal/models/user_model.dart';
import 'package:decimal/screens/auth/widgets/buttons.dart';
import 'package:decimal/screens/auth/widgets/profile_form.dart';
import 'package:decimal/screens/auth/widgets/profile_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class ProfileContent extends StatefulWidget {
  const ProfileContent({super.key});

  @override
  State<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<ProfileContent> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController pseudoController = TextEditingController();
  String? coverPictureUrl;
  String? profilePictureUrl;
  String buttontext = 'Validate';

  final _formKey = GlobalKey<FormState>();

  @override
  initState() {
    super.initState();
    BlocProvider.of<ProfileContentBloc>(context).add(GetProfile());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileContentBloc, ProfileContentState>(
      listener: (context, state) {
        if (state is ProfileContentSuccess) {
          setState(() {
            coverPictureUrl = state.user!.cover_picture;
            profilePictureUrl = state.user!.profile_picture;
          });
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(gradient: AppColors.gradient),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProfileHeader(
                    coverPictureUrl: coverPictureUrl,
                    profilePictureUrl: profilePictureUrl,
                    name: "${firstNameController.text} ${lastNameController.text}",
                    pseudo: pseudoController.text,
                  ),
                  ProfileForm(
                    coverPictureUrl: coverPictureUrl,
                    profilePictureUrl: profilePictureUrl,
                    firstNameController: firstNameController,
                    lastNameController: lastNameController,
                    pseudoController: pseudoController,
                  ),
                  Buttons(
                    buttonText: buttontext,
                    onPressed: () {
                      if (buttontext == 'Continue') {
                        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
                      }
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          buttontext = 'Continue';
                        });
                        BlocProvider.of<ProfileContentBloc>(context).add(UpdateProfile(CustomUser(
                          id: supabaseUser!.id,
                          name: "${firstNameController.text} ${lastNameController.text}",
                          pseudo: pseudoController.text,
                          profile_picture: profilePictureUrl,
                          cover_picture: coverPictureUrl,
                        )));
                      }
                    },
                  ),
                  const Gap(4),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
