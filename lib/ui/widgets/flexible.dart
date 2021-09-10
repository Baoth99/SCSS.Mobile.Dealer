import 'package:flutter/cupertino.dart';

enum rowFlexibleType { smallToBig, BigToSmall }

Row rowFlexibleBuilder(smallwidget, largeWidget, rowFlexibleType type) {
  return type == rowFlexibleType.smallToBig
      ? Row(
          children: [
            flexibleSmallBuilder(smallwidget),
            flexibleSpaceBuilder(),
            flexibleLargeBuilder(largeWidget),
          ],
        )
      : Row(
          children: [
            flexibleLargeBuilder(largeWidget),
            flexibleSpaceBuilder(),
            flexibleSmallBuilder(smallwidget),
          ],
        );
}

Flexible flexibleSmallBuilder(widget) {
  return Flexible(
    flex: 28,
    child: widget,
  );
}

Flexible flexibleSpaceBuilder() {
  return Flexible(
    flex: 2,
    child: Container(),
  );
}

Flexible flexibleLargeBuilder(widget) {
  return Flexible(
    flex: 70,
    child: widget,
  );
}
