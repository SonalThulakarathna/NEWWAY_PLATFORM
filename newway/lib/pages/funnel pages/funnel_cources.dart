import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:newway/classes/card_data.dart';
import 'package:newway/components/funnel_coverpage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FunnelCources extends StatefulWidget {
  final Cardcontent card;
  const FunnelCources({super.key, required this.card});

  @override
  State<FunnelCources> createState() => _FunnelCourcesState();
}

class _FunnelCourcesState extends State<FunnelCources>
    with SingleTickerProviderStateMixin {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> videos = [];
  bool isLoading = true;
  bool isVideoPlaying = false;
  int? selectedVideoIndex;
  CustomVideoPlayerController? _videoPlayerController;
  late AnimationController _animationController;

  // YouTube-like dark theme colors
  final Color backgroundColor = const Color(0xFF181818); // Dark background
  final Color surfaceColor =
      const Color(0xFF121212); // Slightly lighter dark background
  final Color cardColor = const Color(0xFF333333); // Dark gray for cards
  final Color accentColor = const Color(0xFFFF0000); // YouTube red
  final Color secondaryAccent =
      const Color(0xFFFCFCFC); // Light gray text for secondary info
  final Color textColor = Colors.white; // White text
  final Color textSecondary =
      const Color(0x80FFFFFF); // Lighter text for secondary elements
  final Color dividerColor = const Color(0xFF444444); // Darker dividers

  @override
  void initState() {
    super.initState();
    fetchVideos();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> fetchVideos() async {
    try {
      final funnelInfoResponse = await supabase
          .from('newwayfunnelinfo')
          .select('userid')
          .eq('id', widget.card.id);

      print("Fetched funnel info: $funnelInfoResponse");

      if (funnelInfoResponse.isNotEmpty) {
        final userId = funnelInfoResponse[0]['userid'];

        final response = await supabase
            .from('funnelvideodetails')
            .select()
            .eq('funnelownerid', userId);

        print("Fetched videos response: $response");

        if (response.isNotEmpty) {
          setState(() {
            videos = List<Map<String, dynamic>>.from(response);
            isLoading = false;
          });
        } else {
          setState(() {
            videos = [];
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
        print("No matching funnel owner found.");
      }
    } catch (e) {
      print("Error fetching videos: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _initializeVideoPlayer(String videoUrl) async {
    _videoPlayerController?.dispose();

    final videoPlayerController = VideoPlayerController.network(videoUrl);

    try {
      await videoPlayerController.initialize();

      _videoPlayerController = CustomVideoPlayerController(
        context: context,
        videoPlayerController: videoPlayerController,
        customVideoPlayerSettings: CustomVideoPlayerSettings(
          controlBarAvailable: true,
          playButton: Icon(Icons.play_arrow, color: textColor),
          pauseButton: Icon(Icons.pause, color: textColor),
          settingsButton: Icon(Icons.settings, color: textColor),
          placeholderWidget: Center(
            child: CircularProgressIndicator(
              color: accentColor,
            ),
          ),
          controlBarDecoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(8),
          ),
          customAspectRatio: 16 / 9,
          showFullscreenButton: true,
          controlBarPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
      );

      _videoPlayerController?.videoPlayerController.play();

      setState(() {
        isVideoPlaying = true;
      });

      _animationController.forward();
    } catch (e) {
      print("Error initializing video player: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to load video"),
          backgroundColor: secondaryAccent,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      videoPlayerController.dispose();
    }
  }

  void _playVideo(int index) async {
    final videoUrl = videos[index]['videourl'];
    if (videoUrl != null && videoUrl.isNotEmpty) {
      setState(() {
        selectedVideoIndex = index;
        isLoading = true;
      });

      try {
        _initializeVideoPlayer(videoUrl);
      } finally {
        setState(() => isLoading = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Invalid video URL"),
          backgroundColor: secondaryAccent,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _closeVideoPlayer() {
    _animationController.reverse().then((_) {
      _videoPlayerController?.dispose();
      setState(() {
        isVideoPlaying = false;
        selectedVideoIndex = null;
        _videoPlayerController = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          // FunnelCoverpage when no video is playing
          if (!isVideoPlaying)
            FunnelCoverpage(
              card: widget.card,
            ),

          // Video player (when video is playing)
          if (isVideoPlaying && _videoPlayerController != null)
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Container(
                  height: 240,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Opacity(
                        opacity: _animationController.value,
                        child: CustomVideoPlayer(
                          customVideoPlayerController: _videoPlayerController!,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: _closeVideoPlayer,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: textColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

          // Course content section
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Course Content',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: accentColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: accentColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.play_circle_outline,
                                    color: accentColor,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${videos.length} Videos',
                                    style: TextStyle(
                                      color: accentColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Now playing indicator
                  if (isVideoPlaying && selectedVideoIndex != null)
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: accentColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: accentColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.play_arrow,
                              color: textColor,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Now Playing',
                                  style: TextStyle(
                                    color: accentColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _formatVideoTitle(videos[selectedVideoIndex!]
                                          ['videourl'] ??
                                      ""),
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.fullscreen,
                              color: textColor,
                              size: 20,
                            ),
                            onPressed: () {
                              // Trigger fullscreen mode
                            },
                          ),
                        ],
                      ),
                    ),

                  // Content
                  Expanded(
                    child: isLoading
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 150,
                                  child: Lottie.network(
                                    'https://lottie.host/d4649615-85f7-4ef1-81e3-c5015ed851d7/83V9j7MnW7.json',
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Loading courses...',
                                  style: TextStyle(
                                    color: textSecondary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : videos.isEmpty
                            ? _buildEmptyState()
                            : _buildVideoList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Empty state widget
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.videocam_off_outlined,
              size: 60,
              color: textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "No videos available yet",
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Check back later for new content",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textSecondary,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              fetchVideos();
            },
            icon: const Icon(Icons.refresh),
            label: const Text("Refresh"),
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: textColor,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Video list widget
  Widget _buildVideoList() {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        final bool isSelected = selectedVideoIndex == index;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: isSelected ? accentColor.withOpacity(0.1) : cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? accentColor : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _playVideo(index),
                splashColor: accentColor.withOpacity(0.1),
                highlightColor: accentColor.withOpacity(0.05),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Video thumbnail/play button
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 60,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? accentColor.withOpacity(0.3)
                                  : Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? accentColor
                                    : Colors.transparent,
                                width: 1,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                  'https://picsum.photos/seed/${index + 1}/200/300',
                                ),
                                fit: BoxFit.cover,
                                opacity: 0.7,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? accentColor
                                  : Colors.black.withOpacity(0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isSelected ? Icons.pause : Icons.play_arrow,
                              color: textColor,
                              size: 20,
                            ),
                          ),
                          if (isSelected)
                            Positioned(
                              top: 4,
                              left: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: secondaryAccent,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'PLAYING',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(width: 12),

                      // Video details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _formatVideoTitle(
                                  video['videourl'] ?? "No Video URL"),
                              style: TextStyle(
                                color: textColor,
                                fontSize: 15,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),

                            // Video description
                            Text(
                              video['videodes'] ?? 'No description available',
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 13,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatVideoTitle(String url) {
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;
    if (pathSegments.isNotEmpty) {
      final filename = pathSegments.last;
      final nameWithoutExt = filename.split('.').first;
      return nameWithoutExt
          .replaceAll('_', ' ')
          .replaceAll('-', ' ')
          .split(' ')
          .map((word) => word.isNotEmpty
              ? '${word[0].toUpperCase()}${word.substring(1)}'
              : '')
          .join(' ');
    }
    return "Video ${videos.indexOf(videos.firstWhere((v) => v['videourl'] == url, orElse: () => {})) + 1}";
  }
}
