import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../localization/localization_provider.dart';

class TextWidget extends ConsumerWidget {
  final TextStyle? style;
  final String textKey;

  const TextWidget({super.key, required this.textKey, this.style});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(
      builder: (context, ref, child) {
        ref.watch(languageProvider);
        return Text(
          localizedText(textKey),
          style: style,
          overflow: TextOverflow.ellipsis,
        );
      },
    );
  }
}
