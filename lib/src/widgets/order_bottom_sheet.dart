import 'package:fastdeliveryapp/src/bloc/order_bloc.dart';
import 'package:fastdeliveryapp/src/models/online_order.dart';
import 'package:fastdeliveryapp/src/widgets/cart_list.dart';
import 'package:fastdeliveryapp/src/widgets/progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

// import 'cart_list.dart';
import 'custom_tab_bar.dart';

class OrderBottomSheet extends StatefulWidget {
  final String refID;

  const OrderBottomSheet({Key key, this.refID}) : super(key: key);
  @override
  _OrderBottomSheetState createState() => _OrderBottomSheetState();
}

class _OrderBottomSheetState extends State<OrderBottomSheet> {
  OrderBloc _orderBloc;

  @override
  void didChangeDependencies() {
    _orderBloc = Provider.of<OrderBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _orderBloc.getOrders(widget.refID);
    return Container(
      margin: EdgeInsets.all(
        10,
      ),
      padding: EdgeInsets.all(
        10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(
          5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            offset: Offset(0, 0),
          )
        ],
      ),
      child: StreamBuilder<List<OnlineOrder>>(
        stream: _orderBloc.currentOrders,
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text("Error: ${snapshot.error}");
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text("Awaiting Bids....");
              break;
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
              break;
            case ConnectionState.active:
              return Column(
                children: <Widget>[
                  Expanded(
                    child: CustomTabView(
                      itemCount: snapshot.data.length,
                      tabBuilder: (context, index) => Column(
                        children: <Widget>[
                          Text(
                            snapshot.data[index].vendor,
                          ),
                          Text(
                            "Subtotal: Rs.${snapshot.data[index].totalPrice}",
                            style: GoogleFonts.nunito(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.normal,
                              color: Colors.black38,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      pageBuilder: (context, index) => Column(
                        children: <Widget>[
                          ProgressWidget(
                            status: snapshot.data[index].status.toList(),
                          ),
                          Provider(
                            create: (_) => OrderBloc(),
                            dispose: (context, OrderBloc bloc) =>
                                bloc.dispose(),
                            child: Column(
                              children: <Widget>[
                                // ProgressWidget(
                                //   status: snapshot.data[index].status.toList(),
                                // ),
                                CartList(
                                  job: "history",
                                  items: snapshot.data[index].items.toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
              break;
            case ConnectionState.done:
              return Text("The task has completed.");
              break;
          }
          return null;
        },
      ),
    );
  }
}
