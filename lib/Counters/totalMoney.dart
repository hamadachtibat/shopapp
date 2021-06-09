import 'package:flutter/cupertino.dart';

class TotalAmount extends ChangeNotifier
{
  double _doubleAmount = 0;

  double get doubleAmount => _doubleAmount;

  display(double no ) async
  {
    _doubleAmount = no;
    await Future.delayed(const Duration(milliseconds: 100),(){
      notifyListeners();
    });
  }
}