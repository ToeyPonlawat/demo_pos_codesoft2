import 'dart:async';

import 'package:alphadealdemo/src/models/cart.dart';
import 'package:alphadealdemo/src/models/client.dart';
import 'package:alphadealdemo/src/services/databases.dart';

class ClientsBloc {
  final _clientController = StreamController<List<Client>>.broadcast();

  get clients => _clientController.stream;

  dispose() {
    _clientController.close();
  }

  getClients() async {
    _clientController.sink.add(await DBProvider.db.getAllClients());
  }

  ClientsBloc() {
    getClients();
  }

//  blockUnblock(Client client) {
//    DBProvider.db.blockOrUnblock(client);
//    getClients();
//  }

  delete(int id) {
    DBProvider.db.deleteClient(id);
//    getClients();
  }

  deleteAll() {
    DBProvider.db.deleteAll();
//    getClients();
  }

  add(Client client) {
    DBProvider.db.newClient(client);
//    getClients();
  }
}

class CartBloc {
  final _cartController = StreamController<List<Cart>>.broadcast();

  get carts => _cartController.stream;

  dispose() {
    _cartController.close();
  }

  getCarts() async {
    _cartController.sink.add(await DBProvider.db.getAllCarts());
  }

  CartBloc() {
    getCarts();
  }

  deleteAll() {
    DBProvider.db.deleteAllCart();
//    getClients();
  }

  delete(String id) {
    DBProvider.db.deleteCart(id);
//    getClients();
  }

  add(Cart cart) {
    DBProvider.db.newCart(cart);
//    getClients();
  }

  edit(Cart cart) {
    DBProvider.db.editCart(cart);
//    getClients();
  }

  getCountNoti() {
    DBProvider.db.getCountNotiCart();
  }
}