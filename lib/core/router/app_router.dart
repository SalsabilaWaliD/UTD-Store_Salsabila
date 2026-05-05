import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/di/injection.dart';
import '../../presentation/cubits/product/product_cubit.dart';
import '../../presentation/cubits/bookmark/bookmark_cubit.dart';
import '../../presentation/cubits/crypto/crypto_cubit.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/bookmark/bookmark_screen.dart';
import '../../presentation/screens/crypto/crypto_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => ScaffoldWithNavBar(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => BlocProvider(
              create: (_) => sl<ProductCubit>()..fetchProducts(),
              child: const HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/bookmark',
            name: 'bookmark',
            builder: (context, state) => BlocProvider(
              create: (_) => sl<BookmarkCubit>()..watchBookmarks(),
              child: const BookmarkScreen(),
            ),
          ),
          GoRoute(
            path: '/crypto',
            name: 'crypto',
            builder: (context, state) => BlocProvider(
              create: (_) => sl<CryptoCubit>()..connectWebSocket(),
              child: const CryptoScreen(),
            ),
          ),
        ],
      ),
    ],
  );
}

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;
  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex(context),
        onDestinationSelected: (i) {
          switch (i) {
            case 0:
              context.goNamed('home');
              break;
            case 1:
              context.goNamed('bookmark');
              break;
            case 2:
              context.goNamed('crypto');
              break;
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.store), label: 'Store'),
          NavigationDestination(icon: Icon(Icons.bookmark), label: 'Bookmark'),
          NavigationDestination(icon: Icon(Icons.currency_bitcoin), label: 'Crypto'),
        ],
      ),
    );
  }

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/bookmark')) return 1;
    if (location.startsWith('/crypto')) return 2;
    return 0;
  }
}
