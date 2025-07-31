import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:paypact/core/constants/routes_constants.dart';

import '../../data/models/group_model.dart';
import '../../presentation/screens/activity_screen.dart';
import '../../presentation/screens/add_expense_screen.dart';
import '../../presentation/screens/create_group_screen.dart';
import '../../presentation/screens/group_details_screen.dart';
import '../../presentation/screens/groups_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/login_screen.dart';
import '../../presentation/screens/no_internet_screen.dart';
import '../../presentation/screens/profile_screen.dart';
import '../../presentation/widgets/bottom_nav_bar.dart';
import '../constants/firebase_helper.dart';
import 'route_observer.dart';

class AppRouter {
  AppRouter._();

  // static Future<String?> checkUserRole() async {
  //   final String? userRole = await HiveHelper.getUserRole();

  //   final isLoggedIn = await HiveHelper.isLoggedIn();

  //   if (userRole != null && isLoggedIn == true) {
  //     if (userRole == 'USER') {
  //       return HomeNavigator.routeName;
  //     } else if (userRole == 'PSYCHOLOGIST') {
  //       return PsychologistHomeNav.routeName;
  //     }
  //   }
  //   return SplashScreen.routeName; // Default route
  // }

  static late GoRouter router;

  static final RouteObserverService _routeObserver = RouteObserverService();

  static Future<void> setupRoutes() async {
    // final initialRoute = await checkUserRole();
    final initialRoute = FirebaseHelper.currentUserId != null ? Routes.homeScreen : Routes.loginScreen;
    router = GoRouter(
      debugLogDiagnostics: false,
      routes: _routes,
      initialLocation: initialRoute,
      observers: [_routeObserver],
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
            Routes.addExpenseScreen => 2,
            Routes.activityScreen => 3,
            Routes.profileScreen => 4,
            _ => 0,
          };
        }

