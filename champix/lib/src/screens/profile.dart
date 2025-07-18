import 'dart:convert';
import 'package:champix/src/services/users_service.dart';
import 'package:flutter/material.dart';
import 'package:champix/src/auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final UsersService _usersService = UsersService();

  String username = '';
  String email = '';
  bool isLoadingUser = true;
  bool isLoadingHistory = true;

  List<String> historyItems = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadUserData();
    _loadUserHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _usersService.getCurrentUser();
      setState(() {
        username = userData['username'] ?? '';
        email = userData['email'] ?? '';
        isLoadingUser = false;
      });
    } catch (e) {
      setState(() {
        isLoadingUser = false;
      });
      // Optionnel: affiche un message d’erreur ou logger
    }
  }

  Future<void> _loadUserHistory() async {
    try {
      final response = await _usersService.getUserHistory();
      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        setState(() {
          historyItems = jsonList.map((item) {
            final createdAt = DateTime.parse(item['created_at']);
            final formattedDate = "${createdAt.day}/${createdAt.month}/${createdAt.year}";
            final result = item['result'] ?? 'Résultat inconnu';
            return 'Analyse du $formattedDate - $result';
          }).toList();
          isLoadingHistory = false;
        });
      } else {
        setState(() {
          isLoadingHistory = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoadingHistory = false;
      });
      // Optionnel: gérer l’erreur
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Infos'),
            Tab(text: 'Historique'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: TabBarView(
          controller: _tabController,
          children: [
            // Onglet Infos
            isLoadingUser
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nom d\'utilisateur:', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(username, style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 24),
                      Text('Email:', style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(email, style: Theme.of(context).textTheme.bodyLarge),
                      const Spacer(),
                      Center(
                        child: FilledButton(
                          onPressed: () {
                            ChampixAuth.of(context).signOut();
                          },
                          child: const Text('Déconnexion'),
                        ),
                      ),
                    ],
                  ),

            // Onglet Historique
            isLoadingHistory
                ? const Center(child: CircularProgressIndicator())
                : historyItems.isEmpty
                    ? const Center(child: Text('Aucun historique pour le moment.'))
                    : ListView.separated(
                        itemCount: historyItems.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.history),
                            title: Text(historyItems[index]),
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }
}
