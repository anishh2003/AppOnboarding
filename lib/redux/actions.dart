/* User Actions */

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:redux/redux.dart';
import 'package:wrangle/models/app_state.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wrangle/models/order.dart';
import 'package:wrangle/models/product.dart';
import 'package:wrangle/models/user.dart';


ThunkAction<AppState> getUserAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  final String storedUser = prefs.getString('user');
  final user = storedUser != null ? User.fromJson(json.decode(storedUser)) : null;
  store.dispatch(GetUserAction(user));
  
};

ThunkAction<AppState> logoutUserAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('user');
  User user;
  store.dispatch(LogoutUserAction(user));
};

class GetUserAction {
  final User _user;

  User get user => this._user;

  GetUserAction(this._user);
}


class LogoutUserAction {
  final User _user;

  User get user => this._user;

  LogoutUserAction(this._user);
}

/* Products Actions */
ThunkAction<AppState> getProductsAction = (Store<AppState> store) async {
  http.Response response = await http.get('http://3.10.233.244:1337/products');
  final List<dynamic> responseData = json.decode(response.body);
  List<Product> products = [];
  responseData.forEach((productData) {
    final Product product = Product.fromJson(productData);
    products.add(product);
  });
  store.dispatch(GetProductsAction(products));
};

class GetProductsAction {
  final List<Product> _products;

  List<Product> get products => this._products;

  GetProductsAction(this._products);
}

/* Cart products Actions */
ThunkAction<AppState> toggleCartProductAction(Product cartProduct) {
  return(Store<AppState> store) async {
    final List<Product> cartProducts =  store.state.cartProducts;
    final User user = store.state.user;
    final int index = cartProducts.indexWhere((product) => product.id == cartProduct.id);
    bool isInCart = index > -1 == true;
    List<Product> updatedCartProducts = List.from(cartProducts);
    if (isInCart) {
      updatedCartProducts.removeAt(index);
    } else {
      updatedCartProducts.add(cartProduct);
    }
    final List<String> cartProductsIds = updatedCartProducts.map((product) => product.id).toList();
    await http.put('http://3.10.233.244:1337/carts/${user.cartId}', body: {
      "products": json.encode(cartProductsIds)
    }, headers: {
      "Authorization": "Bearer ${user.jwt}"
    });
    store.dispatch(ToggleCartProductAction(updatedCartProducts));
  };
}

ThunkAction<AppState> getCartProductsAction = (Store<AppState> store) async {
  final prefs = await SharedPreferences.getInstance();
  final String storedUser = prefs.getString('user');
  if (storedUser == null) {
    return;
  }
  final User user = User.fromJson(json.decode(storedUser));
  http.Response response = await http.get('http://3.10.233.244:1337/carts/${user.cartId}', headers: {
    'Authorization': 'Bearer ${user.jwt}'
  });

  final responseData = json.decode(response.body)['products'];
    List<Product> cartProducts = [];
  responseData.forEach((productData) {
    final Product product = Product.fromJson(productData);
    cartProducts.add(product);
  });
  store.dispatch(GetCartProductsAction(cartProducts));
};

ThunkAction<AppState> clearCartProductsAction = (Store<AppState> store) async {
  final User user = store.state.user;
  await http.put('http://3.10.233.244:1337/carts/${user.cartId}', body: {
    "products": json.encode([])

  }, headers: {
    'Authorization': "Bearer ${user.jwt}"
  });
  store.dispatch(ClearCartProductsAction(List(0)));
};

class ToggleCartProductAction {
  final List<Product> _cartProducts;

  List<Product> get cartProducts => this._cartProducts;

  ToggleCartProductAction(this._cartProducts);
}

class GetCartProductsAction {
  final List<Product> _cartProducts;

  List<Product> get cartProducts => this._cartProducts;

  GetCartProductsAction(this._cartProducts);
}

class ClearCartProductsAction {
  final List<Product> _cartProducts;

  List<Product> get cartProducts => this._cartProducts;

  ClearCartProductsAction(this._cartProducts);
}

/* Cards Actions */
ThunkAction<AppState> getCardsAction = (Store<AppState> store) async {
  final String customerId = store.state.user.customerId; 
  http.Response response =

     await http.get('http://3.10.233.244:1337/card?$customerId'); 
  final responseData = json.decode(response.body);
  //print('card Data: $responseData');

  store.dispatch(GetCardsAction(responseData));
};

class GetCardsAction {
  final List<dynamic> _cards;

  List<dynamic> get cards => this._cards;

  GetCardsAction(this._cards);
}

class AddCardAction {
  final dynamic _card;

  dynamic get card => this._card;

  AddCardAction(this._card);
}

/* Card Token Actions */

ThunkAction<AppState> getCardTokenAction = (Store<AppState> store) async {
  final String jwt = store.state.user.jwt;
  http.Response response = await http.get('http://3.10.233.244:1337/users/me', headers: {
   
  'Authorization' : 'Bearer $jwt'

  });

  final responseData = json.decode(response.body);
  List<Order> orders = [];
  responseData['orders'].forEach((orderData) {
    final Order order = Order.fromJson(orderData);
    orders.add(order);
  });
  final String cardToken = responseData['card_token'];
  store.dispatch(GetCardTokenAction(cardToken));
  store.dispatch(GetOrdersAction(orders));
};

class GetOrdersAction {
  final List<Order> _orders;

  List<Order> get orders => this._orders;

  GetOrdersAction(this._orders);
}

class UpdateCardTokenAction {
  final String _cardToken;

  String get cardToken => this._cardToken;

  UpdateCardTokenAction(this._cardToken);
}

class GetCardTokenAction {
  final String _cardToken;

  String get cardToken => this._cardToken;

  GetCardTokenAction(this._cardToken);
}


/* orders actions */

class AddOrderAction {
  final Order _order;

  Order get order => this._order;

  AddOrderAction(this._order);
}