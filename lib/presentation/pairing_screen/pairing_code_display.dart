import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:terminal_frontend/application/pairing/pairing_cubit.dart';
import 'package:terminal_frontend/application/pairing/pairing_state.dart';
import 'package:terminal_frontend/presentation/pairing_screen/digit_container.dart';

class PairingCodeDisplay extends StatelessWidget {
  final PairingCubit pairingCubit;
  final int numberOfDigits;

  const PairingCodeDisplay({
    Key? key, 
    required this.numberOfDigits,
    required this.pairingCubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PairingCubit, PairingState>(
      bloc: pairingCubit,
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(numberOfDigits, (index) {
            return DigitContainer(
              digit: pairingCubit.getPairingCodeDigit(index),
            );
          })
        );
      }
    );
  }
}

