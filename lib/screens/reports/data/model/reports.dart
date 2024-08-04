class InvoiceItem {
  final String description;
  final String unit;
  final int quantity;
  final double price;
  final double vat;

  InvoiceItem({
    required this.description,
    required this.unit,
    required this.quantity,
    required this.price,
    required this.vat,
  });
}
