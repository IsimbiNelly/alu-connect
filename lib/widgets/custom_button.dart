import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback onPressed;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.label,
    required this.filled,
    required this.onPressed,
    this.icon,
  });

  ButtonStyle get _filledStyle => ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF5B21B6),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      );

  ButtonStyle get _outlinedStyle => OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF5B21B6),
        side: const BorderSide(color: Color(0xFF5B21B6), width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      );

  Widget _buildLabel() => Text(
        label,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: icon != null
          ? (filled
              ? ElevatedButton.icon(
                  onPressed: onPressed,
                  icon: Icon(icon),
                  label: _buildLabel(),
                  style: _filledStyle,
                )
              : OutlinedButton.icon(
                  onPressed: onPressed,
                  icon: Icon(icon),
                  label: _buildLabel(),
                  style: _outlinedStyle,
                ))
          : (filled
              ? ElevatedButton(
                  onPressed: onPressed,
                  style: _filledStyle,
                  child: _buildLabel(),
                )
              : OutlinedButton(
                  onPressed: onPressed,
                  style: _outlinedStyle,
                  child: _buildLabel(),
                )),
    );
  }
}
