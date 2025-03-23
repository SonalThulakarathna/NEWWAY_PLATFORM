import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:newway/classes/authservice.dart';
import 'package:newway/components/button.dart';
import 'package:newway/components/colors.dart';
import 'package:newway/components/loading_page1.dart';
import 'package:newway/components/textfield.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreatefunnelPage extends StatefulWidget {
  const CreatefunnelPage({super.key});

  @override
  State<CreatefunnelPage> createState() => _CreatefunnelPageState();
}

class _CreatefunnelPageState extends State<CreatefunnelPage> {
  final TextEditingController creatorname = TextEditingController();
  final TextEditingController creatorsalutation = TextEditingController();
  final TextEditingController funneldescription = TextEditingController();
  final TextEditingController funnelprice = TextEditingController();

  File? _profileImage; // Creator Profile Image
  File? _funnelImage; // Funnel Banner Image

  final supabase = Supabase.instance.client;
  bool _isLoading = false;
  final Authservicelog authservice = Authservicelog();

  final List<String> items = ['private', 'public'];
  String selecteditem = 'public';

  Future<void> pickImage({required bool isProfile}) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        if (isProfile) {
          _profileImage = File(image.path);
        } else {
          _funnelImage = File(image.path);
        }
      });
    }
  }

  Future<void> haveafunnel() async {
    if (creatorname.text.isEmpty ||
        creatorsalutation.text.isEmpty ||
        funneldescription.text.isEmpty ||
        (selecteditem == 'private' && funnelprice.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    if (_profileImage == null || _funnelImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select both images')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final cuser = authservice.getuserid().toString();
    try {
      // Upload profile image
      final filename = DateTime.now().microsecondsSinceEpoch.toString();
      final profilePath = 'uploads/profile_$filename';
      final funnelPath = 'uploads/funnel_$filename';

      await supabase.storage
          .from('newwayfunnelprofileimage')
          .upload(profilePath, _profileImage!);

      // Upload funnel image
      await supabase.storage
          .from('newwayfunnelbanner')
          .upload(funnelPath, _funnelImage!);

      // Get public URLs for the uploaded images
      final String profileImageUrl = supabase.storage
          .from('newwayfunnelprofileimage')
          .getPublicUrl(profilePath);
      final String funnelImageUrl =
          supabase.storage.from('newwayfunnelbanner').getPublicUrl(funnelPath);

      // Insert funnel data into the database
      await supabase.from('newwayfunnelinfo').insert({
        'name': creatorname.text,
        'salutation': creatorsalutation.text,
        'summaray': funneldescription.text,
        'condition': selecteditem,
        'price': selecteditem == 'private' && funnelprice.text.isNotEmpty
            ? double.parse(funnelprice.text)
            : 0.0,
        'funnelimageurl': funnelImageUrl,
        'profileimageurl': profileImageUrl,
        'userid': cuser,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Funnel created successfully!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const LoadingPage1();

    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 15),
            Center(
              child: Text('Create Funnel',
                  style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            ),
            const SizedBox(height: 25),

            // Profile Image Picker
            Center(
              child: GestureDetector(
                onTap: () => pickImage(isProfile: true),
                child: CircleAvatar(
                  radius: 70,
                  backgroundColor: textfieldgrey,
                  backgroundImage:
                      _profileImage != null ? FileImage(_profileImage!) : null,
                  child: _profileImage == null
                      ? const Icon(Icons.person, size: 50, color: Colors.white)
                      : null,
                ),
              ),
            ),

            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('Creator Name',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            Textfield(
                controller: creatorname,
                hinttext: 'Ex: Ramindu Randeniya',
                obscuretext: false),
            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('Creator Salutation',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            Textfield(
                controller: creatorsalutation,
                hinttext: 'Ex: Doctor/Fitness Coach',
                obscuretext: false),
            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('Funnel Description',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            Textfield(
                controller: funneldescription,
                hinttext: 'About your funnel',
                obscuretext: false),
            const SizedBox(height: 25),

            // Funnel Image Picker
            Center(
              child: GestureDetector(
                onTap: () => pickImage(isProfile: false),
                child: Container(
                  width: 290,
                  height: 150,
                  decoration: BoxDecoration(
                    color: textfieldgrey,
                  ),
                  child: _funnelImage != null
                      ? Image.file(_funnelImage!, fit: BoxFit.cover)
                      : const Center(
                          child: Text('Select Funnel Image',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 18))),
                ),
              ),
            ),
            const SizedBox(height: 35),

            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('Funnel Status',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
            const SizedBox(
              height: 18,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: DropdownButton<String>(
                value: selecteditem,
                dropdownColor: primary,
                isExpanded: true,
                style: TextStyle(fontSize: 20, color: Colors.white),
                onChanged: (String? item) {
                  setState(() {
                    selecteditem = item!;
                  });
                },
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(
              height: 25,
            ),

            if (selecteditem == 'private')
              Textfield(
                  controller: funnelprice,
                  hinttext: 'Funnel membership price',
                  obscuretext: false),

            const SizedBox(height: 25),
            Center(
              child: Container(
                height: 150,
                child: Lottie.network(
                    'https://lottie.host/3e6a5802-ee93-4884-9e17-cd42b8d69246/L4YPZ6x8FX.json'),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Button(text: 'Get Started', onTap: haveafunnel),
            ),

            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
