
import '../modules/home/component/task/view/task_details.dart';
import '../modules/home/component/task/view_model/task_details_view_model.dart';
import '../modules/home/view_model/home_view_model.dart';
import '../modules/home/views/home_page.dart';
import '../modules/main/main_module.dart';

export '../modules/home/views/home_page.dart';
export '../modules/home/component/task/view/task_details.dart';

final routes = {
  MainModule.route: (context) => const MainPage(),
  HomePage.route: (context) => HomePage(viewModel: HomeViewModel()),
  TaskDetailsPage.route: (context) => TaskDetailsPage(viewModel: TaskDetailsViewModel()),
};
