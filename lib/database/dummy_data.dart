class DummyDatabase {
  // Simulating an asynchronous fetch from a database
  static Future<Map<String, dynamic>> fetchInvoiceData() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network/database delay
    return {
      'invoiceNumber': 'DB-00123',
      'customerName': 'Alice Johnson',
      'date': '2024-12-15',
      'productDetails': [
        {'description': 'Laptop', 'qty': 1, 'price': 1000.0, 'gst': 18.0},
        {'description': 'Mouse', 'qty': 2, 'price': 50.0, 'gst': 9.0},
        {'description': 'Keyboard', 'qty': 1, 'price': 70.0, 'gst': 12.6},
      ],
      'totalAmount': 1250.6,
    };
  }
}
