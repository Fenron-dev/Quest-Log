import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/customers/customer_detail_screen.dart';
import '../../features/customers/customer_edit_screen.dart';
import '../../features/customers/customers_screen.dart';
import '../../features/my_day/my_day_screen.dart';
import '../../features/now/now_screen.dart';
import '../../features/projects/project_detail_screen.dart';
import '../../features/projects/project_edit_screen.dart';
import '../../features/projects/projects_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/tasks/task_detail_screen.dart';
import '../../features/tasks/task_edit_screen.dart';
import '../../features/templates/template_edit_screen.dart';
import '../../features/templates/templates_screen.dart';
import 'app_shell.dart';

abstract final class AppRoutes {
  static const now = '/now';
  static const myDay = '/my-day';
  static const projects = '/projects';
  static const customers = '/customers';
  static const settings = '/settings';
}

final routerProvider = Provider<GoRouter>((ref) => createRouter());

GoRouter createRouter({String initialLocation = AppRoutes.now}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => AppShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.now,
                builder: (context, state) => const NowScreen(),
                routes: [
                  GoRoute(
                    path: 'settings',
                    builder: (context, state) => const SettingsScreen(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.myDay,
                builder: (context, state) => const MyDayScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.projects,
                builder: (context, state) => const ProjectsScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    builder: (context, state) => ProjectEditScreen(
                      customerId: state.uri.queryParameters['customer'],
                    ),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => ProjectDetailScreen(
                      projectId: state.pathParameters['id']!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (context, state) => ProjectEditScreen(
                          projectId: state.pathParameters['id'],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.customers,
                builder: (context, state) => const CustomersScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    builder: (context, state) => const CustomerEditScreen(),
                  ),
                  GoRoute(
                    path: ':id',
                    builder: (context, state) => CustomerDetailScreen(
                      customerId: state.pathParameters['id']!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'edit',
                        builder: (context, state) => CustomerEditScreen(
                          customerId: state.pathParameters['id'],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/tasks/:id',
        builder: (context, state) =>
            TaskDetailScreen(taskId: state.pathParameters['id']!),
        routes: [
          GoRoute(
            path: 'edit',
            builder: (context, state) =>
                TaskEditScreen(taskId: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: templatesRoute,
        builder: (context, state) => const TemplatesScreen(),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => const TemplateEditScreen(),
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) =>
                TemplateEditScreen(templateId: state.pathParameters['id']),
          ),
        ],
      ),
    ],
  );
}
