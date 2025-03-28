import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:newway/classes/authservice.dart';
import 'package:newway/components/colors.dart';
import 'package:newway/components/loading_page1.dart';
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
      backgroundColor: Color(0xFF1E1E2E),
      appBar: AppBar(
        backgroundColor: Color(0xFF1E1E2E),
        elevation: 0,
        title: const Text(
          'Create Funnel',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Header section with animation
              Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                    color: textfieldgrey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Create Your Funnel',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Set up your profile and funnel details',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Profile Image Section
              Center(
                child: Column(
                  children: [
                    Text(
                      'Profile Image',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => pickImage(isProfile: true),
                      child: Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 65,
                              backgroundColor: textfieldgrey,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : null,
                              child: _profileImage == null
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.person,
                                          size: 40,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Select Image',
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.8),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    )
                                  : null,
                            ),
                          ),
                          if (_profileImage == null)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.add_a_photo,
                                  color: primary,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Form Fields
              _buildFormField(
                label: 'Creator Name',
                controller: creatorname,
                hintText: 'Ex: Ramindu Randeniya',
                icon: Icons.person_outline,
              ),

              _buildFormField(
                label: 'Creator Salutation',
                controller: creatorsalutation,
                hintText: 'Ex: Doctor/Fitness Coach',
                icon: Icons.work_outline,
              ),

              _buildFormField(
                label: 'Funnel Description',
                controller: funneldescription,
                hintText: 'About your funnel',
                icon: Icons.description_outlined,
                maxLines: 3,
              ),

              const SizedBox(height: 32),

              // Funnel Banner Image
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 12),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.image_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Funnel Banner Image',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => pickImage(isProfile: false),
                    child: Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        color: textfieldgrey.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: _funnelImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(
                                _funnelImage!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.add_photo_alternate_outlined,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Select Funnel Banner Image',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'This will be displayed on your funnel page',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.6),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Funnel Status
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, bottom: 12),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.visibility_outlined,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Funnel Status',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: textfieldgrey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selecteditem,
                        dropdownColor: primary,
                        isExpanded: true,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.white,
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                        onChanged: (String? item) {
                          setState(() {
                            selecteditem = item!;
                          });
                        },
                        items: items.map((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Row(
                              children: [
                                Icon(
                                  item == 'public'
                                      ? Icons.public
                                      : Icons.lock_outline,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  item.substring(0, 1).toUpperCase() +
                                      item.substring(1),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Price field (if private)
              if (selecteditem == 'private')
                _buildFormField(
                  label: 'Funnel Price',
                  controller: funnelprice,
                  hintText: 'Funnel membership price',
                  icon: Icons.attach_money,
                  keyboardType: TextInputType.number,
                ),

              const SizedBox(height: 32),

              // Animation
              Center(
                child: SizedBox(
                  height: 120,
                  child: Lottie.network(
                    'https://lottie.host/3e6a5802-ee93-4884-9e17-cd42b8d69246/L4YPZ6x8FX.json',
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Submit Button
              Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: haveafunnel,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.rocket_launch, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Create Funnel',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 8),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: textfieldgrey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: false,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
