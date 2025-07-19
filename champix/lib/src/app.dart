import 'package:champix/src/auth.dart';
import 'package:champix/src/data.dart';
import 'package:champix/src/screens/champignon_details.dart';
import 'package:champix/src/screens/champignon_detect.dart';
import 'package:champix/src/screens/profile.dart';
import 'package:champix/src/screens/sign_in.dart';
import 'package:champix/src/widgets/fade_transition_page.dart';
import 'package:champix/src/screens/champignons.dart';
import 'package:champix/src/screens/sign_up.dart';
import 'package:champix/src/screens/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:champix/src/constants/constants.dart';

final appShellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'app shell');

class ChampignonApp extends StatefulWidget {
  const ChampignonApp({super.key});

  @override
  State<ChampignonApp> createState() => _ChampignonAppState();
}

class _ChampignonAppState extends State<ChampignonApp> {
  final ChampixAuth auth = ChampixAuth();
  int _tabControllerIndex = 2;

  String? getRedirectPath(Uri stateUri, bool signedIn) {
    final currentPath = stateUri.toString();
    final excludedPaths = ['/sign-in', '/sign-up'];

    if (!excludedPaths.contains(currentPath) && !signedIn) {
      return '/sign-in';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Champix',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(
          secondary: Constants.paleGreen,
          brightness: Brightness.dark,
          primary: Constants.taupeGray,
          surface: Constants.brown,
          onPrimary: Constants.brown,
        ),
      ),
      builder: (context, child) {
        if (child == null) {
          throw ('No child in .router constructor builder');
        }
        return ChampixAuthScope(notifier: auth, child: child);
      },
      routerConfig: GoRouter(
        refreshListenable: auth,
        debugLogDiagnostics: true,
        initialLocation: '/champignon',
        redirect: (context, state) {
          final signedIn = ChampixAuth.of(context).signedIn;
          return getRedirectPath(state.uri, signedIn);
        },
        routes: [
          GoRoute(
            path: '/',
            redirect: (context, state) => '/champignon',
          ),
          ShellRoute(
            navigatorKey: appShellNavigatorKey,
            builder: (context, state, child) {
              return ChampignonstoreScaffold(
                selectedIndex: switch (state.uri.path) {
                  var p when p.startsWith('/champignon') => 0,
                  var p when p.startsWith('/detect') => 1,
                  var p when p.startsWith('/profile') => 2,
                  _ => 0,
                },
                child: child,
              );
            },
            routes: [
              GoRoute(
                path: '/champignon',
                pageBuilder: (context, state) {
                  return FadeTransitionPage<dynamic>(
                    key: state.pageKey,
                    child: ChampignonsScreen(
                      onTap: (idx) {
                        setState(() {
                          _tabControllerIndex = idx;
                        });
                      },
                      selectedIndex: _tabControllerIndex,
                    ),
                  );
                },
              ),
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) {
                  return FadeTransitionPage<dynamic>(
                    key: state.pageKey,
                    child: const ProfileScreen(),
                  );
                },
              ),
              GoRoute(
                path: '/detect',
                builder: (context, state) {
                  return const ChampignonDetectScreen();
                },
              ),
              GoRoute(
                path: '/champignon/:champignonId',
                builder: (context, state) {
                  final champignonId =
                      state.pathParameters['champignonId'] ?? '';
                  return ChampignonDetailsScreen(
                    champignonId: champignonId,
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/sign-in',
            builder: (context, state) {
              return const SignInScreen();
            },
          ),
          GoRoute(
            path: '/sign-up',
            builder: (context, state) {
              return const SignUpScreen();
            },
          ),
        ],
      ),
    );
  }
}
