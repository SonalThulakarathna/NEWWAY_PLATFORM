import 'package:flutter/material.dart';
import 'package:newway/classes/authservice.dart';
import 'package:newway/pages/edit_profile_page.dart';
import 'package:newway/pages/funnel%20pages/profilefunnelpage_selector.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  final authservice = Authservicelog();
  final supabase = Supabase.instance.client;
  String name = 'Loading...'; // Initialize with default value
  late AnimationController _animationController;

  void logout() async {
    await authservice.signout();
    if (mounted) {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  // YouTube-style dark theme colors
  final Color backgroundColor = const Color(0xFF0F0F0F);
  final Color surfaceColor = const Color(0xFF1F1F1F);
  final Color cardColor = const Color(0xFF282828);
  final Color accentColor = const Color(0xFFFF0000); // YouTube red
  final Color textColor = Colors.white;
  final Color textSecondary = const Color(0xFFAAAAAA);
  final Color dividerColor = const Color(0xFF303030);

  @override
  void initState() {
    super.initState();
    _fetchUsername();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void editprofilepage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfilePage()),
    );
  }

  Future<bool> userHasAFunnel() async {
    final uid = authservice.getuserid();

    if (uid == null) {
      print("User ID is null. Cannot check funnel.");
      return false;
    }

    try {
      final response = await supabase
          .from('newwayfunnelinfo')
          .select('userid')
          .eq('userid', uid)
          .maybeSingle();

      return response != null;
    } catch (error) {
      print("Error checking funnel: $error");
      return false;
    }
  }

  Future<void> _fetchUsername() async {
    try {
      final uid = authservice.getuserid();
      if (uid == null) throw Exception("User ID is null");

      final response = await supabase
          .from('newwayusers')
          .select('full_name')
          .eq('auth_id', uid)
          .maybeSingle();

      if (mounted) {
        setState(() {
          name = response?['full_name'] ?? 'No Name';
        });
      }
    } catch (e) {
      print("Error fetching username: $e");
      if (mounted) {
        setState(() {
          name = 'Error loading name';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
        cardColor: cardColor,
        dividerColor: dividerColor,
        colorScheme: ColorScheme.dark(
          primary: accentColor,
          secondary: accentColor,
          surface: surfaceColor,
          background: backgroundColor,
        ),
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          title: Text(
            'Profile',
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new_rounded,
                color: textColor, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.settings_outlined, color: textColor, size: 22),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Settings"),
                    backgroundColor: cardColor,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 16),
                  ),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return FadeTransition(
                opacity: _animationController,
                child: child,
              );
            },
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // Profile Header with Glassmorphism Effect
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 30),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          surfaceColor.withOpacity(0.5),
                          backgroundColor.withOpacity(0.2),
                        ],
                      ),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Profile Image with Animation
                        Hero(
                          tag: 'profile_image',
                          child: _buildProfileImage(),
                        ),

                        const SizedBox(height: 20),

                        // User info with animation
                        _buildUserInfo(),

                        const SizedBox(height: 24),

                        // Stats row with smooth card design
                        _buildStatsCard(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Edit profile button
                  _buildEditProfileButton(),

                  const SizedBox(height: 16),

                  // Content section
                  _buildContentSection(),

                  // Account Section
                  _buildAccountSection(),

                  // Sign out button
                  _buildSignOutButton(),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Animated decorative circles
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 700),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withOpacity(0.1),
                ),
              ),
            );
          },
        ),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 900),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withOpacity(0.2),
                ),
              ),
            );
          },
        ),

        // Profile image with shimmer effect
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 1100),
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: accentColor,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: const Image(
                    image: AssetImage('lib/images/lettern.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        ),

        // Edit profile icon overlay with ripple effect
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: editprofilepage,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.edit_rounded,
                color: textColor,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        // User name with animated text
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 700),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 24,
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 6),

        // User handle with animated text
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 900),
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Text(
                '@username',
                style: TextStyle(
                  fontSize: 16,
                  color: textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItemAnimated(
            count: '0',
            label: 'Courses',
            textColor: textColor,
            secondaryColor: textSecondary,
            delay: 0,
          ),
          _VerticalDivider(color: dividerColor),
          _StatItemAnimated(
            count: '0',
            label: 'Followers',
            textColor: textColor,
            secondaryColor: textSecondary,
            delay: 200,
          ),
          _VerticalDivider(color: dividerColor),
          _StatItemAnimated(
            count: '0',
            label: 'Following',
            textColor: textColor,
            secondaryColor: textSecondary,
            delay: 400,
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfileButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: editprofilepage,
          style: ElevatedButton.styleFrom(
            foregroundColor: textColor,
            backgroundColor: cardColor,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: dividerColor),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.edit_outlined, size: 18),
              const SizedBox(width: 8),
              Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Card(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: dividerColor, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.video_library_rounded,
                    color: accentColor,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Your Content',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Funnel Info Button (Conditional)
              FutureBuilder(
                future: userHasAFunnel(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CircularProgressIndicator(
                          color: accentColor,
                          strokeWidth: 3,
                        ),
                      ),
                    );
                  } else if (snapshot.hasData && snapshot.data == true) {
                    return _buildContentCard(
                      icon: Icons.analytics_outlined,
                      title: 'Funnel Info',
                      subtitle: 'View and manage your funnel details',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ProfilefunnelpageSelector(),
                          ),
                        );
                      },
                    );
                  } else {
                    // No funnel case
                    return _buildContentCard(
                      icon: Icons.add_circle_outline,
                      title: 'Create Funnel',
                      subtitle: 'Start creating your first funnel',
                      onTap: () {
                        // Action for creating a funnel
                      },
                    );
                  }
                },
              ),

              // Create new content button
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 16),
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Create content action
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text("Create new content"),
                        backgroundColor: cardColor,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                      ),
                    );
                  },
                  icon: Icon(Icons.add_rounded, size: 18),
                  label: const Text('Create New Content'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: accentColor,
                    side: BorderSide(color: accentColor),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: dividerColor,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: accentColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: textSecondary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Card(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: dividerColor, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.manage_accounts_rounded,
                    color: accentColor,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Account',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Account options
              _buildAccountOption(
                icon: Icons.person_outline_rounded,
                title: 'Personal Information',
                subtitle: 'Update your personal details',
                iconColor: textColor,
                textColor: textColor,
                secondaryColor: textSecondary,
                backgroundColor: cardColor,
                dividerColor: dividerColor,
              ),

              _buildAccountOption(
                icon: Icons.notifications_none_rounded,
                title: 'Notifications',
                subtitle: 'Manage your notification preferences',
                iconColor: textColor,
                textColor: textColor,
                secondaryColor: textSecondary,
                backgroundColor: cardColor,
                dividerColor: dividerColor,
              ),

              _buildAccountOption(
                icon: Icons.security_rounded,
                title: 'Security',
                subtitle: 'Manage your account security',
                iconColor: textColor,
                textColor: textColor,
                secondaryColor: textSecondary,
                backgroundColor: cardColor,
                dividerColor: dividerColor,
              ),

              _buildAccountOption(
                icon: Icons.help_outline_rounded,
                title: 'Help & Support',
                subtitle: 'Get help or contact support',
                iconColor: textColor,
                textColor: textColor,
                secondaryColor: textSecondary,
                backgroundColor: cardColor,
                dividerColor: dividerColor,
                isLast: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color iconColor,
    required Color textColor,
    required Color secondaryColor,
    required Color backgroundColor,
    required Color dividerColor,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: isLast ? 0 : 8),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            child: InkWell(
              onTap: () {
                // Account option action
              },
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: iconColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        icon,
                        color: iconColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: secondaryColor,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (!isLast) SizedBox(height: 1),
      ],
    );
  }

  Widget _buildSignOutButton() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () {
            // Sign out action
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Sign out"),
                backgroundColor: cardColor,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              ),
            );
          },
          icon: Icon(Icons.logout_rounded, size: 18),
          label: const Text('Sign Out'),
          style: ElevatedButton.styleFrom(
            foregroundColor: textColor,
            backgroundColor: accentColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
            shadowColor: accentColor.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}

// Helper widgets with animations
class _StatItemAnimated extends StatefulWidget {
  final String count;
  final String label;
  final Color textColor;
  final Color secondaryColor;
  final int delay;

  const _StatItemAnimated({
    required this.count,
    required this.label,
    required this.textColor,
    required this.secondaryColor,
    required this.delay,
  });

  @override
  State<_StatItemAnimated> createState() => _StatItemAnimatedState();
}

class _StatItemAnimatedState extends State<_StatItemAnimated>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(_animation),
        child: Column(
          children: [
            Text(
              widget.count,
              style: TextStyle(
                color: widget.textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.label,
              style: TextStyle(
                color: widget.secondaryColor,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  final Color color;

  const _VerticalDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 1,
      color: color.withOpacity(0.6),
    );
  }
}
