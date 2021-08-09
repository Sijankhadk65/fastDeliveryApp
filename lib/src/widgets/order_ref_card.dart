import 'package:fastdeliveryapp/src/bloc/order_bloc.dart';
import 'package:fastdeliveryapp/src/screens/client_location_screen.dart';
import 'package:fastdeliveryapp/src/widgets/client_info_dialog.dart';
import 'package:fastdeliveryapp/src/widgets/order_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/order_ref.dart';

class OrderRefCard extends StatefulWidget {
  final OrderRef orderRef;
  final Map<String, dynamic> user;

  const OrderRefCard({
    Key key,
    @required this.orderRef,
    this.user,
  }) : super(key: key);

  @override
  _OrderRefCardState createState() => _OrderRefCardState();
}

class _OrderRefCardState extends State<OrderRefCard> {
  DateTime _date;

  OrderBloc _orderBloc;

  @override
  void didChangeDependencies() {
    _orderBloc = Provider.of<OrderBloc>(context);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _date = DateTime.parse(widget.orderRef.createdAt);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black26,
            offset: Offset(5, 5),
            blurRadius: 12,
          )
        ],
        gradient: LinearGradient(
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
          colors: [
            Colors.orange[400],
            Colors.orange[800],
          ],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.orderRef.isAssignedTo.email.isNotEmpty
              ? () {
                  showBottomSheet(
                    context: context,
                    builder: (context) => Provider(
                      create: (_) => OrderBloc(),
                      dispose: (context, OrderBloc bloc) => bloc.dispose(),
                      child: OrderBottomSheet(
                        refID: widget.orderRef.refID,
                      ),
                    ),
                  );
                }
              : null,
          child: Padding(
            padding: EdgeInsets.only(
              top: 5,
              left: 10,
              bottom: 5,
              right: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "order placed at ${_date.hour}:${_date.minute} ${_date.hour >= 12 ? "PM" : "AM"}, on ${_date.year}/${_date.month}/${_date.day}",
                  style: GoogleFonts.montserrat(
                    fontStyle: FontStyle.italic,
                    color: Colors.black26,
                  ),
                ),
                Text(widget.orderRef.refID),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        widget.orderRef.user.name.toUpperCase(),
                        style: GoogleFonts.oswald(
                          fontSize: 30,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                    Text(
                      "Rs.${widget.orderRef.totalCost}",
                      style: GoogleFonts.nunito(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                        right: 2.5,
                      ),
                      child: RawMaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                        ),
                        fillColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ClientLocationScreen(
                                lat: widget.orderRef.lat,
                                lang: widget.orderRef.lang,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "Get Location",
                          style: GoogleFonts.nunito(
                            color: Colors.orange[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 2.5,
                        right: 2.5,
                      ),
                      child: RawMaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                        ),
                        fillColor: Colors.white,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => Provider(
                              create: (_) => OrderBloc(),
                              child: CilentInfoDialog(
                                email: widget.orderRef.user.email,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "Get Client Info",
                          style: GoogleFonts.nunito(
                            color: Colors.orange[600],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 2.5,
                      ),
                      child: widget.orderRef.isAssignedTo.email.isNotEmpty
                          ? !widget.orderRef.isDelivered
                              ? RawMaterialButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      5,
                                    ),
                                  ),
                                  fillColor: Colors.white,
                                  onPressed: () {
                                    print("Button has been clicked!");
                                    _orderBloc
                                        .deliverOrder(
                                          widget.orderRef.refID,
                                        )
                                        .whenComplete(
                                          () => print(
                                              "The order has been assigned."),
                                        );
                                  },
                                  child: Text(
                                    "Deliver Order",
                                    style: GoogleFonts.nunito(
                                      color: Colors.orange[400],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : RawMaterialButton(
                                  fillColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      5,
                                    ),
                                  ),
                                  onPressed: () {
                                    _orderBloc
                                        .takePayment(
                                          widget.orderRef.refID,
                                        )
                                        .whenComplete(
                                          () => print(
                                              "The order has been assigned."),
                                        );
                                  },
                                  child: Text(
                                    "Take Payment",
                                    style: GoogleFonts.nunito(
                                      color: Colors.orange[400],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                          : RawMaterialButton(
                              fillColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  5,
                                ),
                              ),
                              onPressed: () {
                                print("Button has been clicked!");
                                _orderBloc
                                    .takeOrder(
                                      widget.orderRef.refID,
                                      widget.user,
                                    )
                                    .whenComplete(
                                      () =>
                                          print("The order has been assigned."),
                                    );
                              },
                              child: Text(
                                "Take Order",
                                style: GoogleFonts.nunito(
                                  color: Colors.orange[800],
                                ),
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
