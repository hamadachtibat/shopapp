import 'package:flutter/foundation.dart';

class ItemQuantity with ChangeNotifier {

  int _numberofItem = 0;

  int get numberofItem => _numberofItem;

  display(int no)
  {
    _numberofItem=no;
    notifyListeners();
  }

}
