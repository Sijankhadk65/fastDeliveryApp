import 'package:fastdeliveryapp/src/bloc/order_bloc.dart';
import 'package:fastdeliveryapp/src/models/order_ref.dart';
import 'package:fastdeliveryapp/src/widgets/order_ref_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OrderRefrenceList extends StatefulWidget {
  final Map<String, dynamic> user;
  final Map<String, dynamic> appUser;

  const OrderRefrenceList({
    Key key,
    this.user,
    this.appUser,
  }) : super(key: key);
  @override
  _OrderRefrenceListState createState() => _OrderRefrenceListState();
}

class _OrderRefrenceListState extends State<OrderRefrenceList> {
  OrderBloc _orderBloc;

  @override
  void didChangeDependencies() {
    _orderBloc = Provider.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _orderBloc.getOrderRefrences(widget.user['email']);
    return Container(
      margin: EdgeInsets.only(
        top: 10,
      ),
      child: StreamBuilder<List<OrderRef>>(
        stream: _orderBloc.orderRefrences(
          widget.user['email'],
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text("Error:${snapshot.error}");
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text("Awaiting Bids");
              break;
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
            case ConnectionState.active:
              return snapshot.data.isNotEmpty
                  ? ListView(
                      shrinkWrap: true,
                      children: snapshot.data
                          .map<Widget>(
                            (refrence) => Provider(
                              create: (_) => OrderBloc(),
                              dispose: (context, OrderBloc bloc) =>
                                  bloc.dispose(),
                              child: OrderRefCard(
                                orderRef: refrence,
                                user: widget.appUser,
                              ),
                            ),
                          )
                          .toList(),
                    )
                  : Center(
                      child: Text(
                        "No Orders to look for.",
                        style: GoogleFonts.oswald(
                          color: Colors.red,
                        ),
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
    );
  }
}
