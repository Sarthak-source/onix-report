import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart'; // Import GetX for localization

import '../../../core/widgets/localizations.dart';
import '../cubit/reports_cubit.dart';
import '../cubit/reports_state.dart';
import '../data/model/reports.dart';

class PdfFormWidget extends StatefulWidget {
  const PdfFormWidget({super.key});

  @override
  PdfFormWidgetState createState() => PdfFormWidgetState();
}

class PdfFormWidgetState extends State<PdfFormWidget> {
  final _supplierNameController = TextEditingController();
  final _clientNameController = TextEditingController();
  final _supplierAddressController = TextEditingController();
  final _supplierCityController = TextEditingController();
  final _supplierCountryController = TextEditingController();
  final _clientAddressController = TextEditingController();
  final _clientCityController = TextEditingController();
  final _clientCountryController = TextEditingController();
  final _invoiceDateController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _paymentMethodController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _unitController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _vatController = TextEditingController();

  // New controllers for additional fields
  final _supplierPostalCodeController = TextEditingController();
  final _supplierTaxNoController = TextEditingController();
  final _supplierTaxCrnController = TextEditingController();
  final _supplierOtherController = TextEditingController();
  final _clientPostalCodeController = TextEditingController();
  final _clientTaxNoController = TextEditingController();
  final _clientTaxCrnController = TextEditingController();
  final _clientOtherController = TextEditingController();

  @override
  void dispose() {
    _supplierNameController.dispose();
    _clientNameController.dispose();
    _supplierAddressController.dispose();
    _supplierCityController.dispose();
    _supplierCountryController.dispose();
    _clientAddressController.dispose();
    _clientCityController.dispose();
    _clientCountryController.dispose();
    _invoiceDateController.dispose();
    _dueDateController.dispose();
    _paymentMethodController.dispose();
    _descriptionController.dispose();
    _unitController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _vatController.dispose();
    // Dispose new controllers
    _supplierPostalCodeController.dispose();
    _supplierTaxNoController.dispose();
    _supplierTaxCrnController.dispose();
    _supplierOtherController.dispose();
    _clientPostalCodeController.dispose();
    _clientTaxNoController.dispose();
    _clientTaxCrnController.dispose();
    _clientOtherController.dispose();
    super.dispose();
  }

