import 'package:fastdeliveryapp/src/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
        margin: EdgeInsets.all(
          10,
        ),
        height: 300,
        child: Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(
            5,
          ),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: Column(
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    text: "FAST",
                    style: GoogleFonts.oswald(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                    ),
                    children: [
                      TextSpan(
                        text: "DELIVERY",
                        style: GoogleFonts.oswald(
                          fontSize: 25,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[800].withAlpha(
                            100,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                StreamBuilder<String>(
                  stream: _loginBloc.email,
                  builder: (context, snapshot) {
                    return Container(
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,
                            offset: Offset(
                              0,
                              5,
                            ),
                          )
                        ],
                      ),
                      child: TextField(
                        onChanged: _loginBloc.changeEmail,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: InputBorder.none,
                        ),
                      ),
                    );
                  },
                ),
                StreamBuilder<String>(
                  stream: _loginBloc.password,
                  builder: (context, snapshot) {
                    return Container(
                      margin: EdgeInsets.only(top: 15),
                      padding: EdgeInsets.only(
                        left: 10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 10,
                            offset: Offset(
                              0,
                              5,
                            ),
                          )
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: InputBorder.none,
                        ),
                        obscureText: true,
                        onChanged: _loginBloc.changePassword,
                      ),
                    );
                  },
                ),
                StreamBuilder<bool>(
                  stream: _loginBloc.canLogin(),
                  builder: (context, snapshot) {
                    return Container(
                      height: 50,
                      width: 150,
                      margin: EdgeInsets.only(
                        top: 15,
                      ),
                      child: ProgressButton(
                        color:
                            snapshot.hasData ? Colors.orange[500] : Colors.grey,
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            8,
                          ),
                        ),
                        strokeWidth: 2,
                        child: Text(
                          "Login",
                          style: GoogleFonts.nunito(
                            color: snapshot.hasData
                                ? Colors.white
                                : Colors.black38,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                        onPressed: snapshot.hasData
                            ? (AnimationController controller) {
                                controller.forward();
                                _loginBloc.login().whenComplete(
                                      () => controller.reverse(),
                                    );
                              }
                            : (controller) {},
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
