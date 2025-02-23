import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newway/classes/authservice.dart';
import 'package:newway/components/button.dart';
import 'package:newway/components/colors.dart';
import 'package:newway/components/textfield.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreatefunnelPage extends StatefulWidget {
  const CreatefunnelPage({
    super.key,
  });

  @override
  State<CreatefunnelPage> createState() => _CreatefunnelPageState();
}

class _CreatefunnelPageState extends State<CreatefunnelPage> {
  final TextEditingController creatorname = TextEditingController();
  final TextEditingController creatorsalutation = TextEditingController();
  final TextEditingController funneldescription = TextEditingController();
  final TextEditingController funnelprice = TextEditingController();
  File? _imagefile;
  final supabase = Supabase.instance.client;

  final Authservicelog authservice = Authservicelog();

  Future pickimage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imagefile = File(image.path);
      });
    }
  }

  final List<String> items = ['private', 'public'];
  String? selecteditem = 'public';

  Future<void> haveafunnel() async {
    try {
      final Session? session = supabase.auth.currentSession;
      if (session == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User is not logged in')),
        );
        return;
      }
      if (creatorname.text.isEmpty ||
          creatorsalutation.text.isEmpty ||
          funneldescription.text.isEmpty ||
          (selecteditem == 'private' && funnelprice.text.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all required fields')),
        );
        return;
      }

      if (_imagefile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an image')),
        );
        return;
      }

      final filename = DateTime.now().microsecondsSinceEpoch.toString();
      final path = 'uploads/$filename';

      await supabase.storage
          .from('newwayfunnelbanner')
          .upload(path, _imagefile!);
      final String imageUrl =
          supabase.storage.from('newwayfunnelbanner').getPublicUrl(path);

      final response = await supabase.from('newwayfunnelinfo').insert({
        'name': creatorname.text,
        'salutation': creatorsalutation.text,
        'summaray': funneldescription.text,
        'condition': selecteditem,
        'price': selecteditem == 'private' && funnelprice.text.isNotEmpty
            ? double.parse(funnelprice.text)
            : 0.0,
        'funnelimageurl': imageUrl,
        'userid': authservice.getuserid(),
      }).select('id');

      if (response.isEmpty) throw Exception('Insert failed');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Funnel created successfully! ')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating funnel: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*Center(
              child: Container(
                width: 100,
                height: 100,
                child: const CircleAvatar(
                  backgroundImage: AssetImage('lib/images/lettern.png'),
                ),
              ),
            ),*/
            const SizedBox(height: 15),
            Center(
              child: Text(
                'Create Funnel',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                'Creator Name',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            Textfield(
                controller: creatorname,
                hinttext: 'Ex: Ramindu Randeniya',
                obscuretext: false),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                'Creator Salutation',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            Textfield(
                controller: creatorsalutation,
                hinttext: 'Ex: Doctor/Fitness Coach',
                obscuretext: false),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                'Funnel Description',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: TextFormField(
                minLines: 1,
                maxLines: 5,
                controller: funneldescription,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(),
                  fillColor: textfieldgrey,
                  filled: true,
                  hintText: 'About your funnel',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Center(
              child: GestureDetector(
                onTap: pickimage,
                child: Container(
                  width: 350,
                  height: 150,
                  decoration: BoxDecoration(color: textfieldgrey),
                  child: _imagefile != null
                      ? Image.file(
                          _imagefile!,
                          fit: BoxFit.cover,
                        )
                      : const Center(
                          child: Text(
                            'Nothing selected',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                'Funnel status',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(
              height: 10,
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
                    selecteditem = item;
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
            selecteditem == 'private'
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      minLines: 1,
                      maxLines: 5,
                      controller: funnelprice,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(),
                        fillColor: textfieldgrey,
                        filled: true,
                        hintText: 'Funnel membership price',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : SizedBox(),
            const SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Button(
                text: 'Get started',
                onTap: haveafunnel,
              ),
            )
          ],
        ),
      ),
    );
  }
}
