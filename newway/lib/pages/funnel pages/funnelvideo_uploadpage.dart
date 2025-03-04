import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newway/classes/authservice.dart';
import 'package:newway/components/button.dart';
import 'package:newway/components/colors.dart';
import 'package:newway/components/textfield.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FunnelvideoUploadpage extends StatefulWidget {
  const FunnelvideoUploadpage({super.key});

  @override
  State<FunnelvideoUploadpage> createState() => _FunnelvideoUploadpageState();
}

class _FunnelvideoUploadpageState extends State<FunnelvideoUploadpage> {
  final picker = ImagePicker();
  XFile? videoFile;
  final supabase = Supabase.instance.client;
  String? videoUrl;
  final funnelvideoabt = TextEditingController();
  Uint8List? fileBytes;
  String? fileName;
  final Authservicelog authservice = Authservicelog();

  Future<void> pickvideo() async {
    try {
      final pickedFile = await picker.pickVideo(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          videoFile = pickedFile;
        });

        final file = File(pickedFile.path);
        fileBytes = await file.readAsBytes();
        fileName = 'videos/${DateTime.now().millisecondsSinceEpoch}.mp4';
      }
    } catch (e) {
      print('Error picking video: $e');
    }
  }

  Future<void> uploadVideo() async {
    if (fileBytes == null || fileName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No video has been selected')),
      );
      return;
    }

    try {
      await supabase.storage
          .from('newwayfunnelvideos')
          .uploadBinary(fileName!, fileBytes!);

      String uploadedVideoUrl =
          supabase.storage.from('newwayfunnelvideos').getPublicUrl(fileName!);

      setState(() {
        videoUrl = uploadedVideoUrl;
      });

      final response = await supabase.from('funnelvideodetails').insert({
        'videodes': funnelvideoabt.text,
        'videourl': uploadedVideoUrl,
        'funnelownerid': authservice.getuserid()
      });

      if (response.isEmpty) throw Exception('Insert failed');

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Video uploaded successfully'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear fields
      setState(() {
        funnelvideoabt.clear();
        videoFile = null;
        fileBytes = null;
        fileName = null;
      });

      print('Video uploaded successfully: $videoUrl');
    } catch (e) {
      print('Error uploading video: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: Column(
        children: [
          const SizedBox(height: 30),
          Center(
            child: GestureDetector(
              onTap: pickvideo,
              child: Container(
                width: 350,
                height: 150,
                decoration: BoxDecoration(color: textfieldgrey),
                child: videoFile != null
                    ? Center(
                        child: Text('Video Selected: ${videoFile!.name}',
                            style: const TextStyle(color: Colors.white)))
                    : const Center(
                        child: Text(
                          'Tap to select a video',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(
            height: 28,
          ),
          Textfield(
              controller: funnelvideoabt,
              hinttext: 'What this video about',
              obscuretext: false),
          const SizedBox(
            height: 45,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Button(
              text: 'Upload',
              onTap: uploadVideo,
            ),
          ),
        ],
      ),
    );
  }
}
