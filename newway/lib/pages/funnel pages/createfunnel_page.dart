import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newway/classes/userdata.dart';
import 'package:newway/classes/userdataDB.dart';
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
  final Userdatadb _userdatadb = Userdatadb();

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

  Future haveafunnel() async {
    final Userdata? userData = await _userdatadb.getFunnelId();
    if (userData != null && userData.funnelid != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You already have a funnel!')),
      );
      return;
    }
    if (creatorname.text.isEmpty ||
        creatorsalutation.text.isEmpty ||
        funneldescription.text.isEmpty ||
        funnelprice.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
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
            Center(
              child: Container(
                width: 100,
                height: 100,
                child: const CircleAvatar(
                  backgroundImage: AssetImage('lib/images/lettern.png'),
                ),
              ),
            ),
            const SizedBox(height: 25),
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
              height: 45,
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Button(
                text: 'Create Funnel',
                onTap: () {},
              ),
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
