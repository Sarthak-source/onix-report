import 'dart:io' as io;
import 'dart:typed_data'; // Import for Uint8List

import '../data/model/reports.dart';

abstract class PdfFormState {
  final String? clientName;
  final String? clientAddress;
  final String? clientCity;
  final String? clientCountry;
  final String? clientPostalCode;
  final String? clientTaxNO;
  final String? clientTaxCRN;

  final String? clientOther;

  final String? supplierName;
  final String? supplierAddress;
  final String? supplierCity;
  final String? supplierCountry;

  final String? supplierPostalCode;
  final String? supplierTaxNO;

  final String? supplierTaxCRN;
  final String? supplierOther;

  final String? invoiceDate;
  final String? dueDate;
  final String? paymentMethod;

  final List<InvoiceItem> items;
  final io.File? logoImageFile;
  final io.File? qrCodeImageFile;
  final Uint8List? logoImageBytes; // For web
  final Uint8List? qrCodeImageBytes; // For web

  PdfFormState({
    required this.supplierName,
    required this.clientName,
    required this.supplierAddress,
    required this.supplierCity,
    required this.supplierCountry,
    required this.clientAddress,
    required this.clientCity,
    required this.clientCountry,
    required this.invoiceDate,
    required this.dueDate,
    required this.paymentMethod,
    required this.items,
    required this.clientPostalCode,
    required this.clientTaxNO,
    required this.clientTaxCRN,
    required this.clientOther,
    required this.supplierPostalCode,
    required this.supplierTaxNO,
    required this.supplierTaxCRN,
    required this.supplierOther,
    this.logoImageFile,
    this.qrCodeImageFile,
    this.logoImageBytes, // For web
    this.qrCodeImageBytes, // For web
  });
}

class PdfFormInitial extends PdfFormState {
  PdfFormInitial({
    required super.supplierName,
    required super.clientName,
    required super.items,
    super.logoImageFile,
    super.qrCodeImageFile,
    super.logoImageBytes,
    super.qrCodeImageBytes,
    required super.supplierAddress,
    required super.supplierCity,
    required super.supplierCountry,
    required super.clientAddress,
    required super.clientCity,
    required super.clientCountry,
    required super.invoiceDate,
    required super.dueDate,
    required super.paymentMethod,
    required super.clientPostalCode,
    required super.clientTaxNO,
    required super.clientTaxCRN,
    required super.clientOther,
    required super.supplierPostalCode,
    required super.supplierTaxNO,
    required super.supplierTaxCRN,
    required super.supplierOther,
  });
}

class PdfFormSuccess extends PdfFormState {
  final String filePath;
  PdfFormSuccess({
    required super.supplierName,
    required super.clientName,
    required super.items,
    required this.filePath,
    required super.supplierAddress,
    required super.supplierCity,
    required super.supplierCountry,
    required super.clientAddress,
    required super.clientCity,
    required super.clientCountry,
    required super.invoiceDate,
    required super.dueDate,
    required super.paymentMethod,
    required super.clientPostalCode,
    required super.clientTaxNO,
    required super.clientTaxCRN,
    required super.clientOther,
    required super.supplierPostalCode,
    required super.supplierTaxNO,
    required super.supplierTaxCRN,
    required super.supplierOther,
  });
}

class PdfFormFailure extends PdfFormState {
  final String message;
  PdfFormFailure({
    required this.message,
    required super.supplierName,
    required super.clientName,
    required super.items,
    required super.supplierAddress,
    required super.supplierCity,
    required super.supplierCountry,
    required super.clientAddress,
    required super.clientCity,
    required super.clientCountry,
    required super.invoiceDate,
    required super.dueDate,
    required super.paymentMethod,
    required super.clientPostalCode,
    required super.clientTaxNO,
    required super.clientTaxCRN,
    required super.clientOther,
    required super.supplierPostalCode,
    required super.supplierTaxNO,
    required super.supplierTaxCRN,
    required super.supplierOther,
  });
}
