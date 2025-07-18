import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:champix/src/services/users_service.dart';
import 'package:champix/src/auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UsersService _usersService = UsersService();

  String username = 'john_doe';
  String email = 'john.doe@email.com';
  String firstName = 'John';
  String lastName = 'Doe';
  String avatarUrl = 'https://i.pravatar.cc/300?img=10';
  String bio = 'Mycologue amateur passionné de nature, photographie et champignons rares.';
  List<dynamic> history = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadUserHistory();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await _usersService.getCurrentUser();
      setState(() {
        username = userData['username'] ?? username;
        email = userData['email'] ?? email;
        firstName = userData['first_name'] ?? firstName;
        lastName = userData['last_name'] ?? lastName;
        avatarUrl = userData['avatar_url'] ?? avatarUrl;
        bio = userData['bio'] ?? bio;
      });
    } catch (_) {}
  }

  Future<void> _loadUserHistory() async {
    try {
      final response = await _usersService.getUserHistory();
      if (response.statusCode == 200) {
        setState(() {
          history = jsonDecode(response.body);
        });
      }
    } catch (_) {}
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mon Profil")),
      body: Stack(
        children: [
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 16,),
                  _buildButtons(),
                  const SizedBox(height: 16),
                  _buildHistoryList(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: FilledButton.icon(
              onPressed: () => ChampixAuth.of(context).signOut(),
              icon: const Icon(Icons.logout),
              label: const Text("Déconnexion"),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.redAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 32, bottom: 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3D9970), Color(0xFF2ECC71)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 44,
              backgroundImage: NetworkImage(avatarUrl),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            username,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(email, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              bio,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          OutlinedButton.icon(
            icon: const Icon(Icons.edit),
            label: const Text("Modifier"),
            onPressed: () {},
          ),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            icon: const Icon(Icons.settings),
            label: const Text("Paramètres"),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.only(top: 32),
        child: CircularProgressIndicator(),
      );
    }

    if (history.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 32),
        child: Text('Aucune analyse enregistrée.'),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: history.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final item = history[index];
        final createdAt = DateTime.tryParse(item['created_at'] ?? '') ?? DateTime.now();
        final date = '${createdAt.day}/${createdAt.month}/${createdAt.year}';
        final result = item['result'] ?? 'Résultat inconnu';
        final imageUrl = item['image_url'] ?? '';

        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl.isNotEmpty
                  ? Image.network(imageUrl, width: 56, height: 56, fit: BoxFit.cover)
                  : const Icon(Icons.image, size: 48),
            ),
            title: Text('Analyse du $date'),
            subtitle: Text(result),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: show analysis detail
            },
          ),
        );
      },
    );
  }
}
