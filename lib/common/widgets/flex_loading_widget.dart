import 'package:flutter/material.dart';
import 'package:weekly_planner/common/extensions.dart';

class FlexLoadingWidget extends StatelessWidget {
  final Size size;
  final double iconResizeFactor;
  final Widget? iconWdt;
  final Color? color;

  const FlexLoadingWidget({
    super.key,
    this.size = const Size(90.0, 90.0),
    this.iconResizeFactor = 0.7,
    this.iconWdt,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size.width,
        height: size.height,
        child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            FractionallySizedBox(
              heightFactor: iconResizeFactor,
              widthFactor: iconResizeFactor,
              child: FittedBox(
                child: iconWdt ?? const SizedBox.shrink(),
              ),
            ),
            CircularProgressIndicator(
              key: const Key('circular_loading_flex'),
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? context.theme.primaryColor.withOpacity(0.6),
                // Colors.blue.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
