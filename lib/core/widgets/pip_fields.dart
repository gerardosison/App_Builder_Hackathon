import 'package:flutter/material.dart';

import '../../app/theme/app_theme.dart';

/// Pill-shaped labeled text field matching the Stitch auth/edit screens:
/// label above, filled pill input with a leading icon and optional
/// trailing widget (e.g. password visibility toggle).
class PipTextField extends StatefulWidget {
  const PipTextField({
    super.key,
    required this.label,
    this.hint,
    this.icon,
    this.controller,
    this.isPassword = false,
    this.keyboardType,
    this.trailingLabel,
    this.onTrailingLabelTap,
    this.maxLines = 1,
  });

  final String label;
  final String? hint;
  final IconData? icon;
  final TextEditingController? controller;
  final bool isPassword;
  final TextInputType? keyboardType;
  final String? trailingLabel;
  final VoidCallback? onTrailingLabelTap;
  final int maxLines;

  @override
  State<PipTextField> createState() => _PipTextFieldState();
}

class _PipTextFieldState extends State<PipTextField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.label,
                  style: text.labelMedium
                      ?.copyWith(color: scheme.onSurfaceVariant)),
              if (widget.trailingLabel != null)
                InkWell(
                  onTap: widget.onTrailingLabelTap,
                  borderRadius: BorderRadius.circular(AppTheme.pillRadius),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    child: Text(
                      widget.trailingLabel!,
                      style: text.labelMedium?.copyWith(
                          color: scheme.secondary,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
            ],
          ),
        ),
        TextField(
          controller: widget.controller,
          obscureText: _obscure,
          keyboardType: widget.keyboardType,
          maxLines: _obscure ? 1 : widget.maxLines,
          style: text.bodyMedium,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon:
                widget.icon != null ? Icon(widget.icon, size: 20) : null,
            suffixIcon: widget.isPassword
                ? IconButton(
                    tooltip: _obscure ? 'Show password' : 'Hide password',
                    icon: Icon(
                        _obscure ? Icons.visibility : Icons.visibility_off,
                        size: 20),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
