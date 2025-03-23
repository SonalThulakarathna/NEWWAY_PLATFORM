import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:newway/classes/authservice.dart';
import 'package:newway/components/colors.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({
    super.key,
  });

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  final supabase = Supabase.instance.client;
  final auth = Authservicelog();
  List<Map<String, dynamic>> funnelDetails = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUserFunnels();
  }

  void fetchUserFunnels() async {
    final cuser = auth.getuserid().toString();

    try {
      final response = await supabase
          .from('funnelmembers')
          .select('funnelid')
          .eq('userid', cuser);

      if (response.isNotEmpty) {
        List<String> funnelIds =
            response.map((item) => item['funnelid'].toString()).toList();

        final funnelsResponse = await supabase
            .from('newwayfunnelinfo')
            .select('*')
            .inFilter('id', funnelIds);

        setState(() {
          funnelDetails = funnelsResponse as List<Map<String, dynamic>>;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching user funnels: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: isLoading
          ? Center(
              child: SizedBox(
              height: 650,
              child: Lottie.network(
                  'https://lottie.host/d4649615-85f7-4ef1-81e3-c5015ed851d7/83V9j7MnW7.json'),
            ))
          : funnelDetails.isEmpty
              ? const Center(
                  child: Text("No joined funnels found.",
                      style: TextStyle(color: Colors.white)))
              : ListView.builder(
                  itemCount: funnelDetails.length,
                  itemBuilder: (context, index) {
                    final funnel = funnelDetails[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Card(
                        color: Colors.grey,
                        margin: const EdgeInsets.all(10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          title: Text(
                            funnel['name'] ?? 'Unnamed Funnel',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ), // Assuming 'name' column exists
                          subtitle: Text(funnel['summaray'] ??
                              'No description available'), // Assuming 'description' column exists
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {},
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
