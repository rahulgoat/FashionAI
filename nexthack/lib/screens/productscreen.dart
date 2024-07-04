import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:card_swiper/card_swiper.dart';
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
  bool isfoot = false;
  String _selectedCategory = "top";

  @override
  void initState() {
    super.initState();
    _products = widget.products ?? Future.value([]);
    _products.then((value) {
      setState(() {
        _productList = value;
      });
    });
    _fetchProducts(_selectedCategory, false);
  }

  Future<void> _fetchProducts(String things, bool foot) async {
    Serper serper = Serper();
    List<Map<String, dynamic>> products = await serper.serpercall(
      widget.gender,
      widget.budget,
      widget.outfit,
      things,
    );
    setState(() {
      _productList = products;
      isfoot = foot;
      _selectedCategory = things;
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
                      onPressed: () => _fetchProducts("top", false),
                      icon: Icon(
                        Icons.checkroom,
                        color: _selectedCategory == "top"
                            ? Colors.white
                            : Colors.black,
                      ),
                      label: Text(
                        "Top",
                        style: TextStyle(
                          color: _selectedCategory == "top"
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedCategory == "top"
                            ? Colors.deepPurple
                            : Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _fetchProducts("bottom", false),
                      icon: Icon(
                        Icons.accessibility_new,
                        color: _selectedCategory == "bottom"
                            ? Colors.white
                            : Colors.black,
                      ),
                      label: Text(
                        "Bottom",
                        style: TextStyle(
                          color: _selectedCategory == "bottom"
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedCategory == "bottom"
                            ? Colors.deepPurple
                            : Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _fetchProducts("shoes", true),
                      icon: Icon(
                        Icons.directions_run,
                        color: _selectedCategory == "shoes"
                            ? Colors.white
                            : Colors.black,
                      ),
                      label: Text(
                        "Shoes",
                        style: TextStyle(
                          color: _selectedCategory == "shoes"
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedCategory == "shoes"
                            ? Colors.deepPurple
                            : Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _fetchProducts("accessories", false),
                      icon: Icon(
                        Icons.watch,
                        color: _selectedCategory == "accessories"
                            ? Colors.white
                            : Colors.black,
                      ),
                      label: Text(
                        "Accessories",
                        style: TextStyle(
                          color: _selectedCategory == "accessories"
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedCategory == "accessories"
                            ? Colors.deepPurple
                            : Colors.white,
                      ),
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
                  fit: isfoot == true ? BoxFit.fill : BoxFit.cover,
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
                      child: const Text(
                        'View Product',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple),
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
    if (await launchUrl(uri)) {
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }
}
