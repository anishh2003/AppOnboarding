import 'package:meta/meta.dart';
import 'package:wrangle/models/product.dart';
import 'package:wrangle/models/user.dart';

import 'order.dart';

@immutable 
class AppState {
  final User user;
  final List<Product> products;
  final List<Product> cartProducts;
  final List<dynamic> cards;
  final List<Order> orders;
  final String cardToken;


  AppState({ @required this.user, @required this.products, @required this.cartProducts, @required this.orders, @required this.cards, @required this.cardToken});



  factory AppState.initial() {
    return AppState(user: null, orders: [], products: [], cartProducts: [], cards: [], cardToken: '');
     
  }

}