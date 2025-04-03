import 'package:flutter/material.dart';
import 'package:newway/classes/card_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FunnelMembers extends StatefulWidget {
  final Cardcontent card;
  const FunnelMembers({super.key, required this.card});

  @override
  State<FunnelMembers> createState() => _FunnelMembersState();
}

class _FunnelMembersState extends State<FunnelMembers> {
  final supabase = Supabase.instance.client;
  late Future<List<Map<String, dynamic>>> _membersFuture;
  List<String> _userIds = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    _membersFuture = _fetchMembers();
  }

  Future<List<Map<String, dynamic>>> _fetchMembers() async {
    try {
      // Fetch all user IDs in this funnel
      final funnelMembers = await supabase
          .from('funnelmembers')
          .select('userid')
          .eq('funnelid', widget.card.id);

      _userIds = funnelMembers.map((e) => e['userid'].toString()).toList();

      if (_userIds.isEmpty) return [];

      // Fetch all user details in one batch using inFilter()
      final userResponse = await supabase
          .from('newwayusers')
          .select('auth_id, full_name')
          .inFilter('auth_id', _userIds);

      // Create a map for quick lookup
      final userMap = <String, String>{};
      for (final user in userResponse) {
        final authId = user['auth_id'].toString();
        final fullName = user['full_name']?.toString() ?? 'No Name';
        userMap[authId] = fullName;
      }

      // Combine the data
      return _userIds
          .map((userId) =>
              {'userid': userId, 'name': userMap[userId] ?? 'No Name'})
          .toList();
    } catch (e) {
      debugPrint('Error fetching members: $e');
      rethrow;
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _membersFuture = _fetchMembers();
    });
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  Color _getAvatarColor(String userId) {
    // Generate a consistent color based on the userId
    final colors = [
      Colors.purple,
      Colors.indigo,
      Colors.blue,
      Colors.teal,
      Colors.green,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
    ];

    int hash = 0;
    for (var i = 0; i < userId.length; i++) {
      hash = userId.codeUnitAt(i) + ((hash << 5) - hash);
    }

    return colors[hash.abs() % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Color(0xFF1E1E2E),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          elevation: 0,
          centerTitle: true,
        ),
        cardTheme: const CardTheme(
          color: Color(0xFF2D2D44),
          elevation: 4,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
      ),
      child: Scaffold(
        body: FutureBuilder<List<Map<String, dynamic>>>(
          future: _membersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.purpleAccent),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Loading members...',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.redAccent,
                          size: 48,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Failed to load members',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please check your connection and try again',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: _refreshData,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purpleAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            final members = snapshot.data ?? [];

            if (members.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.group_off,
                      size: 64,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'No members found',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This funnel has no members yet',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _refreshData,
              color: Colors.purpleAccent,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 12),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  final name = member['name'];
                  final userId = member['userid'];

                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: _getAvatarColor(userId),
                        radius: 24,
                        child: Text(
                          _getInitials(name),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      title: Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'ID: ${userId.substring(0, 8)}...',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                        ),
                      ),
                      trailing: const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
