import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/climasys/api/models/move_route_request.dart';
import 'package:climasys/climasys/api/models/sector.dart';
import 'package:climasys/climasys/features/map_view/widgets/map_and_routes/sector_display/sector_display.dart';
import 'package:climasys/utils/storage_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../api/models/route.dart' as RouteModel;
import '../../functions/get_color_from_string.dart';
import '../route_pin/route_pin.dart';

class MapAndRoutes extends StatefulWidget {
  final bool isGymAdmin;
  final bool isUserLoggedIn;
  final List<RouteModel.Route> routes;
  final double containerWidth;
  final double containerHeight;
  final File mapSvg;
  final VoidCallback? fetchRoutes;
  final GlobalKey imageKey;
  final TransformationController transformationController;
  final bool bulkEditMode;
  final bool enableSectors;
  final int basePinSize;
  final List<Sector> sectors;
  final Function(int)? onToggleSelection;

  const MapAndRoutes({
    super.key,
    required this.isGymAdmin,
    required this.isUserLoggedIn,
    required this.routes,
    required this.containerWidth,
    required this.containerHeight,
    required this.mapSvg,
    this.fetchRoutes,
    required this.imageKey,
    required this.transformationController,
    this.bulkEditMode = false,
    this.enableSectors = false,
    this.basePinSize = 10,
    this.sectors = const [],
    this.onToggleSelection
  });

  @override
  State<MapAndRoutes> createState() => _MapAndRoutesState();
}

