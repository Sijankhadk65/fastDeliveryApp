import 'package:fastdeliveryapp/src/bloc/order_bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/cart_items.dart';
import '../widgets/cart_item_card.dart';

class CartList extends StatefulWidget {
  final List<CartItem> items;
  final String job, vendor;

  const CartList({
    Key key,
    this.items,
    this.job,
    this.vendor,
  }) : super(key: key);
  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  OrderBloc _orderBloc;

  @override
  void didChangeDependencies() {
    _orderBloc = Provider.of<OrderBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return widget.items.isEmpty
        ? Center(
            child: Text(
              "No Items here!",
              style: GoogleFonts.pacifico(),
            ),
          )
        : ListView(
            shrinkWrap: true,
            children: widget.items
                .map(
                  (e) => Dismissible(
                    key: Key(e.name),
                    onDismissed: (direction) {},
                    child: CartItemCard(
                      cartItem: e,
                    ),
                  ),
                )
                .toList(),
          );
  }
}
