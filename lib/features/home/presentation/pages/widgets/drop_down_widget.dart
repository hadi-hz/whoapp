import 'package:flutter/material.dart';
import 'package:test3/core/const/const.dart';

class DropdownFilter extends StatelessWidget {
  final String hint;
  final int? selectedValue;
  final List<Map<String, dynamic>> items;
  final Function(int?) onChanged;
  final double? width;

  const DropdownFilter({
    super.key,
    required this.hint,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? MediaQuery.sizeOf(context).width * 0.4,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int?>(
          isExpanded: true,
          hint: Text(
            hint,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          value: selectedValue,
          icon: const Icon(Icons.keyboard_arrow_down, size: 20),
          onChanged: onChanged,
          items: items.map((item) {
            return DropdownMenuItem<int?>(
              value: item['value'],
              child: Text(
                
                item['label']?.toString() ?? item['name']?.toString() ?? 'Unknown',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}