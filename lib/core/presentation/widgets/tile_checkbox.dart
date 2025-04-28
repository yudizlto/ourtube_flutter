import 'package:flutter/material.dart';
import 'package:ourtube/core/utils/extensions/theme_context_extension.dart';

class TileCheckbox extends StatefulWidget {
  final String title;
  final bool? isChecked;
  final IconData? icon;
  final String? imageAsset;
  final ValueChanged<bool> onChanged;

  const TileCheckbox({
    super.key,
    required this.title,
    required this.isChecked,
    this.icon,
    this.imageAsset,
    required this.onChanged,
  });

  @override
  TileCheckboxState createState() => TileCheckboxState();
}

class TileCheckboxState extends State<TileCheckbox> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.isChecked!;
  }

  void _toggleCheckbox(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
    widget.onChanged(_isChecked);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _toggleCheckbox(!_isChecked),
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Checkbox(
              value: _isChecked,
              onChanged: _toggleCheckbox,
              activeColor: context.activeColor,
              side: BorderSide(color: context.ternaryColor, width: 1.5),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(
                widget.title,
                style: const TextStyle(fontSize: 16.0),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 35.0),
            if (widget.icon != null)
              Icon(widget.icon, color: context.ternaryColor),
            if (widget.imageAsset != null)
              Image.asset(widget.imageAsset!, width: 24.0, height: 24.0),
          ],
        ),
      ),
    );
  }
}
