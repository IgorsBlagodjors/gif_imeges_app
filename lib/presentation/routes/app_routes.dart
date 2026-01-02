import 'package:gif_imeges_app/presentation/pages/fav_page.dart';
import 'package:gif_imeges_app/presentation/pages/home_page.dart';
import 'package:gif_imeges_app/presentation/routes/app_route_names.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: AppRouteNames.home,
      builder: (context, state) {
        return HomePage.withCubit();
      },
    ),
    GoRoute(
      path: '/favorites',
      name: AppRouteNames.favorites,
      builder: (context, state) {
        return FavPage.withCubit();
      },
    ),
  ],
);
