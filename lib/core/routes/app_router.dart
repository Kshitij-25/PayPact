import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../data/model/friend_model.dart';
import '../../data/model/group_model.dart';
import '../../presentation/screens/activity/activity_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/expenses/add_expense_screen.dart';
import '../../presentation/screens/friends/participant_details_screen.dart';
import '../../presentation/screens/group/create_group_screen.dart';
import '../../presentation/screens/group/group_details_screen.dart';
import '../../presentation/screens/group/group_settings_screen.dart';
import '../../presentation/screens/group/groups_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/misc/no_internet_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/widgets/bottom_nav_bar.dart';
import '../constants/firebase_constants.dart';
import '../constants/routes_constants.dart';
import 'route_observer.dart';

class AppRouter {
  AppRouter._();

  static late final GoRouter _router;
  static GoRouter get router => _router;

  static final RouteObserverService _routeObserver = RouteObserverService();

  static Future<void> setupRoutes() async {
    final initialRoute = FirebaseConstants.currentUserId != null ? Routes.homeScreen : Routes.loginScreen;

    _router = GoRouter(
      debugLogDiagnostics: false,
      routes: _routes,
      initialLocation: initialRoute,
      observers: [_routeObserver],
      // redirect: (context, state) {
      //   final loggedIn = FirebaseConstants.currentUserId != null;
      //   final loggingIn = state.matchedLocation == Routes.loginScreen;

      //   if (!loggedIn && !loggingIn) return Routes.loginScreen;
      //   if (loggedIn && loggingIn) return Routes.homeScreen;
      //   return null;
      // },
    );
  }

  static final List<RouteBase> _routes = [
    GoRoute(
      name: Routes.noInternetScreen,
      path: Routes.noInternetScreen,
      pageBuilder: (context, state) => MaterialPage(key: state.pageKey, child: NoInternetScreen()),
    ),
    GoRoute(
      name: Routes.loginScreen,
      path: Routes.loginScreen,
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        int getCurrentIndex(BuildContext context) {
          final location = GoRouterState.of(context).uri.toString();

          return switch (location) {
            Routes.homeScreen => 0,
            Routes.groupsScreen => 1,
            // Routes.addExpenseScreen => 2,
            Routes.activityScreen => 2,
            Routes.profileScreen => 3,
            _ => 0,
          };
        }

        void onItemTapped(int index, BuildContext context) {
          const routes = [
            Routes.homeScreen,
            Routes.groupsScreen,
            // Routes.addExpenseScreen,
            Routes.activityScreen,
            Routes.profileScreen,
          ];

          if (index >= 0 && index < routes.length) {
            final previousIndex = getCurrentIndex(context);
            final direction = index > previousIndex ? AxisDirection.left : AxisDirection.right;

            context.goNamed(routes[index], extra: direction);
          }
        }

        final currentIndex = getCurrentIndex(context);

        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: child,
          bottomNavigationBar: BottomNavBar(
            currentIndex: currentIndex,
            onSelectedIndex: (index) => onItemTapped(index, context),
          ),
        );
      },
      routes: [
        GoRoute(
          name: Routes.homeScreen,
          path: Routes.homeScreen,
          pageBuilder: (context, state) {
            return _buildPageWithTransition(
              state,
              const HomeScreen(),
              state.extra as AxisDirection? ?? AxisDirection.left,
            );
          },
          routes: [
            GoRoute(
              name: Routes.participantDetailsScreen,
              path: Routes.participantDetailsScreen,
              builder: (context, state) => ParticipantDetailsScreen(
                friendModel: state.extra as FriendModel,
              ),
            ),
          ],
        ),
        GoRoute(
          name: Routes.groupsScreen,
          path: Routes.groupsScreen,
          pageBuilder: (context, state) {
            return _buildPageWithTransition(
              state,
              const GroupsScreen(),
              state.extra as AxisDirection? ?? AxisDirection.left,
            );
          },
          routes: [
            GoRoute(
              name: Routes.groupDetailsScreen,
              path: Routes.groupDetailsScreen,
              builder: (context, state) => GroupDetailsScreen(
                group: state.extra as GroupModel,
              ),
              routes: [
                GoRoute(
                  name: Routes.groupSettingsScreen,
                  path: Routes.groupSettingsScreen,
                  builder: (context, state) => GroupSettingsScreen(
                    group: state.extra as GroupModel,
                  ),
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          name: Routes.addExpenseScreen,
          path: Routes.addExpenseScreen,
          pageBuilder: (context, state) {
            return _buildPageWithTransition(
              state,
              const AddExpenseScreen(),
              state.extra as AxisDirection? ?? AxisDirection.left,
            );
          },
        ),
        GoRoute(
          name: Routes.activityScreen,
          path: Routes.activityScreen,
          pageBuilder: (context, state) {
            return _buildPageWithTransition(
              state,
              const ActivityScreen(),
              state.extra as AxisDirection? ?? AxisDirection.left,
            );
          },
        ),
        GoRoute(
          name: Routes.profileScreen,
          path: Routes.profileScreen,
          pageBuilder: (context, state) {
            return _buildPageWithTransition(
              state,
              const ProfileScreen(),
              state.extra as AxisDirection? ?? AxisDirection.left,
            );
          },
        ),
      ],
    ),
    GoRoute(
      name: Routes.createGroupScreen,
      path: Routes.createGroupScreen,
      pageBuilder: (context, state) {
        // final extras = state.extra as Map<String, dynamic>?; // Allow for null extras
        // final isQuotingBrief = extras?['isQuotingBrief'] as bool? ?? false; // Default to false if null

        return CustomTransitionPage<void>(
          key: state.pageKey,
          name: state.name,
          child: CreateGroupScreen(),
          transitionDuration: const Duration(milliseconds: 200),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        );
      },
    ),
  ];
}

// Custom page transition function
CustomTransitionPage _buildPageWithTransition(
  GoRouterState state,
  Widget child,
  AxisDirection direction,
) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    name: state.name,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const beginOffsetLeft = Offset(1.0, 0.0);
      const beginOffsetRight = Offset(-1.0, 0.0);
      const endOffset = Offset.zero;

      final tween = Tween<Offset>(
        begin: direction == AxisDirection.left ? beginOffsetLeft : beginOffsetRight,
        end: endOffset,
      ).chain(CurveTween(curve: Curves.easeInOut));

      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}
