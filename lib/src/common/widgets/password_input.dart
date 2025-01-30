import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:flutter/material.dart';

class PasswordInput extends StatefulWidget {
  const PasswordInput({
    super.key,
    required this.onPasswordChange,
  });

  final Function(String text) onPasswordChange;

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return ShadInput(
      placeholder: const Text('Password'),
      obscureText: obscure,
      prefix: const Padding(
        padding: EdgeInsets.all(4.0),
        child: Icon(LucideIcons.lock),
      ),
      onChanged: widget.onPasswordChange,
      suffix: ShadButton(
        width: 24,
        height: 24,
        padding: EdgeInsets.zero,
        decoration: const ShadDecoration(
          secondaryBorder: ShadBorder.none,
          secondaryFocusedBorder: ShadBorder.none,
        ),
        icon: Icon(obscure ? LucideIcons.eyeOff : LucideIcons.eye),
        onPressed: () {
          setState(() => obscure = !obscure);
        },
      ),
    );
  }
}
