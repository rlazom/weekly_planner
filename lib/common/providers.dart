import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:weekly_planner/common/providers/user_provider.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider<UserProvider>(create: (context) => UserProvider()),
];