import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:terra_tutor/Global_Elements/theme_data.dart';

class AddWidgetButton extends StatelessWidget {
  final String name;
  final String imagePath;
  final VoidCallback onTap;
  final bool isNetworkImage;

  const AddWidgetButton({
    super.key,
    required this.name,
    required this.imagePath,
    required this.onTap,
    this.isNetworkImage = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeNotifier>(context).getTheme();
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isNetworkImage
                ? Image.network(imagePath, width: 60, height: 60)
                : Image.asset(imagePath, width: 60, height: 60),
            const SizedBox(height: 8),
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
