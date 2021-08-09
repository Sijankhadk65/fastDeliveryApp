import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProvider {
  final _provider = Firestore.instance;

  Stream<DocumentSnapshot> getUser(String email) =>
      _provider.document("users/$email").snapshots();

  // Orders
  Stream<QuerySnapshot> getOrders(String email) {
    if (email == "")
      return _provider
          .collection("liveOnlineOrders")
          .where("isAssignedTo.email", isEqualTo: "")
          .where("isPaid", isEqualTo: false)
          .snapshots();
    return _provider
        .collection("liveOnlineOrders")
        .where("isAssignedTo.email", isEqualTo: email)
        .where("isPaid", isEqualTo: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getPaidOrders(String email) => _provider
      .collection("liveOnlineOrders")
      .where("isAssignedTo.email", isEqualTo: email)
      .where("isPaid", isEqualTo: true)
      .snapshots();

  Future<void> saveToken(String email, Map<String, dynamic> tokenData) =>
      _provider
          .document("users/$email")
          .collection("tokens")
          .document(tokenData['token'])
          .setData(tokenData);

  Future<void> takeOrder(String refID, Map<String, dynamic> user) =>
      _provider.document("liveOnlineOrders/$refID").updateData(
        {
          "isAssignedTo": user,
        },
      );

  Future<void> deliverOrder(String refID) =>
      _provider.document("liveOnlineOrders/$refID").updateData(
        {
          "isDelivered": true,
        },
      );
  Future<void> takePayment(String refID) =>
      _provider.document("liveOnlineOrders/$refID").updateData(
        {
          "isPaid": true,
        },
      );
  Stream<QuerySnapshot> getOrdersfromRefrence(String refID) {
    return _provider
        .document("liveOnlineOrders/$refID")
        .collection("orders")
        .snapshots();
  }
}
