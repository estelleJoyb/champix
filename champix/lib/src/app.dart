import 'package:champix/src/auth.dart';
import 'package:champix/src/data.dart';
import 'package:champix/src/screens/champignon_details.dart';
import 'package:champix/src/screens/settings.dart';
import 'package:champix/src/screens/sign_in.dart';
import 'package:champix/src/widgets/fade_transition_page.dart';
import 'package:champix/src/screens/champignons.dart';
import 'package:champix/src/screens/sign_up.dart';
import 'package:champix/src/screens/scaffold.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
                  var p when p.startsWith('/settings') => 1,
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
                      champignons: switch (_tabControllerIndex) {
                        0 => libraryInstance.edibleChampignons,
                        1 => libraryInstance.nonEdibleChampignons,
                        2 => libraryInstance.allChampignons,
                        _ => libraryInstance.allChampignons,
                      },
                    ),
                  );
                },
              ),
              GoRoute(
                path: '/champignon/:champignonId',
                builder: (context, state) {
                  return ChampignonDetailsScreen(
                    champignon: libraryInstance.getChampignon(
                      state.pathParameters['champignonId'] ?? '',
                    ),
                  );
                },
              ),
              GoRoute(
                path: '/settings',
                pageBuilder: (context, state) {
                  return FadeTransitionPage<dynamic>(
                    key: state.pageKey,
                    child: const SettingsScreen(),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/sign-in',
            builder: (context, state) {
              return SignInScreen(
                onSignIn: (value) async {
                  final router = GoRouter.of(context);
                  await ChampixAuth.of(context).signIn(value.username, value.password);
                  router.go('/champignon');
                },
              );
            },
          ),
          GoRoute(
            path: '/sign-up',
            builder: (context, state) {
              return SignUpScreen(
                onSignUp: (value) async {
                  final router = GoRouter.of(context);
                  await ChampixAuth.of(context).signIn(value.username, value.password);
                  router.go('/champignon');
                },
              );
            },
          ),
        ],
      ),
    );
  }
}