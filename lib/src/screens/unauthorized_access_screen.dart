import 'package:fastdeliveryapp/src/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UnauthorizedAccess extends StatefulWidget {
  @override
  _UnauthorizedAccessState createState() => _UnauthorizedAccessState();
}

class _UnauthorizedAccessState extends State<UnauthorizedAccess> {
  LoginBloc _loginBloc;

  @override
  void didChangeDependencies() {
    _loginBloc = Provider.of<LoginBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text("Unauthorized Access!"),
              RaisedButton(
                onPressed: () => _loginBloc.logout,
                child: Text("Logout"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