class _MapAndRoutesState extends State<MapAndRoutes> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool _showRoutes = false;
  int? _draggingRouteId;
  Offset? _draggingOffset;
  Offset _fingerToPinDelta = Offset.zero;
  static const double _zoomThreshold = 1.5;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    final initialZoom = widget.transformationController.value.getMaxScaleOnAxis();
    _showRoutes = (initialZoom >= _zoomThreshold) || !widget.enableSectors;
    if (_showRoutes) {
      _controller.value = 1.0;
    }

    widget.transformationController.addListener(_onZoomChange);
  }

  Future<void> _updateRoutePosition({
    required int routeId,
    required double normalizedX,
    required double normalizedY,
  }) async {
    final gymName = await getGymName(context);
    await moveRoute(MoveRouteRequest(routeId: routeId, xCord: normalizedX, yCord: normalizedY), gymName);
    widget.fetchRoutes?.call();
  }

  void _onZoomChange() {
    final currentZoom = widget.transformationController.value.getMaxScaleOnAxis();
    if (widget.enableSectors) {
      if (!_showRoutes && currentZoom >= _zoomThreshold) {
        setState(() {
          _showRoutes = true;
        });
        _controller.forward(from: 0.0);
      } else if (_showRoutes && currentZoom < _zoomThreshold) {
        setState(() {
          _showRoutes = false;
        });
        _controller.value = 0.0;
      }
    }
  }

  @override
  void dispose() {
    widget.transformationController.removeListener(_onZoomChange);
    _controller.dispose();
    super.dispose();
  }

  /// Called when the user finishes dragging a pin
  void _onPinDragEnd({
    required int routeId,
    required Offset offsetInParent,
  }) {
    final double containerW = widget.containerWidth;
    final double containerH = widget.containerHeight;

    // Convert offsetInParent -> normalized coords 0..1
    final normalizedX = offsetInParent.dx / containerW;
    final normalizedY = offsetInParent.dy / containerH;

    // Update the backend with new coords
    setState(() {
      _draggingRouteId = null;
      _draggingOffset = null;
      _fingerToPinDelta = Offset.zero;
    });

    _updateRoutePosition(
      routeId: routeId,
      normalizedX: normalizedX,
      normalizedY: normalizedY,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Group routes by sector ...
    final Map<int, List<RouteModel.Route>> routesBySector = {};
    for (final route in widget.routes) {
      final sectorId = route.sectorId ?? -1;
      routesBySector.putIfAbsent(sectorId, () => []).add(route);
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // 1) The map
        Positioned.fill(
          child: SvgPicture.file(
            key: widget.imageKey,
            widget.mapSvg,
            fit: BoxFit.contain,
            placeholderBuilder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),

        // 2) Animate sectors + route pins
        AnimatedBuilder(
          animation: Listenable.merge([_controller, widget.transformationController]),
          builder: (context, child) {
            final fraction = _controller.value;
            final currentZoom =
            widget.transformationController.value.getMaxScaleOnAxis();

            // Fade sector labels as fraction -> 1
            final labelOpacity = 1.0 - fraction;

            // A) Sector label widgets
            final sectorWidgets = widget.sectors.map((sector) {
              // Compute sector center ...
              final avgX = (sector.xStart + sector.xEnd)/2;
              final avgY = (sector.yStart + sector.yEnd)/2;

              final centerLeft = avgX * widget.containerWidth;
              final centerTop = avgY * widget.containerHeight;

              final sectorRoutes = routesBySector[sector.id];

              var ascendedCount = 0;
              var totalCount = 0;

              if(sectorRoutes != null) {
                ascendedCount = sectorRoutes
                    .where((x) => x.hasAscended == true).length;

                totalCount = sectorRoutes.length;
              }

              return Positioned(
                left: centerLeft - 40,
                top: centerTop - 30,
                child: Opacity(
                  opacity: labelOpacity,
                  child: SectorDisplay(
                    sectorName: sector.name,
                    ascendedCount: ascendedCount,
                    totalCount: totalCount,
                    currentZoom: currentZoom,
                  ),
                ),
              );
            }).toList();

            // B) Route pins
            final List<Widget> routePins = [];
            if (_showRoutes) {
              for (final route in widget.routes) {
                final sectorId = route.sectorId ?? -1;
                final sectorList = routesBySector[sectorId];
                if (sectorList == null || sectorList.isEmpty) continue;

                // Sector center
                final avgX = sectorList.map((r) => r.xCord).reduce((a, b) => a + b) /
                    sectorList.length;
                final avgY = sectorList.map((r) => r.yCord).reduce((a, b) => a + b) /
                    sectorList.length;

                final centerLeft = avgX * widget.containerWidth;
                final centerTop = avgY * widget.containerHeight;

                // Actual route position
                final routeLeft = route.xCord * widget.containerWidth;
                final routeTop = route.yCord * widget.containerHeight;

                // Animate from center -> actual based on fraction
                final displayLeft = centerLeft + (routeLeft - centerLeft) * fraction;
                final displayTop = centerTop + (routeTop - centerTop) * fraction;

                // If this route is currently being dragged, show the "in-flight" position
                // rather than the original calculated position.
                bool isDraggingThis = (_draggingRouteId == route.id);
                final pinLeft = isDraggingThis && _draggingOffset != null
                    ? _draggingOffset!.dx
                    : displayLeft;

                final pinTop = isDraggingThis && _draggingOffset != null
                    ? _draggingOffset!.dy
                    : displayTop;

                // Scale the pin size by current zoom
                int basePinSize = widget.basePinSize;
                num pinSize = (basePinSize * 5 / currentZoom);

                routePins.add(
                  // Wrap in GestureDetector for drag
                  Positioned(
                    left: pinLeft - (pinSize / 2),
                    top: pinTop - (pinSize / 2),
                    child: GestureDetector(
                      onLongPressStart: (LongPressStartDetails details) {
                        if(widget.isGymAdmin){
                          setState(() {
                            _draggingRouteId = route.id;
                            // The pin’s position before dragging
                            _draggingOffset = Offset(displayLeft, displayTop);

                            // The difference between the finger’s local position and the pin’s offset
                            // at the moment dragging began:
                            _fingerToPinDelta = details.localPosition - _draggingOffset!;
                            route.isSelected = true;
                          });
                        }
                      },
                      onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
                        if (isDraggingThis && widget.isGymAdmin) {
                          setState(() {
                            _draggingOffset = details.localPosition - _fingerToPinDelta;
                          });
                        }
                      },
                      onLongPressEnd: (LongPressEndDetails details) {
                        if (isDraggingThis && _draggingOffset != null && widget.isGymAdmin) {
                          final offsetInParent = _draggingOffset!;
                          final double containerW = widget.containerWidth;
                          final double containerH = widget.containerHeight;

                          // Convert offsetInParent -> normalized coords 0..1
                          final normalizedX = offsetInParent.dx / containerW;
                          final normalizedY = offsetInParent.dy / containerH;

                          setState(() {
                            route.xCord = normalizedX;
                            route.yCord = normalizedY;
                            route.isSelected = false;
                          });

                          _onPinDragEnd(
                            routeId: route.id,
                            offsetInParent: _draggingOffset!,
                          );
                        }
                      },
                      child: RoutePin(
                        routeId: route.id,
                        color: getColorFromString(route.color),
                        isUserAdmin: widget.isGymAdmin,
                        isUserLoggedIn: widget.isUserLoggedIn,
                        labelText: route.standardGradeName ?? '',
                        hasAscended: route.hasAscended,
                        onActionCompleted: widget.fetchRoutes ?? () {},
                        transformationController: widget.transformationController,
                        size: pinSize,
                        isSelected: route.isSelected,
                        // NEW: pass the same bulkEditMode
                        bulkEditMode: widget.bulkEditMode,
                        // NEW: pass the route-selection callback
                        onToggleSelection: widget.onToggleSelection,
                      ),
                    ),
                  ),
                );
              }
            }

            return Stack(
              clipBehavior: Clip.none,
              children: [
                ...sectorWidgets,
                ...routePins,
              ],
            );
          },
        ),
      ],
    );
  }
}

