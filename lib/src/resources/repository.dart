import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fastdeliveryapp/src/models/fast_client.dart';
import 'package:fastdeliveryapp/src/models/online_order.dart';
import 'package:fastdeliveryapp/src/models/order_ref.dart';
import 'package:fastdeliveryapp/src/models/user.dart';
import 'package:fastdeliveryapp/src/resources/firebase_auth_provider.dart';
import 'package:fastdeliveryapp/src/resources/firestore_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Repository {
  final _firebaseAuthProvider = FirebaseAuthProvider();
  final _firestoreProvider = FirestoreProvider();

  Stream<FirebaseUser> getCurrentUser() =>
      _firebaseAuthProvider.onAuthStateChanged;

  Future<AuthResult> loginIn(String email, String password) =>
      _firebaseAuthProvider.login(email, password);

  Future<void> logOut() => _firebaseAuthProvider.logOut();

  // Database operations
  Stream<User> getUser(String email) => _firestoreProvider
          .getUser(email)
          .transform(StreamTransformer.fromHandlers(
              handleData: (DocumentSnapshot snapshot, sink) {
        if (snapshot.exists) {
          sink.add(parseJsonToUser(snapshot.data));
        } else {
          sink.addError("No user found");
        }
      }));

  Stream<FastClient> getCurrentClientInfo(String email) => _firestoreProvider
          .getUser(email)
          .transform(StreamTransformer.fromHandlers(
              handleData: (DocumentSnapshot snapshot, sink) {
        if (snapshot.exists) {
          sink.add(
            parseJsonToFastClient(snapshot.data),
          );
        }
      }));

  Stream<String> getUserRole(String email) => _firestoreProvider
          .getUser(email)
          .transform(StreamTransformer.fromHandlers(
              handleData: (DocumentSnapshot snapshot, sink) {
        if (snapshot.exists) {
          sink.add(snapshot.data['role']);
        } else {
          sink.addError("No user found");
        }
      }));

  Stream<List<OrderRef>> getOrders(String email) =>
      _firestoreProvider.getOrders(email).transform(
        StreamTransformer.fromHandlers(
          handleData: (QuerySnapshot snapshot, sink) {
            List<OrderRef> orderRefrences = [];
            snapshot.documents.forEach((document) {
              if (document.exists) {
                orderRefrences.add(
                  parseJsonToOrderRef(document.data),
                );
              }
            });
            orderRefrences.sort(
              (order1, order2) => DateTime.parse(order1.createdAt).compareTo(
                DateTime.parse(order2.createdAt),
              ),
            );
            sink.add(
              orderRefrences.reversed.toList(),
            );
          },
        ),
      );

  Stream<List<OrderRef>> getPaidOrders(String email) =>
      _firestoreProvider.getPaidOrders(email).transform(
        StreamTransformer.fromHandlers(
          handleData: (QuerySnapshot snapshot, sink) {
            List<OrderRef> orderRefrences = [];
            snapshot.documents.forEach((document) {
              if (document.exists) {
                orderRefrences.add(
                  parseJsonToOrderRef(document.data),
                );
              }
            });
            orderRefrences.sort(
              (order1, order2) => DateTime.parse(order1.createdAt).compareTo(
                DateTime.parse(order2.createdAt),
              ),
            );
            sink.add(
              orderRefrences.reversed.toList(),
            );
          },
        ),
      );

  Stream<List<OnlineOrder>> getOrdersfromRefrences(String refID) =>
      _firestoreProvider.getOrdersfromRefrence(refID).transform(
        StreamTransformer.fromHandlers(
          handleData: (QuerySnapshot snapshot, sink) {
            List<OnlineOrder> orders = [];
            snapshot.documents.forEach(
              (document) {
                if (document.exists) {
                  orders.add(parseJsonToOnlineOrder(document.data));
                } else {
                  sink.addError("No Doc found");
                }
              },
            );
            sink.add(orders);
          },
        ),
      );

  Future<void> saveToken(String email, Map<String, dynamic> tokenData) =>
      _firestoreProvider.saveToken(email, tokenData);

  Future<void> takeOrder(String refID, Map<String, dynamic> user) =>
      _firestoreProvider.takeOrder(refID, user);

  Future<void> deliverOrder(String refID) =>
      _firestoreProvider.deliverOrder(refID);
  Future<void> takePayment(String refID) =>
      _firestoreProvider.takePayment(refID);
}
