import 'package:fastdeliveryapp/src/bloc/login_bloc.dart';
import 'package:fastdeliveryapp/src/screens/home_screen.dart';
import 'package:fastdeliveryapp/src/screens/login_screen.dart';
import 'package:fastdeliveryapp/src/screens/unauthorized_access_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  LoginBloc _loginBloc;

  @override
  void didChangeDependencies() {
    _loginBloc = Provider.of<LoginBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<FirebaseUser>(
        stream: _loginBloc.getCurrentUser(),
        builder: (context, userSnapshot) {
          return Provider(
            create: (_) => LoginBloc(),
            dispose: (context, LoginBloc bloc) => bloc.dispose(),
            child: userSnapshot.hasData
                ? StreamBuilder<String>(
                    stream: _loginBloc.getUserRole(userSnapshot.data.email),
                    builder: (context, snapshot) {
                      return snapshot.data == "delivery"
                          ? HomeScreen(
                              user: {
                                "name": userSnapshot.data.displayName,
                                "email": userSnapshot.data.email,
                              },
                            )
                          : UnauthorizedAccess();
                    },
                  )
                : LoginScreen(),
          );
        },
      ),
    );
  }
}
