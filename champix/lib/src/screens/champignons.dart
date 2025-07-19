import 'package:champix/src/services/mushrooms_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../constants/constants.dart';
import '../data/champignon.dart';
import '../widgets/champignon_list.dart';

class ChampignonsScreen extends StatefulWidget {
  final ValueChanged<int> onTap;
  final int selectedIndex;

  const ChampignonsScreen({
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
  late MushroomService _mushroomService;

  List<Champignon> _champignons = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(_handleTabIndexChanged);

    _mushroomService = MushroomService();

    _fetchChampignons();
  }

  Future<void> _fetchChampignons() async {
    try {
      final data = await _mushroomService.getAllMushrooms();
      setState(() {
        _champignons = data.map((item) => Champignon.fromJson(item)).toList();
        _isLoading = false;
      });
    } catch (e) {
      print("Erreur récupération champignons : $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndexChanged);
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController.index = widget.selectedIndex;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Mushrooms',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF3E2723).withOpacity(0.2),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16.0),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              indicator: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF3E2723),
                    Color.fromARGB(255, 85, 70, 57),
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(14.0)),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              labelStyle: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ) ??
                  const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        "assets/images/champignon.svg",
                        colorFilter: ColorFilter.mode(
                          Constants.paleGreen,
                          BlendMode.srcIn,
                        ),
                        height: 20,
                      ),
                      SizedBox(width: 8),
                      Text('Edibles'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        "assets/images/champignon.svg",
                        colorFilter: ColorFilter.mode(
                          Constants.paleRed,
                          BlendMode.srcIn,
                        ),
                        height: 20,
                      ),
                      SizedBox(width: 8),
                      Text('Non-edibles'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        "assets/images/champignon.svg",
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                        height: 20,
                      ),
                      SizedBox(width: 8),
                      Text('All Mushrooms'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Container(
              key: ValueKey<int>(_tabController.index),
              height: 200,
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: _tabController.index == 0
                            ? Colors.green.shade700
                            : _tabController.index == 1
                                ? Colors.red.shade700
                                : Colors.grey.shade700,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              Colors.black.withOpacity(0.3),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            const Color(0xFF3E2723).withOpacity(0.5),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _tabController.index == 0
                              ? 'Edible Mushrooms'
                              : _tabController.index == 1
                                  ? 'Non-edible Mushrooms'
                                  : 'All Mushrooms',
                          style: theme.textTheme.titleLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ) ??
                              const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ChampignonList(
                champignons: _champignons
                    .where((c) => _tabController.index == 2 ||
                        (c.edible && _tabController.index == 0) ||
                        (!c.edible && _tabController.index == 1))
                    .toList(),
                onTap: (champignon) {
                  GoRouter.of(context).go('/champignon/${champignon.id}');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleTabIndexChanged() {
    widget.onTap(_tabController.index);
  }
}
