import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'custom_container.dart';

class CustomTextField extends HookConsumerWidget {
  const CustomTextField({
    super.key,
    this.validator,
    required this.controller,
    this.hintText,
  });

  final String? Function(String?)? validator;
  final TextEditingController controller;
  final String? hintText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isInset = useState(controller.text.isNotEmpty);

    // ✅ Correct memoization + disposal of FocusNode
    final focusNode = useMemoized(() => FocusNode());
    useEffect(() {
      return () => focusNode.dispose(); // Dispose once
    }, []);

    useEffect(() {
      void updateInset() {
        isInset.value = controller.text.isNotEmpty || focusNode.hasFocus;
      }

      controller.addListener(updateInset);
      focusNode.addListener(updateInset);

      // Initial check (in case already has text)
      updateInset();

      return () {
        controller.removeListener(updateInset);
        focusNode.removeListener(updateInset);
      };
    }, [controller, focusNode]);

    return CustomContainer(
      inset: isInset.value,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: TextFormField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            hintText: hintText ?? '',
            border: InputBorder.none,
          ),
          textAlign: TextAlign.center,
          validator: validator,
        ),
      ),
    );
  }
}
