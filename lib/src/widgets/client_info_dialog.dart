import 'package:fastdeliveryapp/src/bloc/order_bloc.dart';
import 'package:fastdeliveryapp/src/models/fast_client.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CilentInfoDialog extends StatefulWidget {
  final String email;

  const CilentInfoDialog({
    Key key,
    this.email,
  }) : super(key: key);

  @override
  _CilentInfoDialogState createState() => _CilentInfoDialogState();
}

class _CilentInfoDialogState extends State<CilentInfoDialog> {
  OrderBloc _orderBloc;

  @override
  void didChangeDependencies() {
    _orderBloc = Provider.of<OrderBloc>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        margin: EdgeInsets.all(10),
        child: StreamBuilder<FastClient>(
          stream: _orderBloc.getCilentInfo(
            widget.email,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text("Error: ${snapshot.error}");
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return Text("Awaiting Bids...");
                break;
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
                break;
              case ConnectionState.active:
                return Text(
                  snapshot.data.toString(),
                );
                break;
              case ConnectionState.done:
                return Text("The task has complted.");
                break;
            }
            return Text("Snapshot");
          },
        ),
      ),
    );
  }
}
