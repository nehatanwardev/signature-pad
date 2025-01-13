import 'package:flutter/material.dart';

class PenWidthDropdown extends StatelessWidget {
  final double penWidth;
  final ValueChanged<double?> onChanged;

  PenWidthDropdown({
    required this.penWidth,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.17,
      padding: EdgeInsets.symmetric(horizontal: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: DropdownButton<double>(
        value: penWidth,
        isDense: true,
        isExpanded: true,
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black,
        ),
        iconSize: 30,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        onChanged: onChanged,
        underline: SizedBox(),
        items: [5.0, 10.0, 15.0, 20.0, 25.0]
            .map((width) => DropdownMenuItem(
                  value: width,
                  child: Row(
                    children: [
                      Text(
                        '${width.toInt()} px',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}
