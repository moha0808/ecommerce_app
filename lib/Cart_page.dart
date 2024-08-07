import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Order_page.dart';
import 'cart_model.dart';
// import 'bottom_nav_bar.dart'; // Ensure this is imported if it's a separate file
import 'home_page.dart'; // Ensure this is imported to navigate back to HomePage

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int _selectedIndex = 2; // Set the default selected index to Cart

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else if (index == 1) {
      // Add navigation to Search page here
    } else if (index == 3) {
      // Add navigation to Profile page here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cart',
          style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.blue),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.white,
      ),
      body: Consumer<CartModel>(
        builder: (context, cart, child) {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.products.length,
                  itemBuilder: (context, index) {
                    final product = cart.products[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 4,
                        child: ListTile(
                          leading: Image.network(
                            product.thumbnail,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(
                            product.name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            'Size: ${product.price} x ${cart.quantities[product.id]}',
                          ),
                          trailing: Container(
                            width: 120,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    cart.remove(product);
                                  },
                                ),
                                Text('${cart.quantities[product.id]}'),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    cart.add(product);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 20, color: Colors.green),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderSuccessPage()),
                        );
                        cart.clear();
                      },
                      child: Text('Proceed to Checkout',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
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
}
