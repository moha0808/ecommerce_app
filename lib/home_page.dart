import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Cart_page.dart';
import 'product_detail_page.dart';
import 'product.dart';

// Bottom Navigation Bar Implementation
class BottomNavBarItem {
  final String title;
  final IconData icon;
  BottomNavBarItem({
    required this.title,
    required this.icon,
  });
}

class BottomNavBar extends StatefulWidget {
  final List<BottomNavBarItem> children;
  int currentIndex;
  final Color? backgroundColor;
  Function(int)? onTap;
  BottomNavBar({
    super.key,
    required this.children,
    required this.currentIndex,
    this.backgroundColor,
    required this.onTap,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: widget.backgroundColor ?? Theme.of(context).colorScheme.primary,
      ),
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
      height: 56,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          widget.children.length,
          (index) => NavBarItem(
            index: index,
            item: widget.children[index],
            selected: widget.currentIndex == index,
            onTap: () {
              setState(() {
                widget.currentIndex = index;
                widget.onTap!(widget.currentIndex);
              });
            },
          ),
        ),
      ),
    );
  }
}

class NavBarItem extends StatefulWidget {
  final BottomNavBarItem item;
  final int index;
  bool selected;
  final Function onTap;
  final Color? backgroundColor;
  NavBarItem({
    super.key,
    required this.item,
    this.selected = false,
    required this.onTap,
    this.backgroundColor,
    required this.index,
  });

  @override
  State<NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<NavBarItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
      },
      child: AnimatedContainer(
        margin: const EdgeInsets.all(8),
        duration: const Duration(milliseconds: 300),
        constraints: BoxConstraints(minWidth: widget.selected ? 100 : 56),
        height: 56,
        decoration: BoxDecoration(
          color: widget.selected
              ? widget.backgroundColor ?? Colors.white
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.item.icon,
              color: widget.selected ? Colors.blue : Colors.grey,
            ),
            Offstage(
                offstage: !widget.selected, child: Text(widget.item.title)),
          ],
        ),
      ),
    );
  }
}

// HomePage Implementation
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> products;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  TextEditingController _searchController = TextEditingController();
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  String _selectedCategory = 'All';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    products = fetchProducts();
    _autoSlide();
  }

  Future<List<Product>> fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://dummyjson.com/products'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body)['products'];
      _allProducts =
          jsonResponse.map((product) => Product.fromJson(product)).toList();
      _filteredProducts = _allProducts;
      return _filteredProducts;
    } else {
      throw Exception('Failed to load products');
    }
  }

  void _autoSlide() {
    Future.delayed(Duration(seconds: 3), () {
      if (_pageController.hasClients) {
        _currentPage = (_currentPage + 1) % 3;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
        _autoSlide();
      }
    });
  }

  void _filterProducts(String query) {
    setState(() {
      _filteredProducts = _allProducts
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _filterByCategory(String category) {
    setState(() {
      _selectedCategory = category;
      _filteredProducts = _allProducts
          .where((product) =>
              category == 'All' ||
              product.category.toLowerCase() == category.toLowerCase())
          .toList();
    });
  }

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Add navigation logic here
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CartPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'E-Commerce App',
          style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.blue),
        ),
        foregroundColor: Colors.black,
        actions: [
          // IconButton(
          //   icon: Icon(
          //     Icons.shopping_cart,
          //     color: Color(0xc6000000),
          //   ),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => CartPage()),
          //     );
          //   },
          // ),
          IconButton(
            icon: Icon(
              Icons.notification_add,
              color: Color(0xc6000000),
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          // Image Carousel
          Container(
            height: 200.0,
            child: PageView(
              controller: _pageController,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    'https://t3.ftcdn.net/jpg/01/47/51/60/240_F_147516063_hCXI8VUIdBYud0B0hhS3Yo5CFTT1a4g8.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    'https://t3.ftcdn.net/jpg/02/45/13/76/240_F_245137608_Y9ZhgOfYYvKfiUtUcWzhO97MWCTRe7w3.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    'https://t3.ftcdn.net/jpg/04/40/07/32/240_F_440073209_G5zCsw04ViEwTwapmeMjendrNaqGODTU.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20), // Space between slider and search input
          // Category Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _categoryButton('All'),
                        _categoryButton('Makeup'),
                        _categoryButton('Furniture'),
                        _categoryButton('Vegetables'),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {
                    // Add filter functionality here
                  },
                ),
              ],
            ),
          ),
          SizedBox(
              height:
                  10), // Add space between category section and search input
          // Search Input Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterProducts,
                    decoration: InputDecoration(
                      suffixIcon: Icon(Icons.search),
                      hintText: 'Search for products...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10), // Space between search input and product grid
          // Product Grid
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: products,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsPage(
                                product: product,
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 5.0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15.0)),
                                  child: Image.network(
                                    product.thumbnail,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  product.name,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'Price: \$${product.price}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Icon(
                                      Icons.favorite_border,
                                      color: Color(0xfffb0101),
                                      size: 20.0,
                                    ),
                                  ],
                                ),
                              ),
                              // Rating Section
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 4.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.yellow[700],
                                      size: 20.0,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      product.rating.toStringAsFixed(1),
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Failed to load products'));
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.blue,
        onTap: _onNavBarTap,
        children: [
          BottomNavBarItem(
            title: "Home",
            icon: Icons.home_outlined,
          ),
          BottomNavBarItem(
            title: "Search",
            icon: Icons.search_rounded,
          ),
          BottomNavBarItem(
            title: 'Cart',
            icon: Icons.shopping_cart,
          ),
          BottomNavBarItem(
            title: "Profile",
            icon: Icons.person_outline,
          ),
        ],
      ),
    );
  }

  Widget _categoryButton(String category) {
    return GestureDetector(
      onTap: () => _filterByCategory(category),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        decoration: BoxDecoration(
          color: _selectedCategory == category ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(color: Colors.blue, width: 1.0),
        ),
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              color:
                  _selectedCategory == category ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(home: HomePage()));
}
