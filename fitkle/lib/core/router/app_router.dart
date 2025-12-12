import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:fitkle/features/auth/presentation/screens/login_screen.dart';
import 'package:fitkle/features/auth/presentation/screens/signup_screen.dart';
import 'package:fitkle/features/home/presentation/screens/home_screen.dart';
import 'package:fitkle/features/home/presentation/screens/news_detail_screen.dart';
import 'package:fitkle/features/event/presentation/screens/event_list_screen.dart';
import 'package:fitkle/features/event/presentation/screens/event_detail_screen.dart';
import 'package:fitkle/features/event/presentation/screens/create_event_screen.dart';
import 'package:fitkle/features/group/presentation/screens/group_list_screen.dart';
import 'package:fitkle/features/group/presentation/screens/group_detail_screen.dart';
import 'package:fitkle/features/group/presentation/screens/create_group_screen.dart';
import 'package:fitkle/features/chat/presentation/screens/message_list_screen.dart';
import 'package:fitkle/features/chat/presentation/screens/chat_screen.dart';
import 'package:fitkle/features/profile/presentation/screens/my_profile_screen.dart';
import 'package:fitkle/features/member/presentation/screens/member_profile_screen.dart';
import 'package:fitkle/features/profile/presentation/screens/settings_screen.dart';
import 'package:fitkle/features/profile/presentation/screens/my_events_list_screen.dart';
import 'package:fitkle/features/profile/presentation/screens/my_groups_list_screen.dart';
import 'package:fitkle/shared/layout/main_layout.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => '/login',
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const MainLayout(
          currentIndex: 0,
          child: HomeScreen(),
        ),
      ),
      GoRoute(
        path: '/news/:id',
        name: 'news-detail',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: NewsDetailScreen(newsId: id),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/events',
        name: 'events',
        builder: (context, state) => const MainLayout(
          currentIndex: 1,
          child: EventListScreen(),
        ),
      ),
      GoRoute(
        path: '/events/create',
        name: 'create-event',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const CreateEventScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/events/:id',
        name: 'event-detail',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: EventDetailScreen(eventId: id),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/groups',
        name: 'groups',
        builder: (context, state) => const MainLayout(
          currentIndex: 2,
          child: GroupListScreen(),
        ),
      ),
      GoRoute(
        path: '/groups/create',
        name: 'create-group',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const CreateGroupScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/groups/:id',
        name: 'group-detail',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id']!;
          return CustomTransitionPage(
            key: state.pageKey,
            child: GroupDetailScreen(groupId: id),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/messages',
        name: 'messages',
        builder: (context, state) => const MainLayout(
          currentIndex: 3,
          child: MessageListScreen(),
        ),
      ),
      GoRoute(
        path: '/chat/:userId',
        name: 'chat',
        pageBuilder: (context, state) {
          final userId = state.pathParameters['userId']!;
          final userName = state.uri.queryParameters['userName'] ?? 'User';
          return CustomTransitionPage(
            key: state.pageKey,
            child: ChatScreen(userId: userId, userName: userName),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const MainLayout(
          currentIndex: 4,
          child: MyProfileScreen(),
        ),
      ),
      GoRoute(
        path: '/user/:userId',
        name: 'user-profile',
        pageBuilder: (context, state) {
          final userId = state.pathParameters['userId']!;
          final userName = state.uri.queryParameters['userName'] ?? 'User';
          return CustomTransitionPage(
            key: state.pageKey,
            child: MemberProfileScreen(userId: userId, userName: userName),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const SettingsScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/my-events',
        name: 'my-events',
        pageBuilder: (context, state) {
          final filterParam = state.uri.queryParameters['filter'];
          EventFilter initialFilter = EventFilter.created;

          if (filterParam != null) {
            switch (filterParam) {
              case 'created':
                initialFilter = EventFilter.created;
                break;
              case 'upcoming':
                initialFilter = EventFilter.upcoming;
                break;
              case 'past':
                initialFilter = EventFilter.past;
                break;
              case 'saved':
                initialFilter = EventFilter.saved;
                break;
            }
          }

          return CustomTransitionPage(
            key: state.pageKey,
            child: MyEventsListScreen(initialFilter: initialFilter),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: '/my-groups',
        name: 'my-groups',
        pageBuilder: (context, state) {
          final filterParam = state.uri.queryParameters['filter'];
          GroupFilter initialFilter = GroupFilter.created;

          if (filterParam != null) {
            switch (filterParam) {
              case 'created':
                initialFilter = GroupFilter.created;
                break;
              case 'joined':
                initialFilter = GroupFilter.joined;
                break;
            }
          }

          return CustomTransitionPage(
            key: state.pageKey,
            child: MyGroupsListScreen(initialFilter: initialFilter),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;
              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);
              return SlideTransition(position: offsetAnimation, child: child);
            },
          );
        },
      ),
    ],
  );
}
