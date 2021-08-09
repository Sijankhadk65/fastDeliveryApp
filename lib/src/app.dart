import 'package:fastdeliveryapp/src/bloc/login_bloc.dart';
import 'package:fastdeliveryapp/src/root.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        tabBarTheme: TabBarTheme(
          labelStyle: GoogleFonts.nunito(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
          unselectedLabelStyle: GoogleFonts.nunito(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.black,
          labelPadding: EdgeInsets.all(
            5,
          ),
          indicator: BoxDecoration(
            color: Colors.green,
            boxShadow: [
              BoxShadow(
                color: Colors.greenAccent,
                offset: Offset(0, 8),
                blurRadius: 15,
                spreadRadius: -5,
              )
            ],
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        appBarTheme: AppBarTheme(
          elevation: 0.0,
          color: Colors.white,
          textTheme: TextTheme(
            headline6: GoogleFonts.oswald(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: Provider(
        create: (_) => LoginBloc(),
        dispose: (context, LoginBloc bloc) => bloc.dispose(),
        child: Root(),
      ),
    );
  }
}
