import "package:bloc/bloc.dart";

import 'package:terminal_frontend/application/shopping/shopping_state.dart';
import 'package:terminal_frontend/domain/shopping/shopping_service_interface.dart';
import 'package:terminal_frontend/domain/user/user_service_interface.dart';

class ShoppingCubit extends Cubit<ShoppingState> {
  final ShoppingServiceInterface shoppingService;
  final UserServiceInterface userService;

  ShoppingCubit({required this.shoppingService, required this.userService}) : super(ShoppingState());
}