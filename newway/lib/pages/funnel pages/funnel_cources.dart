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

  @override
  void initState() {
    super.initState();
    fetchVideos();
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

  late CustomVideoPlayerController cvpc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: Column(
        children: [
          FunnelCoverpage(
            card: widget.card,
          ),
          Expanded(
            child: isLoading
                ? Center(
                    child: SizedBox(
                    height: 250,
                    child: Lottie.network(
                        'https://lottie.host/d4649615-85f7-4ef1-81e3-c5015ed851d7/83V9j7MnW7.json'),
                  ))
                : videos.isEmpty
                    ? const Center(child: Text("No videos found."))
                    : ListView.builder(
                        itemCount: videos.length,
                        itemBuilder: (context, index) {
                          final video = videos[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            color: Colors.white.withOpacity(0.1),
                            child: ListTile(
                              title: Text(video['videourl'] ?? "No Video URL",
                                  style: const TextStyle(color: Colors.white)),
                              subtitle: Text(
                                  " ${video['videodes'] ?? 'Unknown'}",
                                  style:
                                      const TextStyle(color: Colors.white70)),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
