import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/templates/bindings/template_binding.dart';
import '../modules/templates/views/template_grid_view.dart';
import '../modules/editor/bindings/editor_binding.dart';
import '../modules/editor/views/editor_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.TEMPLATES,
      page: () => const TemplateGridView(),
      binding: TemplateBinding(),
    ),
    GetPage(
      name: _Paths.EDITOR,
      page: () => const EditorView(),
      binding: EditorBinding(),
    ),
  ];
}
