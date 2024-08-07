import 'package:flutter/material.dart';

class OrderSuccessPage extends StatefulWidget {
  @override
  _OrderSuccessPageState createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage> {
  @override
  void initState() {
    super.initState();
    // Start animation after the widget is built
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order Success',
          style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              color: Colors.green),
        ),
        backgroundColor: Colors.blueGrey,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // AnimatedSwitcher to fade between widgets
            AnimatedSwitcher(
              duration: Duration(seconds: 5),
              child: Image.network(
                'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZ1ysSevVEeNiTDkvbGRM0pSGaQ_7KqYSovKKgeUKQcNcmyUagyK8F1KoWbDWKxuYXkTA&usqp=CAU',
                key: ValueKey<int>(
                    1), // Key helps AnimatedSwitcher to know which widget to animate
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Your order has been placed successfully!',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
