import 'package:fastdeliveryapp/src/models/fast_client.dart';
import 'package:fastdeliveryapp/src/models/online_order.dart';
import 'package:fastdeliveryapp/src/models/order_ref.dart';
import 'package:fastdeliveryapp/src/resources/repository.dart';
import 'package:rxdart/rxdart.dart';

class OrderBloc {
  final _repo = Repository();

  final BehaviorSubject<List<OrderRef>> _freeOrderRefrencesSubject =
      BehaviorSubject<List<OrderRef>>();
  Stream<List<OrderRef>> get _freeOrderRefrences =>
      _freeOrderRefrencesSubject.stream;
  Function(List<OrderRef>) get _changeFreeOrdersRefrences =>
      _freeOrderRefrencesSubject.sink.add;

  final BehaviorSubject<List<OrderRef>> _deliveryRefrenceSubject =
      BehaviorSubject<List<OrderRef>>();
  Stream<List<OrderRef>> get _deliveryRefrence =>
      _deliveryRefrenceSubject.stream;
  Function(List<OrderRef>) get _changeDeliveryRefrence =>
      _deliveryRefrenceSubject.sink.add;

  final BehaviorSubject<List<OrderRef>> _paidOrdersSubject =
      BehaviorSubject<List<OrderRef>>();
  Stream<List<OrderRef>> get paidOrders => _paidOrdersSubject.stream;
  Function(List<OrderRef>) get changePaidOrders => _paidOrdersSubject.sink.add;

  final BehaviorSubject<List<OnlineOrder>> _currentOrdersSubject =
      BehaviorSubject<List<OnlineOrder>>();
  Stream<List<OnlineOrder>> get currentOrders => _currentOrdersSubject.stream;
  Function(List<OnlineOrder>) get changeCurrentOrders =>
      _currentOrdersSubject.sink.add;

  getOrderRefrences(String email) {
    if (email == "") {
      _getFreeRefrences();
    } else {
      _getDeliveryRefrence(email);
    }
  }

  Stream<List<OrderRef>> orderRefrences(email) =>
      email == "" ? _freeOrderRefrences : _deliveryRefrence;

  _getFreeRefrences() {
    _repo.getOrders("").listen((refrences) {
      _changeFreeOrdersRefrences(refrences);
    });
  }

  _getDeliveryRefrence(String email) {
    _repo.getOrders(email).listen((refrences) {
      _changeDeliveryRefrence(refrences);
    });
  }

  getPaidOrders(String email) {
    return _repo.getPaidOrders(email);
  }
























































  

  getOrders(String refID) {
    _repo.getOrdersfromRefrences(refID).listen(
      (orders) {
        changeCurrentOrders(orders);
      },
    );
  }

  Stream<FastClient> getCilentInfo(String email) =>
      _repo.getCurrentClientInfo(email);

  Future<void> takeOrder(String refID, Map<String, dynamic> user) =>
      _repo.takeOrder(refID, user);

  Future<void> deliverOrder(String refID) => _repo.deliverOrder(refID);
  Future<void> takePayment(String refID) => _repo.takePayment(refID);

  dispose() {
    _freeOrderRefrencesSubject.close();
    _deliveryRefrenceSubject.close();
  }
}
