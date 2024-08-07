import 'dart:convert';
import 'dart:developer';
import 'dart:html';
import 'dart:io' as io; // Import for non-web file handling

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../data/model/reports.dart';
import '../views/widgets/pdf_viewer.dart';
import 'reports_state.dart';

class PdfFormCubit extends Cubit<PdfFormState> {
  PdfFormCubit()
      : super(
          PdfFormInitial(
            supplierName: '',
            clientName: '',
            items: [],
            paymentMethod: '',
            supplierAddress: '',
            invoiceDate: '',
            clientCountry: '',
            clientAddress: '',
            supplierCity: '',
            supplierCountry: '',
            clientCity: '',
            dueDate: '',
            supplierTaxCRN: '',
            clientTaxCRN: '',
            clientPostalCode: '',
            clientTaxNO: '',
            clientOther: '',
            supplierPostalCode: '',
            supplierTaxNO: '',
            supplierOther: '',
          ),
        );

  // These are used for non-web platforms
  io.File? logoImageFile;
  io.File? qrCodeImageFile;

  // These are used for web platforms
  Uint8List? logoImageBytes;
  Uint8List? qrCodeImageBytes;

  void updateForm({
    String? supplierName,
    String? clientName,
    String? supplierAddress,
    String? supplierCity,
    String? supplierCountry,
    String? clientAddress,
    String? clientCity,
    String? clientCountry,
    String? invoiceDate,
    String? dueDate,
    String? paymentMethod,
    List<InvoiceItem>? items,
    io.File? logoImageFile,
    io.File? qrCodeImageFile,
    Uint8List? logoImageBytes,
    Uint8List? qrCodeImageBytes,
    // New fields
    String? supplierPostalCode,
    String? supplierTaxNo,
    String? supplierTaxCrn,
    String? supplierOther,
    String? clientPostalCode,
    String? clientTaxNo,
    String? clientTaxCrn,
    String? clientOther,
  }) {
    emit(PdfFormInitial(
      supplierName: supplierName ?? state.supplierName,
      clientName: clientName ?? state.clientName,
      supplierAddress: supplierAddress ?? state.supplierAddress,
      supplierCity: supplierCity ?? state.supplierCity,
      supplierCountry: supplierCountry ?? state.supplierCountry,
      clientAddress: clientAddress ?? state.clientAddress,
      clientCity: clientCity ?? state.clientCity,
      clientCountry: clientCountry ?? state.clientCountry,
      invoiceDate: invoiceDate ?? state.invoiceDate,
      dueDate: dueDate ?? state.dueDate,
      paymentMethod: paymentMethod ?? state.paymentMethod,
      items: items ?? state.items,
      logoImageFile: logoImageFile ?? this.logoImageFile,
      qrCodeImageFile: qrCodeImageFile ?? this.qrCodeImageFile,
      logoImageBytes: logoImageBytes ?? this.logoImageBytes,
      qrCodeImageBytes: qrCodeImageBytes ?? this.qrCodeImageBytes,
      // New fields
      supplierPostalCode: supplierPostalCode ?? state.supplierPostalCode,
      supplierTaxNO: supplierTaxNo ?? state.supplierTaxNO,
      supplierTaxCRN: supplierTaxCrn ?? state.supplierTaxCRN,
      supplierOther: supplierOther ?? state.supplierOther,
      clientPostalCode: clientPostalCode ?? state.clientPostalCode,
      clientTaxNO: clientTaxNo ?? state.clientTaxNO,
      clientTaxCRN: clientTaxCrn ?? state.clientTaxCRN,
      clientOther: clientOther ?? state.clientOther,
    ));
  }

  void addItem(InvoiceItem item) {
    final updatedItems = List<InvoiceItem>.from(state.items)..add(item);
    emit(PdfFormInitial(
      supplierName: state.supplierName,
      clientName: state.clientName,
      items: updatedItems,
      paymentMethod: state.paymentMethod,
      supplierAddress: state.supplierAddress,
      invoiceDate: state.invoiceDate,
      clientCountry: state.clientCountry,
      clientAddress: state.clientAddress,
      supplierCity: state.supplierCity,
      supplierCountry: state.supplierCountry,
      clientCity: state.clientCity,
      dueDate: state.dueDate,
      logoImageFile: logoImageFile,
      qrCodeImageFile: qrCodeImageFile,
      logoImageBytes: logoImageBytes,
      qrCodeImageBytes: qrCodeImageBytes,
      supplierPostalCode: state.supplierPostalCode,
      supplierTaxNO: state.supplierTaxNO,
      supplierTaxCRN: state.supplierTaxCRN,
      supplierOther: state.supplierOther,
      clientPostalCode: state.clientPostalCode,
      clientTaxNO: state.clientTaxNO,
      clientTaxCRN: state.clientTaxCRN,
      clientOther: state.clientOther,
    ));
  }

