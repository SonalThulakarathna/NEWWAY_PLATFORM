import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:newway/classes/card_data.dart';
import 'package:newway/components/colors.dart';
import 'package:newway/components/funnel_coverpage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FunnelCources extends StatefulWidget {
  final Cardcontent card;
  const FunnelCources({super.key, required this.card});

  @override
  State<FunnelCources> createState() => _FunnelCourcesState();
}

class _FunnelCourcesState extends State<FunnelCources> {
  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> videos = [];
  bool isLoading = true;
  bool isVideoPlaying = false;
  int? selectedVideoIndex;
  CustomVideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  Future<void> fetchVideos() async {
    try {
      // Fetch user id from newwayfunnelinfo where funnel id matches
      final funnelInfoResponse = await supabase
          .from('newwayfunnelinfo')
          .select('userid')
          .eq('id', widget.card.id);

      print("Fetched funnel info: $funnelInfoResponse");

      // Check if we got a valid response
      if (funnelInfoResponse.isNotEmpty) {
        final userId = funnelInfoResponse[0]['userid'];

        // Fetch videos where funnelownerid matches the fetched userId
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
        // Handle case if no matching funnel owner found
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
    // Dispose previous controller if exists
    _videoPlayerController?.dispose();

    // Create a new video player controller
    final videoPlayerController = VideoPlayerController.network(videoUrl);

    try {
      // Initialize the controller
      await videoPlayerController.initialize();

      _videoPlayerController = CustomVideoPlayerController(
        context: context,
        videoPlayerController: videoPlayerController,
        customVideoPlayerSettings: const CustomVideoPlayerSettings(
          controlBarAvailable: true,
          playButton: Icon(Icons.play_arrow, color: Colors.white),
          pauseButton: Icon(Icons.pause, color: Colors.white),
          settingsButton: Icon(Icons.settings, color: Colors.white),
          placeholderWidget: Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          ),
          controlBarDecoration: BoxDecoration(
            color: Colors.black45,
          ),
          customAspectRatio: 16 / 9,
          showFullscreenButton: true,
        ),
      );

      // Auto-play the video
      _videoPlayerController?.videoPlayerController.play();

      setState(() {
        isVideoPlaying = true;
      });
    } catch (e) {
      print("Error initializing video player: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to load video"),
          backgroundColor: Colors.red,
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
        isLoading = true; // Show loading indicator
      });

      try {
        _initializeVideoPlayer(videoUrl);
      } finally {
        setState(() => isLoading = false);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid video URL"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _closeVideoPlayer() {
    _videoPlayerController?.dispose();
    setState(() {
      isVideoPlaying = false;
      selectedVideoIndex = null;
      _videoPlayerController = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E1E2E),
      body: Column(
        children: [
          // Keep the original FunnelCoverpage
          if (!isVideoPlaying)
            FunnelCoverpage(
              card: widget.card,
            ),

          // Video player (when a video is selected)
          if (isVideoPlaying && _videoPlayerController != null)
            Container(
              height: 240,
              width: double.infinity,
              color: Colors.black,
              child: Stack(
                children: [
                  // Video player
                  CustomVideoPlayer(
                    customVideoPlayerController: _videoPlayerController!,
                  ),

                  // Close button
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
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Course content section
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF2D2D44),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.play_circle_outline,
                                color: Colors.white.withOpacity(0.9),
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${videos.length} Videos',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
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

                  // Now playing indicator (when a video is selected)
                  if (isVideoPlaying && selectedVideoIndex != null)
                    Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: buttoncolor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: buttoncolor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: buttoncolor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.play_arrow,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Now Playing',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _formatVideoTitle(videos[selectedVideoIndex!]
                                          ['videourl'] ??
                                      ""),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
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
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : videos.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.videocam_off_outlined,
                                      size: 70,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "No videos available yet",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Check back later for new content",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.6),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 20),
                                itemCount: videos.length,
                                itemBuilder: (context, index) {
                                  final video = videos[index];
                                  final bool isSelected =
                                      selectedVideoIndex == index;

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: isSelected
                                            ? [
                                                buttoncolor.withOpacity(0.3),
                                                buttoncolor.withOpacity(0.1),
                                              ]
                                            : [
                                                Colors.white.withOpacity(0.1),
                                                Colors.white.withOpacity(0.05),
                                              ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSelected
                                            ? buttoncolor.withOpacity(0.5)
                                            : Colors.white.withOpacity(0.1),
                                        width: 1,
                                      ),
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(16),
                                      clipBehavior: Clip.antiAlias,
                                      child: InkWell(
                                        onTap: () => _playVideo(index),
                                        splashColor:
                                            Colors.white.withOpacity(0.1),
                                        highlightColor:
                                            Colors.white.withOpacity(0.05),
                                        child: Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Row(
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
                                                          ? buttoncolor
                                                              .withOpacity(0.5)
                                                          : buttoncolor
                                                              .withOpacity(0.3),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                  Icon(
                                                    isSelected
                                                        ? Icons
                                                            .pause_circle_filled
                                                        : Icons
                                                            .play_circle_fill,
                                                    color: Colors.white,
                                                    size: 30,
                                                  ),
                                                  if (isSelected)
                                                    Positioned(
                                                      top: 4,
                                                      left: 4,
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                          horizontal: 6,
                                                          vertical: 2,
                                                        ),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.black
                                                              .withOpacity(0.6),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                        ),
                                                        child: const Text(
                                                          'PLAYING',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 8,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                              const SizedBox(width: 16),

                                              // Video details
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Video title
                                                    Text(
                                                      _formatVideoTitle(
                                                          video['videourl'] ??
                                                              "No Video URL"),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                        fontWeight: isSelected
                                                            ? FontWeight.bold
                                                            : FontWeight.w600,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    const SizedBox(height: 6),

                                                    // Video description
                                                    Text(
                                                      video['videodes'] ??
                                                          'No description available',
                                                      style: TextStyle(
                                                        color: Colors.white
                                                            .withOpacity(0.7),
                                                        fontSize: 14,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),

                                                    const SizedBox(height: 8),

                                                    // Video metadata
                                                    Row(
                                                      children: [
                                                        _buildMetadataItem(
                                                          icon:
                                                              Icons.access_time,
                                                          text:
                                                              '10:30', // Placeholder duration
                                                        ),
                                                        const SizedBox(
                                                            width: 16),
                                                        _buildMetadataItem(
                                                          icon: Icons
                                                              .remove_red_eye_outlined,
                                                          text:
                                                              '${(index + 1) * 12}', // Placeholder views
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // Download/options button
                                              IconButton(
                                                icon: Icon(
                                                  isSelected
                                                      ? Icons.more_vert
                                                      : Icons.more_horiz,
                                                  color: Colors.white,
                                                ),
                                                onPressed: () {
                                                  // Options menu can be implemented here
                                                  _showVideoOptions(
                                                      context, video);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Show video options bottom sheet
  void _showVideoOptions(BuildContext context, Map<String, dynamic> video) {
    showModalBottomSheet(
      context: context,
      backgroundColor: primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              _buildOptionItem(
                icon: Icons.download_outlined,
                text: 'Download Video',
                onTap: () {
                  Navigator.pop(context);
                  // Download functionality
                },
              ),
              _buildOptionItem(
                icon: Icons.share_outlined,
                text: 'Share Video',
                onTap: () {
                  Navigator.pop(context);
                  // Share functionality
                },
              ),
              _buildOptionItem(
                icon: Icons.bookmark_border_outlined,
                text: 'Save for Later',
                onTap: () {
                  Navigator.pop(context);
                  // Save functionality
                },
              ),
              _buildOptionItem(
                icon: Icons.report_outlined,
                text: 'Report Issue',
                onTap: () {
                  Navigator.pop(context);
                  // Report functionality
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method to build option items for bottom sheet
  Widget _buildOptionItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      onTap: onTap,
    );
  }

  // Helper method to format video URL as a title
  String _formatVideoTitle(String url) {
    // Extract filename from URL
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;
    if (pathSegments.isNotEmpty) {
      final filename = pathSegments.last;
      // Remove extension and replace underscores/hyphens with spaces
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

  // Helper method to build metadata items
  Widget _buildMetadataItem({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: Colors.white.withOpacity(0.5),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}
