import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexthack/screens/productscreen.dart';
import 'package:nexthack/serper.dart';

class LoadingGenie extends StatefulWidget {
  final String gender, occasion, budget;
  final XFile xfilePick;
  final Future<List<Map<String, dynamic>>>? futureOutfits;

  const LoadingGenie({
    Key? key,
    required this.gender,
    required this.occasion,
    required this.budget,
    required this.xfilePick,
    this.futureOutfits,
  }) : super(key: key);

  @override
  State<LoadingGenie> createState() => _LoadingGenieState();
}

class _LoadingGenieState extends State<LoadingGenie> {
  Future<List<Map<String, dynamic>>>? _futureOutfits;

  @override
  void initState() {
    super.initState();
    _futureOutfits = widget.futureOutfits;
  }

  String getFirstSentence(String text) {
    RegExp exp = RegExp(r'^.*?[\.!\?]', multiLine: true);
    Iterable<RegExpMatch> matches = exp.allMatches(text);
    return matches.isNotEmpty ? matches.first.group(0) ?? text : text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/genderpage.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SizedBox(
          height: 800,
          child: SafeArea(
            child: Column(
              children: [
                const Text('Outfits which will be perfect for you 🌟',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      color: Colors.white,
                      fontSize: 18,
                    )),
                const SizedBox(height: 5),
                const Text(
                  'Select your preferred outfit.',
                  style: TextStyle(
                    fontFamily: 'Georgia',
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: _futureOutfits,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No outfits found'));
                      } else {
                        List<Map<String, dynamic>> outfits = snapshot.data!;
                        return Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: ListView.builder(
                            itemCount: outfits.length,
                            itemBuilder: (context, index) {
                              Map<String, dynamic> outfit = outfits[index];
                              return Container(
                                margin: const EdgeInsets.all(8.0),
                                padding: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(114, 80, 161, 1),
                                  gradient: const LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: <Color>[
                                        Color.fromRGBO(114, 80, 161, 1),
                                        Color.fromARGB(255, 138, 79, 152),
                                      ]),
                                  borderRadius: BorderRadius.circular(8.0),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Colors.grey.withOpacity(0.5),
                                  //     spreadRadius: 5,
                                  //     blurRadius: 7,
                                  //     offset: Offset(0, 3),
                                  //   ),
                                  // ],
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            outfit['Outfit_name'] ?? 'No Name',
                                            style: TextStyle(
                                              color: Colors.grey[300],
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            getFirstSentence(
                                                outfit['description'] ??
                                                    'No Description'),
                                            textAlign: TextAlign.justify,
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const VerticalDivider(
                                      color: Colors.black,
                                      thickness: 1,
                                      width: 10,
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.arrow_forward),
                                      color: Colors.grey[300],
                                      onPressed: () {
                                        Future<List<Map<String, dynamic>>>
                                            products = Serper().serpercall(
                                                widget.gender,
                                                widget.budget,
                                                outfit);
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductsPage(
                                                        products: products)));
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
