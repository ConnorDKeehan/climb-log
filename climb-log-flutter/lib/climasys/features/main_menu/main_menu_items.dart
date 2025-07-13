import 'package:climasys/climasys/features/personal_stats_page/main_data_view.dart';
import 'package:climasys/climasys/features/select_gym/select_gym.dart';
import 'package:climasys/climasys/models/menu_item.dart';
import 'package:climasys/utils/clear_access_token.dart';
import 'package:flutter/material.dart';
import '../account_view/account_view.dart';
import '../competitions_screen/competitions_screen.dart';
import '../gym_about/gym_about.dart';
import '../gym_admin/gym_admin.dart';
import '../login/login_page.dart';

List<MenuItem> mainMenuItems = [
  MenuItem(
      icon: const Icon(Icons.switch_access_shortcut),
      text: 'Switch Gyms',
      destination: const SelectGym(),
      allowAnonymous: true),
  MenuItem(
    icon: const Icon(Icons.percent),
    text: 'Statistics',
    destination: const MainDataView(),
  ),
  MenuItem(
      icon: const Icon(Icons.info_outline),
      text: 'Gym Details',
      destination: const GymAbout(),
      allowAnonymous: true),
  MenuItem(
      icon: const Icon(Icons.emoji_events_outlined),
      text: 'Competitions',
      destination: const CompetitionsScreen()),
  MenuItem(
      icon: const Icon(Icons.admin_panel_settings_outlined),
      text: 'Gym Admin',
      destination: const GymAdmin(),
      adminOnly: true),
  MenuItem(
      icon: const Icon(Icons.person),
      text: 'Account',
      destination: const AccountView()),
  MenuItem(
      icon: const Icon(Icons.logout),
      text: 'Logout',
      destination: const LoginPage(),
      preRedirectFunction: clearAccessToken,
      allowAnonymous: true),
];
