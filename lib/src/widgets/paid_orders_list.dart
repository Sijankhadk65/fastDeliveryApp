import 'package:fastdeliveryapp/src/bloc/order_bloc.dart';
import 'package:fastdeliveryapp/src/models/order_ref.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'order_ref_card.dart';

class PaidOffers extends StatefulWidget {
  final Map<String, dynamic> user;
  final Map<String, dynamic> appUser;
  const PaidOffers({
    Key key,
    this.user,
    this.appUser,
  }) : super(key: key);

  @override
  _PaidOffersState createState() => _PaidOffersState();
}

class _PaidOffersState extends State<PaidOffers> {
  OrderBloc _orderBloc;

  @override
  void didChangeDependencies() {
    _orderBloc = Provider.of(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<List<OrderRef>>(
        stream: _orderBloc.getPaidOrders(widget.user['email']),
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
