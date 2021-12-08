import "package:bloc/bloc.dart";

import 'package:terminal_frontend/application/shopping/shopping_state.dart';
import 'package:terminal_frontend/domain/shopping/shopping_service_interface.dart';

class ShoppingCubit extends Cubit<ShoppingState> {
  final ShoppingServiceInterface shoppingSerivce;

  ShoppingCubit({required this.shoppingSerivce}) : super(ShoppingState());
}