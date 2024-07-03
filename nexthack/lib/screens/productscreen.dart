import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nexthack/serper.dart';

class ProductsPage extends StatefulWidget {
  final Future<List<Map<String, dynamic>>>? products;
  final String gender;
  final String budget;
  final Map<String, dynamic> outfit;

  ProductsPage({
    Key? key,
    this.products,
    required this.gender,
    required this.budget,
    required this.outfit,
  }) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late Future<List<Map<String, dynamic>>> _products;
  List<Map<String, dynamic>> _productList = [];

  @override
  void initState() {
    super.initState();
    _products = widget.products ?? Future.value([]);
    _products.then((value) {
      setState(() {
        _productList = value;
      });
    });
  }

  Future<void> _fetchProducts(String things) async {
    Serper serper = Serper();
    List<Map<String, dynamic>> products = await serper.serpercall(
      widget.gender,
      widget.budget,
      widget.outfit,
      things,
    );
    setState(() {
      _productList = products;
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
              const Text(
                'Outfits which will be perfect for you 🌟',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _fetchProducts("top"),
                      icon: const Icon(Icons.checkroom),
                      label: const Text("Top"),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _fetchProducts("bottom"),
                      icon: const Icon(Icons.accessibility_new),
                      label: const Text("Bottom"),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _fetchProducts("shoes"),
                      icon: const Icon(Icons.directions_run),
                      label: const Text("Shoes"),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _fetchProducts("accessories"),
                      icon: const Icon(Icons.watch),
                      label: const Text("Accessories"),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _productList.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : _buildSwiperCards(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwiperCards() {
    return Swiper(
      itemBuilder: (BuildContext context, int index) {
        return _buildCard(_productList[index]);
      },
      itemCount: _productList.length,
      layout: SwiperLayout.STACK,
      itemWidth: MediaQuery.of(context).size.width - 2 * 40,
      itemHeight: MediaQuery.of(context).size.height * 0.7,
      curve: Curves.easeOutCubic,
      onIndexChanged: (index) {
        setState(() {
          // Handle card index change if needed
        });
      },
      onTap: (index) {
        // Handle card tap if needed
      },
    );
  }

  Widget _buildCard(Map<String, dynamic> product) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.75,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.5),
            //     spreadRadius: 5,
            //     blurRadius: 7,
            //     offset: const Offset(0, 3),
            //   ),
            // ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(8.0)),
                child: Image.network(
                  product['imageUrl'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  alignment: AlignmentDirectional.topStart,
                  filterQuality: FilterQuality.high,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      product['title'],
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15.0),
                    Text(
                      'Price: ${product['price']}',
                      style: TextStyle(
                        fontSize: 17.0,
                        color: Colors.grey[900],
                      ),
                    ),
                    const SizedBox(height: 15.0),
                    ElevatedButton(
                      onPressed: () {
                        _launchURL(context, product['link']);
                      },
                      child: const Text('View Product'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _launchURL(BuildContext context, String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunch(uri.toString())) {
      await launch(uri.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }
}