  Future<void> pickImage({required bool isLogo}) async {
    try {
      final picker = ImagePicker();
      if (kIsWeb) {
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          final bytes = await pickedFile.readAsBytes();
          if (isLogo) {
            logoImageBytes = bytes;
          } else {
            qrCodeImageBytes = bytes;
          }
          emit(PdfFormInitial(
            supplierName: state.supplierName,
            clientName: state.clientName,
            items: state.items,
            paymentMethod: state.paymentMethod,
            supplierAddress: state.supplierAddress,
            invoiceDate: state.invoiceDate,
            clientCountry: state.clientCountry,
            clientAddress: state.clientAddress,
            supplierCity: state.supplierCity,
            supplierCountry: state.supplierCountry,
            clientCity: state.clientCity,
            dueDate: state.dueDate,
            supplierPostalCode: state.supplierPostalCode,
            supplierTaxNO: state.supplierTaxNO,
            supplierTaxCRN: state.supplierTaxCRN,
            supplierOther: state.supplierOther,
            clientPostalCode: state.clientPostalCode,
            clientTaxNO: state.clientTaxNO,
            clientTaxCRN: state.clientTaxCRN,
            clientOther: state.clientOther,
            logoImageFile: logoImageFile,
            qrCodeImageFile: qrCodeImageFile,
            logoImageBytes: logoImageBytes,
            qrCodeImageBytes: qrCodeImageBytes,
          ));
        } else {
          log('No image selected.');
        }
      } else {
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          final file = io.File(pickedFile.path);
          if (isLogo) {
            logoImageFile = file;
          } else {
            qrCodeImageFile = file;
          }
          emit(PdfFormInitial(
            supplierName: state.supplierName,
            clientName: state.clientName,
            items: state.items,
            paymentMethod: state.paymentMethod,
            supplierAddress: state.supplierAddress,
            invoiceDate: state.invoiceDate,
            clientCountry: state.clientCountry,
            clientAddress: state.clientAddress,
            supplierCity: state.supplierCity,
            supplierCountry: state.supplierCountry,
            clientCity: state.clientCity,
            dueDate: state.dueDate,
            supplierPostalCode: state.supplierPostalCode,
            supplierTaxNO: state.supplierTaxNO,
            supplierTaxCRN: state.supplierTaxCRN,
            supplierOther: state.supplierOther,
            clientPostalCode: state.clientPostalCode,
            clientTaxNO: state.clientTaxNO,
            clientTaxCRN: state.clientTaxCRN,
            clientOther: state.clientOther,
            logoImageFile: logoImageFile,
            qrCodeImageFile: qrCodeImageFile,
            logoImageBytes: logoImageBytes,
            qrCodeImageBytes: qrCodeImageBytes,
          ));
          log('Image picked: ${file.path}');
        } else {
          log('No image selected.');
        }
      }
    } catch (e) {
      log('Error picking image: $e');
    }
  }

  Future<pw.Font> loadFont(String path) async {
    final fontData = await rootBundle.load(path);
    return pw.Font.ttf(fontData);
  }

  Future<void> generatePdf(BuildContext context) async {
    emit(PdfFormInitial(
      supplierName: state.supplierName,
      clientName: state.clientName,
      items: state.items,
      paymentMethod: state.paymentMethod,
      supplierAddress: state.supplierAddress,
      invoiceDate: state.invoiceDate,
      clientCountry: state.clientCountry,
      clientAddress: state.clientAddress,
      supplierCity: state.supplierCity,
      supplierCountry: state.supplierCountry,
      clientCity: state.clientCity,
      dueDate: state.dueDate,
      supplierPostalCode: state.supplierPostalCode,
      supplierTaxNO: state.supplierTaxNO,
      supplierTaxCRN: state.supplierTaxCRN,
      supplierOther: state.supplierOther,
      clientPostalCode: state.clientPostalCode,
      clientTaxNO: state.clientTaxNO,
      clientTaxCRN: state.clientTaxCRN,
      clientOther: state.clientOther,
      logoImageFile: logoImageFile,
      qrCodeImageFile: qrCodeImageFile,
      logoImageBytes: logoImageBytes,
      qrCodeImageBytes: qrCodeImageBytes,
    ));

    try {
      final pw.Document document = pw.Document();
      final pw.Font boldFont = await loadFont('assets/fonts/Cairo-Bold.ttf');
      final pw.Font regularFont =
          await loadFont('assets/fonts/Cairo-Regular.ttf');

      final pw.Font lightFont = await loadFont('assets/fonts/Cairo-Light.ttf');

      Map<String, pw.Font> fontWeightMap = {
        'boldFont': boldFont,
        'regularFont': regularFont,
        'lightFont': lightFont,
      };

      pw.MemoryImage? logoImage;
      pw.MemoryImage? qrCodeImage;

      if (logoImageBytes != null) {
        logoImage = pw.MemoryImage(logoImageBytes!);
      } else if (logoImageFile != null) {
        logoImage = pw.MemoryImage(await logoImageFile!.readAsBytes());
      }

      if (qrCodeImageBytes != null) {
        qrCodeImage = pw.MemoryImage(qrCodeImageBytes!);
      } else if (qrCodeImageFile != null) {
        qrCodeImage = pw.MemoryImage(await qrCodeImageFile!.readAsBytes());
      }
//dfasfadsf
      document.addPage(
        pw.MultiPage(
          build: (pw.Context context) => [
            pw.Column(
              children: [
                _buildHeader(fontWeightMap, logoImage, qrCodeImage),
                _dateSection(fontWeightMap),
                _buildClientSupplierInfo(fontWeightMap, state),
                infoWidget(fontWeightMap, 'statement', 'without_carton'),
                _buildInvoiceTable(fontWeightMap),
                _buildFooter(fontWeightMap),
              ],
            ),
          ],
          footer: (pw.Context context) {
            return _everyPageFooter(context, fontWeightMap);
          },
        ),
      );

      final List<int> bytes = await document.save();

      AnchorElement(
          href:
              "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
        ..setAttribute("download", "output.pdf")
        ..click();

      emit(PdfFormSuccess(
        filePath: kIsWeb
            ? 'Web generated PDF'
            : '${(await getApplicationDocumentsDirectory()).path}/output.pdf',
        supplierName: state.supplierName,
        clientName: state.clientName,
        items: state.items,
        paymentMethod: state.paymentMethod,
        supplierAddress: state.supplierAddress,
        invoiceDate: state.invoiceDate,
        clientCountry: state.clientCountry,
        clientAddress: state.clientAddress,
        supplierCity: state.supplierCity,
        supplierPostalCode: state.supplierPostalCode,
        supplierTaxNO: state.supplierTaxNO,
        supplierTaxCRN: state.supplierTaxCRN,
        supplierOther: state.supplierOther,
        clientPostalCode: state.clientPostalCode,
        clientTaxNO: state.clientTaxNO,
        clientTaxCRN: state.clientTaxCRN,
        clientOther: state.clientOther,
        supplierCountry: state.supplierCountry,
        clientCity: state.clientCity,
        dueDate: state.dueDate,
      ));

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PreviewScreen(doc: document),
          ),
        );
      }
    } catch (e) {
      emit(PdfFormFailure(
        message: 'Failed to generate PDF: $e',
        supplierName: state.supplierName,
        clientName: state.clientName,
        items: state.items,
        paymentMethod: state.paymentMethod,
        supplierAddress: state.supplierAddress,
        invoiceDate: state.invoiceDate,
        clientCountry: state.clientCountry,
        clientAddress: state.clientAddress,
        supplierCity: state.supplierCity,
        supplierPostalCode: state.supplierPostalCode,
        supplierTaxNO: state.supplierTaxNO,
        supplierTaxCRN: state.supplierTaxCRN,
        supplierOther: state.supplierOther,
        clientPostalCode: state.clientPostalCode,
        clientTaxNO: state.clientTaxNO,
        clientTaxCRN: state.clientTaxCRN,
        clientOther: state.clientOther,
        supplierCountry: state.supplierCountry,
        clientCity: state.clientCity,
        dueDate: state.dueDate,
      ));
    }
  }

  pw.Widget _dateSection(Map<String, pw.Font> font) {
    String? currentLocale = Get.locale?.languageCode;

    bool isRtl = currentLocale == 'ar';

    final rowList = [
      pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.Text('invoice_date'.tr,
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                color: PdfColor.fromHex('#819AA7'),
                font: font['regularFont'],
                letterSpacing: 0.5,
                fontSize: 10,
              )),
          pw.Text('24/7/2024 - 10:00:00 PM',
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                font: font['regularFont'],
                letterSpacing: 0.5,
                fontSize: 10,
              )),
        ],
      ),
      pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.Text('due_date'.tr,
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                color: PdfColor.fromHex('#819AA7'),
                font: font['regularFont'],
                letterSpacing: 0.5,
                fontSize: 10,
              )),
          pw.Text('28/7/2024',
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                font: font['regularFont'],
                letterSpacing: 0.5,
                fontSize: 10,
              )),
        ],
      ),
      pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        children: [
          pw.Text('payment_method'.tr,
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                color: PdfColor.fromHex('#819AA7'),
                font: font['regularFont'],
                letterSpacing: 0.5,
                fontSize: 10,
              )),
          pw.Text('cash'.tr,
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                font: font['regularFont'],
                letterSpacing: 0.5,
                fontSize: 10,
              )),
        ],
      ),
    ];

    final localizedRow = isRtl ? rowList.reversed.toList() : rowList;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
          children: localizedRow,
        ),
      ],
    );
  }

  pw.Widget infoWidget(Map<String, pw.Font> font, String label, String value) {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 8),
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.end,
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              label.tr,
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                font: font['regularFont'],
                fontSize: 9,
                color: PdfColor.fromHex('#819AA7'),
                letterSpacing: 0.5,
              ),
            ),
            pw.Text(
              value.tr,
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                font: font['regularFont'],
                fontSize: 10,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  pw.Widget _everyPageFooter(context, Map<String, pw.Font> font) {
    return pw.Container(
      color: PdfColor.fromHex('#f9f8f8'),
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            '${'page'.tr} ${context.pageNumber} ${'from'.tr} ${context.pagesCount}',
            textDirection: pw.TextDirection.rtl,
            style: pw.TextStyle(
              font: font['regularFont'],
              letterSpacing: 0.5,
              fontSize: 10,
              color: PdfColor.fromHex('#819AA7'),
            ),
          ),
          pw.Text(
            'all_rights_reserved'.tr,
            textDirection: pw.TextDirection.rtl,
            style: pw.TextStyle(
              font: font['regularFont'],
              letterSpacing: 0.5,
              fontSize: 10,
              color: PdfColor.fromHex('#819AA7'),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildHeader(Map<String, pw.Font> font, pw.MemoryImage? logoImage,
      pw.MemoryImage? qrCodeImage) {
    return pw.Container(
      color: const PdfColor.fromInt(0xFFEBF8FF),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Row(children: [
            if (qrCodeImage != null)
              pw.Image(qrCodeImage, width: 50, height: 50),
            pw.SizedBox(width: 10),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('tax_invoice'.tr,
                    style: pw.TextStyle(
                        font: font['boldFont'],
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold),
                    textDirection: pw.TextDirection.rtl),
                pw.Text('Tax Invoice',
                    style: pw.TextStyle(
                        font: font['regularFont'],
                        fontSize: 12,
                        fontWeight: pw.FontWeight.normal),
                    textDirection: pw.TextDirection.rtl),
                pw.Text(
                  '12411648899',
                  style: pw.TextStyle(
                      font: font['regularFont'],
                      fontSize: 9,
                      fontWeight: pw.FontWeight.normal),
                  textDirection: pw.TextDirection.rtl,
                ),
              ],
            ),
          ]),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('شركة قصر الاواني',
                        style: pw.TextStyle(
                            font: font['boldFont'],
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold),
                        textDirection: pw.TextDirection.rtl),
                    pw.Text('3761 طريق مكة المكرمة الفرعي',
                        style: pw.TextStyle(
                            font: font['regularFont'],
                            fontSize: 9,
                            fontWeight: pw.FontWeight.normal),
                        textDirection: pw.TextDirection.rtl),
                    pw.Text(
                      'حي المعذر - المملكة العربية السعودية',
                      style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 9,
                          fontWeight: pw.FontWeight.normal),
                      textDirection: pw.TextDirection.rtl,
                    ),
                  ],
                ),
                pw.SizedBox(width: 10),
                if (logoImage != null)
                  pw.Image(logoImage, width: 50, height: 50),
              ]),
        ],
      ),
    );
  }

  pw.Widget _buildClientSupplierInfo(
      Map<String, pw.Font> font, PdfFormState state) {
    String? currentLocale = Get.locale?.languageCode;

    final suplierBox = pw.Expanded(
      child: pw.Container(
        decoration: const pw.BoxDecoration(
          color: PdfColor.fromInt(0xFFF9F9F9),
          borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
        ),
        padding: const pw.EdgeInsets.all(10),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              'supplier_info'.tr,
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                font: font['regularFont'],
                letterSpacing: 0.5,
                fontSize: 12,
                color: const PdfColor.fromInt(0xFFFF0000),
              ),
            ),
            pw.Divider(color: PdfColor.fromHex('#e3e2e3')),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        '${state.supplierName}',
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        '${state.supplierAddress}',
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        '${state.supplierCity}',
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        '${state.supplierCountry}',
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        '${state.supplierPostalCode}',
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        '${state.supplierTaxNO}',
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        '${state.supplierTaxCRN}',
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        '${state.supplierOther}',
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'name'.tr,
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        'address'.tr,
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        'city'.tr,
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        'country'.tr,
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        'postal_code'.tr,
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        'tax_no'.tr,
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        'tax_crn'.tr,
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        'other'.tr,
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    final clientBox = pw.Expanded(
      child: pw.Container(
        decoration: const pw.BoxDecoration(
          color: PdfColor.fromInt(0xFFF9F9F9),
          borderRadius: pw.BorderRadius.all(pw.Radius.circular(8)),
        ),
        padding: const pw.EdgeInsets.all(10),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              'client'.tr,
              textDirection: pw.TextDirection.rtl,
              style: pw.TextStyle(
                font: font['regularFont'],
                fontSize: 12,
                color: const PdfColor.fromInt(0xFFFF0000),
              ),
            ),
            pw.Divider(color: PdfColor.fromHex('#e3e2e3')),
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        '${state.clientName}',
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        '${state.clientAddress}',
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        '${state.clientCity}',
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        '${state.clientCountry}',
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        '${state.clientPostalCode}',
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        '${state.clientTaxNO}',
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        '${state.clientTaxCRN}',
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        '${state.clientOther}',
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'name'.tr,
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        'address'.tr,
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        'city'.tr,
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        'country'.tr,
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        'postal_code'.tr,
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        'tax_no'.tr,
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        'tax_crn'.tr,
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                      pw.Text(
                        'other'.tr,
                        style: pw.TextStyle(
                          font: font['regularFont'],
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                        textDirection: pw.TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: currentLocale == 'ar'
            ? [
                clientBox,
                pw.SizedBox(width: 20),
                suplierBox,
              ]
            : [
                suplierBox,
                pw.SizedBox(width: 20),
                clientBox,
              ],
      ),
    );
  }

  pw.Widget _buildInvoiceTable(Map<String, pw.Font> font) {
    String? currentLocale = Get.locale?.languageCode;
    bool isRtl = currentLocale == 'ar';

    // Define headers and data in common order
    final headers = [
      'item'.tr,
      'category_name'.tr,
      'unit'.tr,
      'quantity'.tr,
      'free_quantity'.tr,
      'price'.tr,
      'vat'.tr,
      'total'.tr,
    ];

    final data = state.items
        .map((item) => [
              (state.items.indexOf(item) + 1).toString(),
              item.description,
              item.unit,
              item.quantity.toString(),
              '0',
              item.quantity.toStringAsFixed(2),
              item.quantity.toString(),
              item.quantity.toStringAsFixed(2),
            ])
        .toList();

    // Reverse headers and data if RTL
    final reversedHeaders = isRtl ? headers.reversed.toList() : headers;
    final reversedData =
        isRtl ? data.map((row) => row.reversed.toList()).toList() : data;

    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      child: pw.TableHelper.fromTextArray(
        headers: reversedHeaders,
        data: reversedData,
        headerDirection: pw.TextDirection.rtl,
        tableDirection:pw.TextDirection.rtl,
        headerStyle: pw.TextStyle(
            font: font['regularFont'],
            fontWeight: pw.FontWeight.bold,
            fontSize: 9,
            color: const PdfColor(1, 1, 1)),
        headerDecoration: const pw.BoxDecoration(
            color: PdfColor(220 / 255, 41 / 255, 47 / 255)),
        cellAlignment: isRtl ? pw.Alignment.centerRight : pw.Alignment.center,
        border: const pw.TableBorder(
          horizontalInside: pw.BorderSide(color: PdfColors.white),
          verticalInside: pw.BorderSide(color: PdfColors.white),
        ),
        cellStyle: pw.TextStyle(font: font['regularFont'], fontSize: 9,),
        
        cellDecoration: (index, data, rowNum) {
          return pw.BoxDecoration(
            color: (rowNum % 2 == 0)
                ? PdfColors.white
                : const PdfColor.fromInt(0xFFF9F9F9),
            border: pw.TableBorder(
              horizontalInside: pw.BorderSide(
                color: (rowNum % 2 == 0)
                    ? PdfColors.white
                    : const PdfColor.fromInt(0xFFF9F9F9),
              ),
              verticalInside: pw.BorderSide(
                color: (rowNum % 2 == 0)
                    ? PdfColors.white
                    : const PdfColor.fromInt(0xFFF9F9F9),
              ),
            ),
          );
        },
        cellHeight: 20,
      ),
    );
  }

  pw.Widget _buildFooter(Map<String, pw.Font> font) {
    return pw.Row(
      children: [
        pw.Expanded(
          child: pw.Container(
            padding: const pw.EdgeInsets.all(10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('total_amount'.tr,
                    style: pw.TextStyle(
                      font: font['regularFont'],
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                    textDirection: pw.TextDirection.rtl),
                pw.Container(
                  width: 150, // Set the desired width here
                  child: pw.Divider(
                    color: PdfColor.fromHex('#e3e2e3'),
                    height: 1, // Set the thickness of the divider
                  ),
                ),
                pw.Text('discount'.tr,
                    style: pw.TextStyle(
                      font: font['regularFont'],
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                    textDirection: pw.TextDirection.rtl),
                pw.Container(
                  width: 150, // Set the desired width here
                  child: pw.Divider(
                    color: PdfColor.fromHex('#e3e2e3'),
                    height: 1, // Set the thickness of the divider
                  ),
                ),
                pw.Text('tax_total'.tr,
                    style: pw.TextStyle(
                      font: font['regularFont'],
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                    textDirection: pw.TextDirection.rtl),
                pw.Container(
                  width: 150, // Set the desired width here
                  child: pw.Divider(
                    color: PdfColor.fromHex('#e3e2e3'),
                    height: 1, // Set the thickness of the divider
                  ),
                ),
                pw.Text('burden_total'.tr,
                    style: pw.TextStyle(
                      font: font['regularFont'],
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                    textDirection: pw.TextDirection.rtl),
                pw.Container(
                  width: 150, // Set the desired width here
                  child: pw.Divider(
                    color: PdfColor.fromHex('#e3e2e3'),
                    height: 1, // Set the thickness of the divider
                  ),
                ),
                pw.Text('total_with_tax'.tr,
                    style: pw.TextStyle(
                      font: font['regularFont'],
                      fontSize: 10,
                      letterSpacing: 0.5,
                    ),
                    textDirection: pw.TextDirection.rtl),
                pw.SizedBox(height: 10),
                pw.Container(
                  decoration: pw.BoxDecoration(
                    border: pw.Border(
                      top: pw.BorderSide(
                          color: PdfColor.fromHex('#d0021b'), width: 1),
                      bottom: pw.BorderSide(
                          color: PdfColor.fromHex('#d0021b'), width: 1),
                    ),
                  ),
                  padding: const pw.EdgeInsets.symmetric(vertical: 5),
                  alignment: pw.Alignment.center,
                  child: pw.Text(
                    'one_hundred_and_five_sar_only'.tr,
                    style: pw.TextStyle(
                        font: font['regularFont'],
                        fontSize: 10,
                        letterSpacing: 0.5,
                        color: PdfColor.fromHex('#d0021b')),
                    textDirection: pw.TextDirection.rtl,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
