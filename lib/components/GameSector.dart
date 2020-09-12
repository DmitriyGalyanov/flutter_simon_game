import 'package:flutter/material.dart';

class GameSector extends StatelessWidget {
  final int index;
  final Color color;
  final Function(int) emitSectorTap;
  final double animationDuration;
  final bool isHighlighted;
  const GameSector(
      this.index,
      this.color,
      this.emitSectorTap,
      this.animationDuration,
      this.isHighlighted,
      );
  @override
  Widget build(BuildContext context) {
    void _handleTap() {
      emitSectorTap(index);
    }
    return GestureDetector(
        onTap: _handleTap,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: animationDuration.floor()),
          opacity: isHighlighted ? 1.0 : 0.5,
          child: SizedBox(
              width: 100.0,
              height: 100.0,
              child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  margin: EdgeInsets.all(7.0)
              )),
        ));
  }
}
