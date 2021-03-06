import 'package:flutter/cupertino.dart';
import 'package:hypergaragesale/components/constants.dart';

class ReusableCard extends StatelessWidget {
  ReusableCard({@required this.choose, this.childIcon, this.onPress});

  final bool choose;
  final Widget childIcon;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPress,
        child: Container(
          child: childIcon,
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: choose ? kActiveCardColor : kInactiveCardColor,
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
      ),
    );
  }
}
