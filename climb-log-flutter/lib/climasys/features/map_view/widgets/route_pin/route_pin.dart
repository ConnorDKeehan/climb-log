import 'package:climasys/climasys/features/map_view/functions/get_text_color_from_bgcolor.dart';
import 'package:flutter/material.dart';
import '../../../route_view/route_view.dart';

class RoutePin extends StatelessWidget {
  final Color color;
  final num size;
  final int routeId;
  final bool hasAscended;
  final bool isSelected;
  final bool isUserAdmin;
  final bool isUserLoggedIn;
  final VoidCallback onActionCompleted;
  final String labelText;
  final TransformationController transformationController;
  // NEW:
  final bool bulkEditMode;
  final Function(int)? onToggleSelection; // callback to parent

  const RoutePin({
    super.key,
    required this.color,
    required this.routeId,
    required this.hasAscended,
    required this.isUserAdmin,
    this.isUserLoggedIn = true,
    this.isSelected = false,
    required this.onActionCompleted,
    this.labelText = '',
    required this.size,
    required this.transformationController,
    // NEW:
    required this.bulkEditMode,
    this.onToggleSelection,
  });



  @override
  Widget build(BuildContext context) {
    // Function to determine text color based on background color


    Widget getPinText(){
      if(hasAscended) {
        return Icon(
          Icons.check,
          color: getTextColorFromBgColor(color),
        );
      }

      return Text(
        labelText,
        style: TextStyle(
          color: getTextColorFromBgColor(color),
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return GestureDetector(
          onTap: () {
            // Currently guest users have nothing to see in routes.
            if (!isUserLoggedIn) {
              return;
            }

            // If in bulk-edit mode, toggle selection instead of navigating
            if (bulkEditMode) {
              onToggleSelection?.call(routeId);
              return;
            }

            // Navigate to the RouteView page
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RouteView(
                  routeId: routeId,
                  hasAscended: hasAscended,
                  isUserAdmin: isUserAdmin,
                  onActionCompleted: onActionCompleted,
                ),
              ),
            );
          },
          child: Container(
                  width: size.toDouble(),
                  height: size.toDouble(),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    border: isSelected ? Border.all(width: size*0.1, color: Colors.blue) : Border.all(width: 0, color: color),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        offset: Offset(size*0.2, size*0.2),
                        blurRadius: size*0.5,
                        spreadRadius: size*0.1,
                      ),
                    ]
                  ),
                  alignment: Alignment.center,

                  child: labelText.isEmpty && hasAscended == false ? const SizedBox.shrink()
                    : Transform.scale(
                              scale: 0.8,
                              child: FittedBox(fit: BoxFit.scaleDown, child: getPinText())
                          )
                )
        );
  }
}
