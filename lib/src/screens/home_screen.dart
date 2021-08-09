import 'package:cached_network_image/cached_network_image.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:fastdeliveryapp/src/bloc/login_bloc.dart';
import 'package:fastdeliveryapp/src/bloc/order_bloc.dart';
import 'package:fastdeliveryapp/src/models/user.dart';
import 'package:fastdeliveryapp/src/widgets/custom_tab_bar.dart';
import 'package:fastdeliveryapp/src/widgets/order_ref_list.dart';
import 'package:fastdeliveryapp/src/widgets/paid_orders_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  HomeScreen({
    Key key,
    this.user,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  List<String> _options = [
    "ASSIGNED",
    "FREE",
    "PAID",
  ];
  LoginBloc _loginBloc;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _configureFCM() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('onMessage: $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _configureFCM();
  }

  @override
  void didChangeDependencies() {
    _loginBloc = Provider.of<LoginBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
          text: TextSpan(
            text: "FAST",
            style: GoogleFonts.oswald(
              color: Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: "DELIVERY",
                style: GoogleFonts.oswald(
                  color: Colors.black38,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              EvaIcons.logOut,
              color: Colors.black,
            ),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          StreamBuilder<User>(
            stream: _loginBloc.getUser(widget.user['email']),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Text("Error: ${snapshot.error}");
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return Text("Awaikting Bids...");
                  break;
                case ConnectionState.waiting:
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                  break;
                case ConnectionState.active:
                  return Container(
                    margin: EdgeInsets.all(
                      10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: CachedNetworkImage(
                            imageUrl: snapshot.data.photoURI,
                            imageBuilder: (context, imageBuilder) {
                              return Container(
                                height: 150,
                                padding: EdgeInsets.all(
                                  10,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(0, 5),
                                      blurRadius: 10,
                                    )
                                  ],
                                  image: DecorationImage(
                                    image: imageBuilder,
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                      Colors.black12,
                                      BlendMode.srcOver,
                                    ),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Text(
                                      snapshot.data.name.toUpperCase(),
                                      style: GoogleFonts.oswald(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.5,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      snapshot.data.email,
                                      style: GoogleFonts.oswald(
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.5,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.white.withAlpha(
                                          200,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            placeholder: (context, msg) => Container(
                              color: Colors.green,
                            ),
                            errorWidget: (context, msg, error) => Container(
                              height: 150,
                              width: 150,
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                  break;
                case ConnectionState.done:
                  return Text("The task has completed");
                  break;
              }
              return null;
            },
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                top: 10,
              ),
              child: CustomTabView(
                itemCount: 3,
                tabBuilder: (context, index) => Text(
                  _options[index],
                ),
                pageBuilder: (context, index) => index != 2
                    ? Provider(
                        create: (_) => OrderBloc(),
                        dispose: (context, OrderBloc bloc) => bloc.dispose(),
                        child: OrderRefrenceList(
                          appUser: widget.user,
                          user: index != 1
                              ? widget.user
                              : {"name": "", "email": ""},
                        ),
                      )
                    : Provider(
                        create: (_) => OrderBloc(),
                        dispose: (context, OrderBloc bloc) => bloc.dispose(),
                        child: PaidOffers(
                          appUser: widget.user,
                          user: widget.user,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
