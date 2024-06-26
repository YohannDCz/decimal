// ignore_for_file: non_constant_identifier_names

import 'package:decimal/bloc/profile/profile_bloc.dart' as pro;
import 'package:decimal/bloc/profile_content/profile_content_bloc.dart';
import 'package:decimal/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CoverPicWidget extends StatefulWidget {
  const CoverPicWidget({super.key, required String user_uuid}) : _user_uuid = user_uuid;

  final String _user_uuid;

  @override
  State<CoverPicWidget> createState() => _CoverPicWidgetState();
}

class _CoverPicWidgetState extends State<CoverPicWidget> {
  String? coverPictureUrl;

  @override
  initState() {
    super.initState();
    BlocProvider.of<pro.ProfileBloc>(context).add(pro.GetProfile(widget._user_uuid));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<pro.ProfileBloc, pro.ProfileState>(
      listener: (context, state) {
        if (state is pro.GetProfileSuccess) {
          coverPictureUrl = state.profile.cover_picture;
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.black,
            body: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    top: 0,
                    child: Hero(
                      tag: 'MyHeroCoverPic',
                      child: Image.network(
                        coverPictureUrl ?? "https://hxlaujiaybgubdzzkoxu.supabase.co/storage/v1/object/public/Assets/image/placeholders/profile_placeholder.png?t=2024-03-26T12%3A04%3A29.640Z",
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.black.withOpacity(0.25)),
                        ),
                        icon: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: AppColors.white,
                          ),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Material(
                        elevation: 4.0,
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        color: AppColors.black,
                        child: CircleAvatar(
                          radius: 16.0,
                          backgroundColor: AppColors.white,
                          child: IconButton(
                            onPressed: () {
                              BlocProvider.of<ProfileContentBloc>(context).add(UploadCoverPicture());
                            },
                            icon: const Icon(Icons.edit, size: 16),
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
