import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart'; // Import GetX for localization

import '../../../core/widgets/localizations.dart';
import '../cubit/reports_cubit.dart';
import '../cubit/reports_state.dart';
import '../data/model/reports.dart';
import 'widgets/multi_slect.dart';

class PdfFormWidget extends StatefulWidget {
  const PdfFormWidget({super.key});

  @override
  PdfFormWidgetState createState() => PdfFormWidgetState();
}

class PdfFormWidgetState extends State<PdfFormWidget> {
  final _formKey = GlobalKey<FormState>();

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

  Future<void> _selectDate(
    BuildContext context,
    TextEditingController controller,
    Function(String) onChanged,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        log("${picked.toLocal()}".split(' ')[0]);
        controller.text = "${picked.toLocal()}".split(' ')[0];
        onChanged("${picked.toLocal()}".split(' ')[0]);
      });
    }
  }

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  String? validateField(
      String? value, bool Function(String?) condition, String errorMessageKey) {
    if (condition(value)) {
      return errorMessageKey.tr; // Return the localized error message
    }
    return null; // No error, return null
  }

  Widget buildTextFormField(
      TextEditingController controller,
      String key,
      bool isNumericField,
      String? Function(String?)? validator,
      Function(String) onChanged,
      {bool isDateField = false,
      List<TextInputFormatter>? inputFormatters}) {
    // Added inputFormatters parameter
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: GestureDetector(
            onTap: isDateField
                ? () => _selectDate(context, controller, onChanged)
                : null,
            child: AbsorbPointer(
              absorbing: isDateField,
              child: TextFormField(
                textAlign: TextAlign.center,
                controller: controller,
                keyboardType:
                    isNumericField ? TextInputType.number : TextInputType.text,
                inputFormatters: inputFormatters, // Use inputFormatters here
                decoration: InputDecoration(
                  labelText: key.tr,
                  filled: true,
                  fillColor: const Color.fromARGB(255, 252, 237, 255),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.purpleAccent,
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1.0,
                    ),
                  ),
                ),
                validator: validator,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDropdownFormField(
    TextEditingController controller,
    String key,
    List<String> options, // List of dropdown options
    String? Function(String?)? validator,
    Function(String?) onChanged,
  ) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: DropdownButtonFormField<String>(
            value: controller.text.isEmpty ? null : controller.text,
            decoration: InputDecoration(
              labelText: key.tr,
              filled: true,
              fillColor: const Color.fromARGB(255, 252, 237, 255),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                  color: Colors.purpleAccent,
                  width: 1.5,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 1.0,
                ),
              ),
            ),
            items: options.map((String option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option.tr),
              );
            }).toList(),
            validator: validator,
            onChanged: (String? newValue) {
              setState(() {
                controller.text = newValue ?? '';
              });
              onChanged(newValue);
            },
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
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  buildRow([
                    buildTextFormField(
                      _supplierNameController,
                      'supplier_name',
                      false,
                      (value) => validateField(value,
                          (v) => v == null || v.isEmpty, "field_required".tr),
                      (value) {
                        context
                            .read<PdfFormCubit>()
                            .updateForm(supplierName: value);
                      },
                    ),
                    buildTextFormField(
                        _clientNameController,
                        'client_name', // Use key for localization
                        false,
                        (value) => validateField(value,
                            (v) => v == null || v.isEmpty, "field_required".tr),
                        (value) => context
                            .read<PdfFormCubit>()
                            .updateForm(clientName: value)),
                    buildTextFormField(
                        _supplierAddressController,
                        'supplier_address', // Use key for localization
                        false,
                        (value) => validateField(value,
                            (v) => v == null || v.isEmpty, "field_required".tr),
                        (value) => context
                            .read<PdfFormCubit>()
                            .updateForm(supplierAddress: value)),
                  ]),
                  buildRow([
                    buildTextFormField(
                        _supplierCityController,
                        'supplier_city', // Use key for localization
                        false,
                        (value) => validateField(value,
                            (v) => v == null || v.isEmpty, "field_required".tr),
                        (value) => context
                            .read<PdfFormCubit>()
                            .updateForm(supplierCity: value)),
                    buildDropdownFormField(
                        _supplierCountryController,
                        'supplier_country', // Use key for localization
                        [
                          "united_states".tr,
                          "canada".tr,
                          "united_kingdom".tr,
                          "australia".tr,
                          "germany".tr,
                          "france".tr,
                          "italy".tr,
                          "spain".tr,
                          "china".tr,
                          "japan".tr,
                          "south_korea".tr,
                          "india".tr,
                          "brazil".tr,
                          "mexico".tr,
                          "south_africa".tr,
                          "saudi_arabia".tr,
                          "egypt".tr,
                          "united_arab_emirates".tr,
                        ],
                        (value) => validateField(value,
                            (v) => v == null || v.isEmpty, "field_required".tr),
                        (value) => context
                            .read<PdfFormCubit>()
                            .updateForm(supplierCountry: value)),
                    buildTextFormField(
                        _supplierPostalCodeController,
                        'supplier_postal_code', // Use key for localization
                        false,
                        (value) => validateField(value,
                            (v) => v == null || v.isEmpty, "field_required".tr),
                        (value) => context
                            .read<PdfFormCubit>()
                            .updateForm(supplierPostalCode: value),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ]),
                  ]),
                  buildRow([
                    buildTextFormField(
                        _supplierTaxNoController,
                        'supplier_tax_no', // Use key for localization
                        false,
                        (value) => validateField(value,
                            (v) => v == null || v.isEmpty, "field_required".tr),
                        (value) => context
                            .read<PdfFormCubit>()
                            .updateForm(supplierTaxNo: value),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ]),
                    buildTextFormField(
                        _supplierTaxCrnController,
                        'supplier_tax_crn', // Use key for localization
                        false,
                        (value) => validateField(value,
                            (v) => v == null || v.isEmpty, "field_required".tr),
                        (value) => context
                            .read<PdfFormCubit>()
                            .updateForm(supplierTaxCrn: value),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ]),
                    buildTextFormField(
                        _supplierOtherController,
                        'supplier_other', // Use key for localization
                        false,
                        (value) => validateField(value,
                            (v) => v == null || v.isEmpty, "field_required".tr),
                        (value) => context
                            .read<PdfFormCubit>()
                            .updateForm(supplierOther: value)),
                  ]),
                  buildRow([
                    buildTextFormField(
                        _clientAddressController,
                        'client_address', // Use key for localization
                        false,
                        (value) => validateField(value,
                            (v) => v == null || v.isEmpty, "field_required".tr),
                        (value) => context
                            .read<PdfFormCubit>()
                            .updateForm(clientAddress: value)),
                    buildTextFormField(
                        _clientCityController,
                        'client_city', // Use key for localization
                        false,
                        (value) => validateField(value,
                            (v) => v == null || v.isEmpty, "field_required".tr),
                        (value) => context
                            .read<PdfFormCubit>()
                            .updateForm(clientCity: value)),
                    buildDropdownFormField(
                        _clientCountryController,
                        'client_country', // Use key for localization
                        [
                          "united_states".tr,
                          "canada".tr,
                          "united_kingdom".tr,
                          "australia".tr,
                          "germany".tr,
                          "france".tr,
                          "italy".tr,
                          "spain".tr,
                          "china".tr,
                          "japan".tr,
                          "south_korea".tr,
                          "india".tr,
                          "brazil".tr,
                          "mexico".tr,
                          "south_africa".tr,
                          "saudi_arabia".tr,
                          "egypt".tr,
                          "united_arab_emirates".tr,
                        ],
                        (value) => validateField(value,
                            (v) => v == null || v.isEmpty, "field_required".tr),
                        (value) => context
                            .read<PdfFormCubit>()
                            .updateForm(clientCountry: value)),
                  ]),
                  buildRow([
                    buildTextFormField(
                        _clientPostalCodeController,
                        'client_postal_code', // Use key for localization
                        false,
                        (value) => validateField(value,
                            (v) => v == null || v.isEmpty, "field_required".tr),
                        (value) => context
                            .read<PdfFormCubit>()
                            .updateForm(clientPostalCode: value),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ]),
                    buildTextFormField(
                        _clientTaxNoController,
                        'client_tax_no', // Use key for localization
                        false,
                        (value) => validateField(value,
                            (v) => v == null || v.isEmpty, "field_required".tr),
                        (value) => context
                            .read<PdfFormCubit>()
                            .updateForm(clientTaxNo: value),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ]),
                    buildTextFormField(
                        _clientTaxCrnController,
                        'client_tax_crn', // Use key for localization
                        false,
                        (value) => validateField(value,
                            (v) => v == null || v.isEmpty, "field_required".tr),
                        (value) => context
                            .read<PdfFormCubit>()
                            .updateForm(clientTaxCrn: value),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ]),
                  ]),
                  buildRow([
                    buildTextFormField(
                        _clientOtherController,
                        'client_other', // Use key for localization
                        false,
                        (value) => validateField(value,
                            (v) => v == null || v.isEmpty, "field_required".tr),
                        (value) => context
                            .read<PdfFormCubit>()
                            .updateForm(clientOther: value)),
                    buildTextFormField(
                        isDateField: true,
                        _invoiceDateController,
                        'invoice_date', // Use key for localization
                        false,
                        (value) => validateField(value,
                            (v) => v == null || v.isEmpty, "field_required".tr),
                        (value) => context
                            .read<PdfFormCubit>()
                            .updateForm(invoiceDate: value)),
                    buildTextFormField(
                        isDateField: true,
                        _dueDateController,
                        'due_date', // Use key for localization
                        false,
                        (value) => validateField(value,
                            (v) => v == null || v.isEmpty, "field_required".tr),
                        (value) => context
                            .read<PdfFormCubit>()
                            .updateForm(dueDate: value)),
                  ]),
                  buildRow([
                    MultiSelectDropdown(
                      options: [
                        "cash".tr,
                        "bank".tr,
                        "installments".tr,
                        "account".tr,
                        "coupons".tr,
                        "points".tr,
                      ],
                      // Convert comma-separated string to list
                      // Label for the field
                      selectedValues: state.paymentMethod!.split(', ').toList(),

                      label: 'payment_method'.tr,
                      onChanged: (selectedString) {
                        context.read<PdfFormCubit>().updateForm(
                            paymentMethod: selectedString.join(', '));
                      },
                    ),
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
                                  buildTextFormField(
                                      _unitController,
                                      'unit', // Use key for localization
                                      false,
                                      (value) => validateField(
                                          value,
                                          (v) => v == null || v.isEmpty,
                                          "field_required".tr),
                                      (value) {}),
                                  buildTextFormField(
                                      _quantityController,
                                      'quantity', // Use key for localization
                                      false,
                                      (value) => validateField(
                                          value,
                                          (v) => v == null || v.isEmpty,
                                          "field_required".tr),
                                      (value) {},
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ]),
                                  buildTextFormField(
                                      _priceController,
                                      'price', // Use key for localization
                                      false,
                                      (value) => validateField(
                                          value,
                                          (v) => v == null || v.isEmpty,
                                          "field_required".tr),
                                      (value) {},
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ]),
                                ]),
                                buildRow([
                                  buildTextFormField(
                                      _vatController,
                                      'vat', // Use key for localization
                                      false,
                                      (value) => validateField(
                                          value,
                                          (v) => v == null || v.isEmpty,
                                          "field_required".tr),
                                      (value) {},
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly
                                      ]),
                                  buildTextFormField(
                                      _descriptionController,
                                      'description', // Use key for localization
                                      false,
                                      (value) => validateField(
                                          value,
                                          (v) => v == null || v.isEmpty,
                                          "field_required".tr),
                                      (value) {}),
                                ]),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    final item = InvoiceItem(
                                      description: _descriptionController.text,
                                      unit: _unitController.text,
                                      quantity:
                                          int.parse(_quantityController.text),
                                      price:
                                          double.parse(_priceController.text),
                                      vat: double.parse(_vatController.text),
                                    );
                                    context.read<PdfFormCubit>().addItem(item);
                                  },
                                  child: Text('add_items'
                                      .tr), // Use key.tr for button text
                                ),
                                const SizedBox(height: 12),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          child: DataTable(
                            columnSpacing: (Get.width / 500) * 0.01,
                            columns: [
                              DataColumn(
                                  label: Text(
                                'description'.tr,
                              )),
                              DataColumn(label: Text('unit'.tr)),
                              DataColumn(label: Text('quantity'.tr)),
                              DataColumn(label: Text('price'.tr)),
                              DataColumn(label: Text('vat'.tr)),
                              DataColumn(
                                  label: Text('total'
                                      .tr)), // Total column might need to be added in localization
                            ],
                            rows: state.items.map((item) {
                              final total = item.price *
                                  item.quantity *
                                  (1 + item.vat / 100);
                              return DataRow(cells: [
                                DataCell(
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      item.description,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                DataCell(Text(
                                  item.unit,
                                  textAlign: TextAlign.center,
                                )),
                                DataCell(
                                  Text(
                                    item.quantity.toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                DataCell(Text(
                                  item.price.toStringAsFixed(2),
                                  textAlign: TextAlign.center,
                                )),
                                DataCell(Text(
                                  item.vat.toStringAsFixed(2),
                                  textAlign: TextAlign.center,
                                )),
                                DataCell(Text(
                                  total.toStringAsFixed(2),
                                  textAlign: TextAlign.center,
                                )),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (kIsWeb) ...[
                    if (state.logoImageBytes != null)
                      Image.memory(state.logoImageBytes!,
                          height: 30, width: 30),
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
                        onPressed: () => context
                            .read<PdfFormCubit>()
                            .pickImage(isLogo: true),
                        child: Text(
                            'pick_logo_image'.tr), // Use key.tr for button text
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () => context
                            .read<PdfFormCubit>()
                            .pickImage(isLogo: false),
                        child: Text('pick_qr_code_image'
                            .tr), // Use key.tr for button text
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await context.read<PdfFormCubit>().generatePdf(context);
                      } else {
                        Get.showSnackbar(
                          const GetSnackBar(
                            title: 'Fill all Fields', // Optional: Add a title
                            message: 'Please fill all required field',
                            duration: Duration(
                                seconds:
                                    3), // Duration the snackbar will be displayed
                          ),
                        );
                      }
                    },
                    child:
                        Text('generate_pdf'.tr), // Use key.tr for button text
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
