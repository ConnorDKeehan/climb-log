import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/climasys/api/models/sector.dart';
import 'package:climasys/climasys/features/main_menu/main_menu.dart';
import 'package:climasys/climasys/features/map_view/widgets/filters_page/filters_page.dart';
import 'package:climasys/climasys/widgets/upsert_route_dialog/upsert_route_dialog.dart';
import 'package:climasys/utils/storage_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/file.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../climasys/api/models/gym.dart';
import '../../../../climasys/api/models/route.dart' as RouteModel;
import 'functions/get_color_from_string.dart';
import 'models/add_route_result.dart';
import 'models/filters.dart';
import 'models/grade.dart';
import 'widgets/bulk_edit_map_view/bulk_edit_map_view.dart';
import 'widgets/map_and_routes/map_and_routes.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late Gym gym;
  List<RouteModel.Route> allRoutes = [];
  List<RouteModel.Route> filteredRoutes = [];
  List<Sector> sectors = [];
  String gymName = '';
  bool isGymAdmin = false;
  bool isUserLoggedIn = false;
  final storage = const FlutterSecureStorage();
  final cacheManager = DefaultCacheManager();
  late File mapSvg;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = true;

  // TransformationController to manage zoom/pan transformations
  final TransformationController _transformationController =
      TransformationController();

  Filters filters = Filters(
    availableGrades: [],
    selectedGrades: [],
    availableStandardGrades: [],
    minSelectedStandardGrade: null,
    maxSelectedStandardGrade: null,
    showAscended: true,
    filtersApplied: false,
    applyStandardGradeFilter: false,
  );

  final GlobalKey _imageKey = GlobalKey();

  // Variable to store the displayed image size
  Size? displayedImageSize;

  @override
  void initState() {
    super.initState();
    _initializeGym();
  }

  Future<void> _initializeGym() async {
    String newGymName = await getGymName(context);

    while (newGymName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("A Gym Must Be Selected Before Proceeding"),
        ),
      );
      newGymName = await getGymName(context);
    }

    if (gymName != newGymName) {
      final newGym = await getGym(newGymName);
      mapSvg = await cacheManager.getSingleFile(newGym.floorPlanImgUrl);
      setState(() {
        gymName = newGymName;
        gym = newGym;
      });
    }

    final String? accessToken = await storage.read(key: 'accessToken');
    if (accessToken != null) {
      isUserLoggedIn = true;
      isGymAdmin = await isUserGymAdmin(gymName: gymName);
    }

    fetchRoutes();
  }

  void setAvailableGrades(List<RouteModel.Route> allRoutes) {
    final List<Grade> grades = [];
    final List<Grade> standardGrades = [];

    for (final route in allRoutes) {
      if (!grades.any((grade) => grade.gradeName == route.gradeName)) {
        grades.add(
          Grade(
            route.gradeName,
            getColorFromString(route.color),
            route.gradeOrder,
          ),
        );
      }
      if (route.standardGradeName != null) {
        if (!standardGrades
            .any((g) => g.gradeName == route.standardGradeName)) {
          standardGrades.add(
            Grade(
              route.standardGradeName!,
              null,
              route.standardGradeOrder!,
            ),
          );
        }
      }
    }

    grades.sort((a, b) => a.gradeOrder.compareTo(b.gradeOrder));
    filters.availableGrades = grades;
    filters.availableStandardGrades = standardGrades;

    if (!filters.filtersApplied) {
      filters.selectedGrades = grades.map((grade) => grade.gradeName).toList();
      filters.showAscended = true;
      if (filters.availableStandardGrades.isNotEmpty) {
        filters.availableStandardGrades
            .sort((a, b) => a.gradeOrder.compareTo(b.gradeOrder));
        filters.minSelectedStandardGrade =
            filters.availableStandardGrades.first;
        filters.maxSelectedStandardGrade = filters.availableStandardGrades.last;
      }
    }
  }

  void applyFilters(Filters filterToApply) {
    filters = filterToApply;
    fetchRoutes(retrieveFromApi: false);
  }

  void fetchRoutes({bool retrieveFromApi = true}) async {
    try {
      if (isLoading = false) {
        setState(() {
          isLoading = true;
        });
      }
      List<RouteModel.Route> fetchedRoutes = allRoutes;
      List<Sector> fetchedSectors = sectors;
      if (retrieveFromApi) {
        fetchedRoutes = await getAllRoutes(gymName);
        fetchedSectors = await getSectorsByGymName(gymName);
      }

      setAvailableGrades(fetchedRoutes);

      setState(() {
        allRoutes = fetchedRoutes;
        sectors = fetchedSectors;
      });

      if (filters.filtersApplied) {
        filteredRoutes = fetchedRoutes.where((route) {
          return (filters.showAscended || route.hasAscended == false) &&
              (filters.competitionId == null ||
                  route.competitionId == filters.competitionId) &&
              filters.selectedGrades.contains(route.gradeName) &&
              (!filters.applyStandardGradeFilter ||
                  (route.standardGradeOrder != null &&
                      route.standardGradeOrder! >=
                          filters.minSelectedStandardGrade!.gradeOrder &&
                      route.standardGradeOrder! <=
                          filters.maxSelectedStandardGrade!.gradeOrder));
        }).toList();
      } else {
        filteredRoutes = fetchedRoutes;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error fetching routes. Please try again later.'),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Called when a Gym Admin taps to add a new pin.
  /// Convert the transformed tap to the untransformed coordinates
  /// and store x/y as percentages of the total map width/height.
  void _addPin(Offset localPosition) async {
    // Get the size of the image as displayed
    final RenderBox? box =
        _imageKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) {
      return;
    }
    final Size imageSize = box.size;

    // Calculate the relative position
    double xPercent = localPosition.dx / imageSize.width;
    double yPercent = localPosition.dy / imageSize.height;

    await showDialog<AddRouteResult>(
      context: context,
      builder: (context) => UpsertRouteDialog(xCord: xPercent, yCord: yPercent),
    );
  }

  void _navigateToBulkEditMapView() async {
    // Navigate to BulkEditMapView and wait for the result
    bool? result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => BulkEditMapView(
              gym: gym, routes: filteredRoutes, mapSvg: mapSvg)),
    );

    // If the result is true, invoke the callback to refresh routes
    if (result == true) {
      fetchRoutes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
            title: Text("Boulders"),
            leading: IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainMenu(
                      isGymAdmin: isGymAdmin,
                      isUserLoggedIn: isUserLoggedIn,
                    ),
                  ),
                );
              },
            ),
            actions: [
              IconButton(
                  icon: Icon(Icons.filter_alt_sharp),
                  onPressed: () => _scaffoldKey.currentState?.openEndDrawer())
            ]),
        endDrawer:
            FiltersSidePanel(filters: filters, onApplyFilters: applyFilters),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack( children: [InteractiveViewer(
                boundaryMargin: const EdgeInsets.all(300),
                clipBehavior: Clip.none,
                transformationController: _transformationController,
                panEnabled: true,
                minScale: 0.5,
                maxScale: 16.0,
                child: Center(
                      child: AspectRatio(
                        aspectRatio: gym.viewBoxXSize.toDouble() /
                            gym.viewBoxYSize.toDouble(),
                        child: LayoutBuilder(
                          builder: (ctx, constraints) {
                            final double containerWidth = constraints.maxWidth;
                            final double containerHeight =
                                constraints.maxHeight;

                            return GestureDetector(
                              onTapUp: (details) {
                                if (isGymAdmin) {
                                  _addPin(details.localPosition);
                                }
                              },
                              child: MapAndRoutes(
                                isGymAdmin: isGymAdmin,
                                isUserLoggedIn: isUserLoggedIn,
                                routes: filteredRoutes,
                                containerWidth: containerWidth,
                                containerHeight: containerHeight,
                                mapSvg: mapSvg,
                                fetchRoutes: fetchRoutes,
                                imageKey: _imageKey,
                                transformationController:
                                    _transformationController,
                                enableSectors: gym.enableSectors,
                                sectors: sectors,
                              ),
                            );
                          },
                        ),
                      ),
                    )),
                    // Bulk Edit
                    if (isGymAdmin)
                      Positioned(
                        bottom: 16.0,
                        right: 16.0,
                        child: ElevatedButton(
                          onPressed: _navigateToBulkEditMapView,
                          child: const Text("Bulk Edit"),
                        ),
                      ),
                  ],
                ),
    );
  }
}
