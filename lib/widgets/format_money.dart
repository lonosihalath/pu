
import 'package:intl/intl.dart';

nFormat(var val) {
  String _number = NumberFormat("###,###,###.##").format(val);
  return _number;
}