        void onItemTapped(int index, BuildContext context) {
          const routes = [
            Routes.homeScreen,
            Routes.groupsScreen,
            Routes.addExpenseScreen,
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
              builder: (context, state) => GroupDetailsScreen(group: state.extra as GroupModel),
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

    // GoRoute(name: OnboardingScreen.routeName, path: OnboardingScreen.routeName, builder: (context, state) => const OnboardingScreen(), routes: []),
    // GoRoute(
    //   name: LandingScreen.routeName,
    //   path: LandingScreen.routeName,
    //   builder: (context, state) => LandingScreen(),
    //   routes: [
    //     GoRoute(
    //       name: LoginScreen.routeName,
    //       path: LoginScreen.routeName,
    //       builder: (context, state) => const LoginScreen(),
    //       routes: [
    //         GoRoute(
    //           name: ForgotPasswordScreen.routeName,
    //           path: ForgotPasswordScreen.routeName,
    //           builder: (context, state) => const ForgotPasswordScreen(),
    //           routes: [],
    //         ),
    //       ],
    //     ),
    //     GoRoute(
    //       name: EmailVerificationScreen.routeName,
    //       path: EmailVerificationScreen.routeName,
    //       builder: (context, state) => const EmailVerificationScreen(),
    //       routes: [],
    //     ),
    //   ],
    // ),
    // GoRoute(
    //   name: UserProfileCreation.routeName,
    //   path: UserProfileCreation.routeName,
    //   builder: (context, state) => UserProfileCreation(userEmail: state.extra as String),
    //   routes: [],
    // ),
    // GoRoute(
    //   name: ProfessionalProfileCreation.routeName,
    //   path: ProfessionalProfileCreation.routeName,
    //   builder: (context, state) => ProfessionalProfileCreation(userEmail: state.extra as String),
    //   routes: [],
    // ),
    // GoRoute(
    //   name: QuestionnairePermissionScreen.routeName,
    //   path: QuestionnairePermissionScreen.routeName,
    //   builder: (context, state) => QuestionnairePermissionScreen(userEmail: state.extra as String?),
    //   routes: [
    //     GoRoute(
    //       name: InitialQuestionsScreen.routeName,
    //       path: InitialQuestionsScreen.routeName,
    //       builder: (context, state) => InitialQuestionsScreen(userEmail: state.extra as String?),
    //       routes: [],
    //     ),
    //   ],
    // ),
    // GoRoute(
    //   name: PsychologistHomeNav.routeName,
    //   path: PsychologistHomeNav.routeName,
    //   builder: (context, state) => PsychologistHomeNav(),
    //   routes: [
    //     // GoRoute(
    //     //   name: CommunityPostScreen.routeName,
    //     //   path: CommunityPostScreen.routeName,
    //     //   builder: (context, state) => CommunityPostScreen(),
    //     //   routes: [],
    //     // ),
    //     GoRoute(
    //       name: CommunityPostScreen.routeName,
    //       path: CommunityPostScreen.routeName,
    //       pageBuilder: (context, state) {
    //         // final extras = state.extra as Map<String, dynamic>?; // Allow for null extras
    //         // final isQuotingBrief = extras?['isQuotingBrief'] as bool? ?? false; // Default to false if null

    //         return CustomTransitionPage<void>(
    //           key: state.pageKey,
    //           child: CommunityPostScreen(),
    //           transitionDuration: const Duration(milliseconds: 200),
    //           transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //             const begin = Offset(0.0, 1.0);
    //             const end = Offset.zero;
    //             const curve = Curves.easeInOut;

    //             var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
    //             var offsetAnimation = animation.drive(tween);

    //             return SlideTransition(position: offsetAnimation, child: child);
    //           },
    //         );
    //       },
    //     ),
    //     GoRoute(
    //       name: PostScreen.routeName,
    //       path: PostScreen.routeName,
    //       builder: (context, state) => PostScreen(postId: state.extra as String),
    //       routes: [],
    //     ),
    //   ],
    // ),
    // GoRoute(
    //   name: HomeNavigator.routeName,
    //   path: HomeNavigator.routeName,
    //   builder: (context, state) => const HomeNavigator(),
    //   routes: [
    //     GoRoute(
    //       name: TherapistProfileScreen.routeName,
    //       path: TherapistProfileScreen.routeName,
    //       builder: (context, state) => TherapistProfileScreen(psychologistsData: state.extra as PsychologistModel),
    //       routes: [
    //         GoRoute(
    //           name: BookAppointmentScreen.routeName,
    //           path: BookAppointmentScreen.routeName,
    //           builder: (context, state) => BookAppointmentScreen(psychologistsData: state.extra as PsychologistModel),
    //           routes: [],
    //         ),
    //       ],
    //     ),
    //     GoRoute(
    //       name: ArticleScreen.routeName,
    //       path: ArticleScreen.routeName,
    //       builder: (context, state) => ArticleScreen(articleData: state.extra as Article),
    //       routes: [],
    //     ),
    //     GoRoute(
    //       name: JournalScreen.routeName,
    //       path: JournalScreen.routeName,
    //       builder: (context, state) => JournalScreen(),
    //       routes: [
    //         GoRoute(
    //           name: CreateJournalScreen.routeName,
    //           path: CreateJournalScreen.routeName,
    //           builder: (context, state) => CreateJournalScreen(existingNote: state.extra as JournalEntry?),
    //           routes: [],
    //         ),
    //       ],
    //     ),
    //     GoRoute(name: InboxScreen.routeName, path: InboxScreen.routeName, builder: (context, state) => InboxScreen(), routes: []),
    //     GoRoute(
    //       name: NotificationScreen.routeName,
    //       path: NotificationScreen.routeName,
    //       builder: (context, state) => NotificationScreen(),
    //       routes: [],
    //     ),
    //     GoRoute(name: SupportScreen.routeName, path: SupportScreen.routeName, builder: (context, state) => SupportScreen(), routes: []),
    //     GoRoute(name: MoodNavigator.routeName, path: MoodNavigator.routeName, builder: (context, state) => MoodNavigator(), routes: []),
    //   ],
    // ),
    // GoRoute(
    //   name: ChatScreen.routeName,
    //   path: ChatScreen.routeName,
    //   builder: (context, state) {
    //     final extras = state.extra! as Map<String, dynamic>;
    //     final psychologistId = extras['psychologistId'] ?? '';
    //     final psychologistName = extras['psychologistName'] ?? '';
    //     final psychologistAvatar = extras['psychologistAvatar'] ?? '';
    //     final userAvatar = extras['userAvatar'] ?? '';
    //     final chatRoomId = extras['chatRoomId'] ?? '';
    //     final userId = extras['userId'] ?? '';
    //     return ChatScreen(
    //       psychologistId: psychologistId,
    //       psychologistName: psychologistName,
    //       psychologistAvatar: psychologistAvatar,
    //       userId: userId,
    //       chatRoomId: chatRoomId,
    //       userAvatar: userAvatar,
    //     );
    //   },
    //   routes: [],
    // ),
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