  Widget buildTextField(TextEditingController controller, String key,
      Function(String) onChanged) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0), // Add padding as needed
        child: Center(
          child: TextField(

            textAlign: TextAlign.center,
            controller: controller,
            decoration: InputDecoration(

              labelText: key.tr, // Use key.tr for localization
              filled: true,
              fillColor: const Color.fromARGB(
                  255, 252, 237, 255), // Lighter background color
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0), // Rounded border
                borderSide: BorderSide.none, // No border line
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    12.0), // Rounded border for focused state
                borderSide: const BorderSide(
                  color: Colors.purpleAccent, // Border color when focused
                  width: 1.5, // Border width when focused
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                    12.0), // Rounded border for enabled state
                borderSide: const BorderSide(
                  color: Colors.transparent, // Border color when enabled
                  width: 1.0, // Border width when enabled
                ),
              ),
            ),
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }

  Widget buildRow(List<Widget> children) {
    return Row(
      children: [
        for (var i = 0; i < children.length; i++) ...[
          children[i],
          if (i < children.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PdfFormCubit, PdfFormState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('pdf_form_title'.tr), // Use key.tr for app bar title
            centerTitle: false,
            actions: const [LanguageMenu()],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                buildRow([
                  buildTextField(
                      _supplierNameController,
                      'supplier_name', // Use key for localization
                      (value) => context
                          .read<PdfFormCubit>()
                          .updateForm(supplierName: value)),
                  buildTextField(
                      _clientNameController,
                      'client_name', // Use key for localization
                      (value) => context
                          .read<PdfFormCubit>()
                          .updateForm(clientName: value)),
                  buildTextField(
                      _supplierAddressController,
                      'supplier_address', // Use key for localization
                      (value) => context
                          .read<PdfFormCubit>()
                          .updateForm(supplierAddress: value)),
                ]),
                buildRow([
                  buildTextField(
                      _supplierCityController,
                      'supplier_city', // Use key for localization
                      (value) => context
                          .read<PdfFormCubit>()
                          .updateForm(supplierCity: value)),
                  buildTextField(
                      _supplierCountryController,
                      'supplier_country', // Use key for localization
                      (value) => context
                          .read<PdfFormCubit>()
                          .updateForm(supplierCountry: value)),
                  buildTextField(
                      _supplierPostalCodeController,
                      'supplier_postal_code', // Use key for localization
                      (value) => context
                          .read<PdfFormCubit>()
                          .updateForm(supplierPostalCode: value)),
                ]),
                buildRow([
                  buildTextField(
                      _supplierTaxNoController,
                      'supplier_tax_no', // Use key for localization
                      (value) => context
                          .read<PdfFormCubit>()
                          .updateForm(supplierTaxNo: value)),
                  buildTextField(
                      _supplierTaxCrnController,
                      'supplier_tax_crn', // Use key for localization
                      (value) => context
                          .read<PdfFormCubit>()
                          .updateForm(supplierTaxCrn: value)),
                  buildTextField(
                      _supplierOtherController,
                      'supplier_other', // Use key for localization
                      (value) => context
                          .read<PdfFormCubit>()
                          .updateForm(supplierOther: value)),
                ]),
                buildRow([
                  buildTextField(
                      _clientAddressController,
                      'client_address', // Use key for localization
                      (value) => context
                          .read<PdfFormCubit>()
                          .updateForm(clientAddress: value)),
                  buildTextField(
                      _clientCityController,
                      'client_city', // Use key for localization
                      (value) => context
                          .read<PdfFormCubit>()
                          .updateForm(clientCity: value)),
                  buildTextField(
                      _clientCountryController,
                      'client_country', // Use key for localization
                      (value) => context
                          .read<PdfFormCubit>()
                          .updateForm(clientCountry: value)),
                ]),
                buildRow([
                  buildTextField(
                      _clientPostalCodeController,
                      'client_postal_code', // Use key for localization
                      (value) => context
                          .read<PdfFormCubit>()
                          .updateForm(clientPostalCode: value)),
                  buildTextField(
                      _clientTaxNoController,
                      'client_tax_no', // Use key for localization
                      (value) => context
                          .read<PdfFormCubit>()
                          .updateForm(clientTaxNo: value)),
                  buildTextField(
                      _clientTaxCrnController,
                      'client_tax_crn', // Use key for localization
                      (value) => context
                          .read<PdfFormCubit>()
                          .updateForm(clientTaxCrn: value)),
                ]),
                buildRow([
                  buildTextField(
                      _clientOtherController,
                      'client_other', // Use key for localization
                      (value) => context
                          .read<PdfFormCubit>()
                          .updateForm(clientOther: value)),
                  buildTextField(
                      _invoiceDateController,
                      'invoice_date', // Use key for localization
                      (value) => context
                          .read<PdfFormCubit>()
                          .updateForm(invoiceDate: value)),
                  buildTextField(
                      _dueDateController,
                      'due_date', // Use key for localization
                      (value) => context
                          .read<PdfFormCubit>()
                          .updateForm(dueDate: value)),
                ]),
                buildRow([
                  buildTextField(
                      _paymentMethodController,
                      'payment_method', // Use key for localization
                      (value) => context
                          .read<PdfFormCubit>()
                          .updateForm(paymentMethod: value)),
                ]),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            children: [
                              buildRow([
                                buildTextField(
                                    _unitController,
                                    'unit', // Use key for localization
                                    (value) {}),
                                buildTextField(
                                    _quantityController,
                                    'quantity', // Use key for localization
                                    (value) {}),
                                buildTextField(
                                    _priceController,
                                    'price', // Use key for localization
                                    (value) {}),
                              ]),
                              buildRow([
                                buildTextField(
                                    _vatController,
                                    'vat', // Use key for localization
                                    (value) {}),
                                buildTextField(
                                    _descriptionController,
                                    'description', // Use key for localization
                                    (value) {}),
                              ]),
                              const SizedBox(height: 12),
                              ElevatedButton(
                                onPressed: () {
                                  final item = InvoiceItem(
                                    description: _descriptionController.text,
                                    unit: _unitController.text,
                                    quantity: int.parse(_quantityController.text),
                                    price: double.parse(_priceController.text),
                                    vat: double.parse(_vatController.text),
                                  );
                                  context.read<PdfFormCubit>().addItem(item);
                                },
                                child: Text('add_items'.tr), // Use key.tr for button text
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child:  DataTable(
                          columnSpacing:(Get.width/500)*0.01,
                            
                            columns: [
                              DataColumn(

                                  label: Text('description'.tr,)),
                              DataColumn(label: Text('unit'.tr)),
                              DataColumn(label: Text('quantity'.tr)),
                              DataColumn(label: Text('price'.tr)),
                              DataColumn(label: Text('vat'.tr)),
                              DataColumn(label: Text('total'.tr)), // Total column might need to be added in localization
                            ],
                            rows: state.items.map((item) {
                              final total = item.price *
                                  item.quantity *
                                  (1 + item.vat / 100);
                              return DataRow(


                                  cells: [
                                DataCell(


                                    Text(item.description,textAlign: TextAlign.center,),),
                                DataCell(Text(item.unit,textAlign: TextAlign.center,)),
                                DataCell(Text(item.quantity.toString(),textAlign: TextAlign.center,),),
                                DataCell(Text(item.price.toStringAsFixed(2),textAlign: TextAlign.center,)),
                                DataCell(Text(item.vat.toStringAsFixed(2),textAlign: TextAlign.center,)),
                                DataCell(Text(total.toStringAsFixed(2),textAlign: TextAlign.center,)),
                              ]);
                            }).toList(),
                          ),
                        ),
                      
                    ),
                  ],
                ),
                if (kIsWeb) ...[
                  if (state.logoImageBytes != null)
                    Image.memory(state.logoImageBytes!, height: 30, width: 30),
                  if (state.qrCodeImageBytes != null)
                    Image.memory(state.qrCodeImageBytes!,
                        height: 30, width: 30),
                ] else ...[
                  if (state.logoImageFile != null)
                    Image.file(state.logoImageFile!, height: 30, width: 30),
                  if (state.qrCodeImageFile != null)
                    Image.file(state.qrCodeImageFile!, height: 30, width: 30),
                ],
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () =>
                          context.read<PdfFormCubit>().pickImage(isLogo: true),
                      child: Text('pick_logo_image'.tr), // Use key.tr for button text
                    ),
                    const SizedBox(width: 10,),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<PdfFormCubit>().pickImage(isLogo: false),
                      child: Text('pick_qr_code_image'.tr), // Use key.tr for button text
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await context.read<PdfFormCubit>().generatePdf(context);
                  },
                  child: Text('generate_pdf'.tr), // Use key.tr for button text
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
