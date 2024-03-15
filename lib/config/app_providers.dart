import 'package:decimal/bloc/authentication/authentication_bloc.dart';
import 'package:decimal/bloc/profile_content/profile_content_bloc.dart';
import 'package:decimal/service/authentication_service.dart';
import 'package:decimal/service/profile_content_serrvice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Bloc extends StatelessWidget {
  const Bloc({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthenticationService(supabaseClient: Supabase.instance.client),
        ),
        RepositoryProvider(
          create: (context) => ProfileContentService(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationBloc(authenticationService: context.read<AuthenticationService>()),
          ),
          BlocProvider(
            create: (context) => ProfileContentBloc(profileContentService: context.read<ProfileContentService>()),
          ),
        ],
        child: child,
      ),
    );
  }
}