import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:savor_go1/screens/invoiceScreen.dart';

class PaymentScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalAmount;

  const PaymentScreen({Key? key, required this.cartItems, required this.totalAmount}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorpay;
  String paymentStatus = "Click the button to start payment";

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
  setState(() {
    paymentStatus = "✅ Payment Successful: ${response.paymentId}";
  });

  Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => InvoiceScreen(cartItems: widget.cartItems, totalAmount: widget.totalAmount),
  ),
);
}

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      paymentStatus = "Payment Failed: ${response.message}";
    });
    _showDialog("Payment Failed", "Error: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    setState(() {
      paymentStatus = "External Wallet Used: ${response.walletName}";
    });
    _showDialog("External Wallet", "Selected Wallet: ${response.walletName}");
  }

  void _startPayment() {
    var options = {
      'key': 'rzp_test_zk5c0q1Ahl5aqc',
      'amount': (widget.totalAmount * 100).toInt(),
      'currency': 'INR',
      'name': 'SavorGo Food Delivery',
      'description': 'Order Payment',
      'prefill': {
        'contact': '9876543210',
        'email': 'test@example.com',
      },
      'theme': {'color': '#F37254'},
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("⚠️ Razorpay Error: $e");
      _showDialog("Error", "Payment could not be started.");
    }
  }

  // 📢 Show Dialog Box After Payment
  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            )
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _razorpay.clear(); // ✅ Release resources
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              paymentStatus,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startPayment,
              child: Text("Pay ₹${widget.totalAmount.toStringAsFixed(2)}"),
            ),
          ],
        ),
      ),
    );
  }
}