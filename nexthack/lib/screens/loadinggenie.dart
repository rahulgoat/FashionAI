import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nexthack/screens/productscreen.dart';
import 'package:nexthack/serper.dart';
import 'package:lottie/lottie.dart';
import 'package:nexthack/geminiapi.dart';
import 'dart:async';

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

class _LoadingGenieState extends State<LoadingGenie>
    with TickerProviderStateMixin {
  Future<List<Map<String, dynamic>>>? _futureOutfits;
  List<Map<String, dynamic>> _outfits = [];
  bool _outfitsAdded = false;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _futureOutfits = widget.futureOutfits ?? fetchOutfits();
    _pageController = PageController(viewportFraction: 0.8);
  }

  Future<List<Map<String, dynamic>>> fetchOutfits() async {
    return await GeminiApi(
            gender: widget.gender,
            occasion: widget.occasion,
            xfilePick: widget.xfilePick)
        .sendImageToGeminiAPI();
  }

  String getFirstSentence(String text) {
    RegExp exp = RegExp(r'^.*?[\.!\?]', multiLine: true);
    Iterable<RegExpMatch> matches = exp.allMatches(text);
    return matches.isNotEmpty ? matches.first.group(0) ?? text : text;
  }

  Future<void> _addOutfits(List<Map<String, dynamic>> outfits) async {
    setState(() {
      _outfits = outfits;
      _outfitsAdded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/genderpage.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Text(
                  'Outfits which will be perfect for you 🌟',
                  style: TextStyle(
                    fontFamily: 'Agrandir-Regular',
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Text(
                'Select your preferred outfit.',
                style: TextStyle(
                  fontFamily: 'Agrandir-GrandLight',
                  color: Colors.white54,
                  fontSize: 14,
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: _futureOutfits,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        //     child: LottieBuilder.asset(
                        //   'assets/animations/loading.json',
                        //   frameRate: FrameRate.max,
                        // ));
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                          child: LottieBuilder.asset(
                        'assets/animations/loading.json',
                        frameRate: FrameRate.max,
                      ));
                    } else {
                      if (!_outfitsAdded) {
                        List<Map<String, dynamic>> outfits = snapshot.data!;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _addOutfits(outfits);
                        });
                      }
                      return _buildCarousel();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarousel() {
    return PageView.builder(
      itemCount: _outfits.length,
      itemBuilder: (context, index) {
        return _buildItem(_outfits[index]);
      },
      controller: _pageController,
      onPageChanged: (index) {
        // Handle page change if needed
      },
    );
  }

  Widget _buildItem(Map<String, dynamic> outfit) {
    return Center(
      child: IntrinsicHeight(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: const Color.fromRGBO(114, 80, 161, 1),
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color.fromRGBO(114, 80, 161, 1),
                Color.fromARGB(255, 138, 79, 152),
              ],
            ),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                outfit['Outfit_name'] ?? 'No Name',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 20.0,
                  fontFamily: "Agrandir-Regular",
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(
                getFirstSentence(outfit['description'] ?? 'No Description'),
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white70,
                  fontFamily: "Agrandir-GrandLight",
                ),
              ),
              const SizedBox(height: 10.0),
              Center(
                child: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  color: Colors.grey[300],
                  onPressed: () {
                    Future<List<Map<String, dynamic>>> products =
                        Serper().serpercall(
                      widget.gender,
                      widget.budget,
                      outfit,
                      'top',
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductsPage(
                          products: products,
                          budget: widget.budget,
                          gender: widget.gender,
                          outfit: outfit,
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
    );
  }
}
