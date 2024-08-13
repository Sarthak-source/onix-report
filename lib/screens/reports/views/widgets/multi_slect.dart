import 'package:flutter/material.dart';

// Custom multi-select dropdown widget
class MultiSelectDropdown extends StatefulWidget {
  final List<String> options;
  final List<String> selectedValues;
  final String label;
  final Function(List<String>) onChanged;

  const MultiSelectDropdown({
    super.key,
    required this.options,
    required this.selectedValues,
    required this.label,
    required this.onChanged,
  });

  @override
  State<MultiSelectDropdown> createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  hintText: widget.label,
                  hintStyle: const TextStyle(color: Colors.black87),
                  prefixIcon: const Icon(Icons.list, color: Colors.black87),
                  filled: true,
                  fillColor: const Color.fromARGB(255, 252, 237, 255),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Colors.purpleAccent,
                      width: 1.5,
                    ),
                  ),
                ),
                child: Wrap(
                  spacing: 8.0,
                  children: widget.selectedValues.map((value) {
                    return Chip(
                      label: Text(value),
                      backgroundColor: Colors.purpleAccent,
                      onDeleted: () {
                        setState(() {
                          widget.selectedValues.remove(value);
                          widget.onChanged(List.from(widget.selectedValues));
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
            ),
            if (_isExpanded)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 252, 237, 255),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.purpleAccent),
                ),
                child: Column(
                  children: widget.options.map((option) {
                    return CheckboxListTile(
                      title: Text(option),
                      value: widget.selectedValues.contains(option),
                      onChanged: (bool? checked) {
                        setState(() {
                          if (checked != null) {
                            if (checked) {
                              widget.selectedValues.add(option);
                            } else {
                              widget.selectedValues.remove(option);
                            }
                            widget.onChanged(List.from(widget.selectedValues));
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
