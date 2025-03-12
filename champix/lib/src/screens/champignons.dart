/*
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChampignonsScreen extends StatefulWidget {
  final Widget child;
  final ValueChanged<int> onTap;
  final int selectedIndex;

  const ChampignonsScreen({
    required this.child,
    required this.onTap,
    required this.selectedIndex,
    super.key,
  });

  @override
  State<ChampignonsScreen> createState() => _ChampignonsScreenState();
}

class _ChampignonsScreenState extends State<ChampignonsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(_handleTabIndexChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndexChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController.index = widget.selectedIndex;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Champignons'),
        bottom: TabBar(
          controller: _tabController,
          tabs:  [
            Tab(text: 'Comestibles', icon: SvgPicture.asset("assets/images/champignon.svg", colorFilter: const ColorFilter.mode(
                Colors.green, BlendMode.srcIn),),),
            Tab(text: 'Vénéneux', icon: SvgPicture.asset("assets/images/champignon.svg", colorFilter: const ColorFilter.mode(
                Colors.red, BlendMode.srcIn),),),
            Tab(text: 'Tous', icon: SvgPicture.asset("assets/images/champignon.svg", colorFilter: const ColorFilter.mode(
                Colors.white  , BlendMode.srcIn),),),
          ],
        ),
      ),
      body: widget.child,
    );
  }

  void _handleTabIndexChanged() {
    widget.onTap(_tabController.index);
  }
}*/


import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../data/champignon.dart';
import '../widgets/champignon_list.dart';

class ChampignonsScreen extends StatefulWidget {
  final ValueChanged<int> onTap;
  final int selectedIndex;
  final List<Champignon> champignons;

  const ChampignonsScreen({
    required this.onTap,
    required this.selectedIndex,
    required this.champignons,
    super.key,
  });

  @override
  State<ChampignonsScreen> createState() => _ChampignonsScreenState();
}

class _ChampignonsScreenState extends State<ChampignonsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(_handleTabIndexChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndexChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController.index = widget.selectedIndex;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Champignons'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Comestibles',
              icon: SvgPicture.asset(
                "assets/images/champignon.svg",
                colorFilter: const ColorFilter.mode(Colors.green, BlendMode.srcIn),
              ),
            ),
            Tab(
              text: 'Vénéneux',
              icon: SvgPicture.asset(
                "assets/images/champignon.svg",
                colorFilter: const ColorFilter.mode(Colors.red, BlendMode.srcIn),
              ),
            ),
            Tab(
              text: 'Tous',
              icon: SvgPicture.asset(
                "assets/images/champignon.svg",
                colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
              ),
            ),
          ],
        ),
      ),
      body: ChampignonList(
        champignons: widget.champignons,
        onTap: (champignon) {
          GoRouter.of(context).go('/champignon/${champignon.id}');
        },
      ),
    );
  }

  void _handleTabIndexChanged() {
    widget.onTap(_tabController.index);
  }
}