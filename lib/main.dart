import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_chat_application/UI/app_scaffold.dart';

import 'bloc/users/users_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UsersBloc()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AppScaffold(),
      ),
    );
  }
}
