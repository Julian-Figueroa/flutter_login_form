import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/login_bloc.dart';
export 'package:formvalidation/src/bloc/login_bloc.dart';
import 'package:formvalidation/src/bloc/products_bloc.dart';
export 'package:formvalidation/src/bloc/products_bloc.dart';

class Provider extends InheritedWidget {
  final loginBloc = LoginBloc();

  final _productsBloc = ProductsBloc();

  static Provider _instace;

  factory Provider({Key key, Widget child}) {
    if (_instace == null) {
      _instace = new Provider._internal(key: key, child: child);
    }

    return _instace;
  }

  Provider._internal({Key key, Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(_) => true;

  static LoginBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider)
        .loginBloc;
  }

  static ProductsBloc productsBloc(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider)
        ._productsBloc;
  }
}
