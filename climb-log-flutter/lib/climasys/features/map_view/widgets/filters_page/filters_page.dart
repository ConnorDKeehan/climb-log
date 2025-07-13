import 'package:flutter/material.dart';
import 'package:climasys/climasys/features/competitions_screen/models/get_competition_by_gym_query_response.dart';
import 'package:climasys/climasys/api/climasys_api.dart';
import 'package:climasys/utils/storage_util.dart';
import 'package:climasys/climasys/features/map_view/models/filters.dart';

import '../../functions/get_text_color_from_bgcolor.dart';

class FiltersSidePanel extends StatefulWidget {
  final Filters filters;
  final void Function(Filters filters) onApplyFilters;

  const FiltersSidePanel({
    Key? key,
    required this.filters,
    required this.onApplyFilters,
  }) : super(key: key);

  @override
  _FiltersSidePanelState createState() => _FiltersSidePanelState();
}

class _FiltersSidePanelState extends State<FiltersSidePanel> {
  late Filters _appliedFilters;
  late RangeValues _currentRangeValues;
  List<GetCompetitionByGymQueryResponse> competitions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _appliedFilters = widget.filters;

    _appliedFilters.availableStandardGrades
        .sort((a, b) => a.gradeOrder.compareTo(b.gradeOrder));

    if (_appliedFilters.availableStandardGrades.isNotEmpty) {
      // Initialize the RangeValues based on min and max selected grades
      int minIndex = _appliedFilters.availableStandardGrades.indexWhere(
            (grade) =>
        grade.gradeName ==
            _appliedFilters.minSelectedStandardGrade?.gradeName,
      );
      int maxIndex = _appliedFilters.availableStandardGrades.indexWhere(
            (grade) =>
        grade.gradeName ==
            _appliedFilters.maxSelectedStandardGrade?.gradeName,
      );

      _currentRangeValues = RangeValues(
        minIndex.toDouble(),
        maxIndex.toDouble(),
      );
    }

    initializeCompFilter();
  }

  void initializeCompFilter() async {
    final String gymName = await getGymName(context);
    competitions = await getCompetitionsByGym(gymName);
    isLoading = false;
    setState(() {});
  }

  void _onGradeChanged(bool? isChecked, String gradeName) {
    setState(() {
      if (isChecked == true) {
        if (!_appliedFilters.selectedGrades.contains(gradeName)) {
          _appliedFilters.selectedGrades.add(gradeName);
        }
      } else {
        _appliedFilters.selectedGrades.remove(gradeName);
      }
    });
  }

  void onAscendedChanged(bool value) {
    setState(() {
      _appliedFilters.showAscended = value;
    });
  }

  void applyFilters({bool filtersApplied = true}) {
    if (_appliedFilters.availableStandardGrades.isNotEmpty &&
        _appliedFilters.minSelectedStandardGrade?.gradeOrder ==
            widget.filters.availableStandardGrades.first.gradeOrder &&
        _appliedFilters.maxSelectedStandardGrade?.gradeOrder ==
            widget.filters.availableStandardGrades.last.gradeOrder) {
      _appliedFilters.applyStandardGradeFilter = false;
    } else if (_appliedFilters.availableStandardGrades.isNotEmpty) {
      _appliedFilters.applyStandardGradeFilter = true;
    }

    _appliedFilters.filtersApplied = filtersApplied;
    widget.onApplyFilters(_appliedFilters);
    Navigator.pop(context, _appliedFilters);
  }

  void handleClearFilter() {
    setState(() {
      _appliedFilters.selectedGrades =
          widget.filters.availableGrades.map((g) => g.gradeName).toList();
      _appliedFilters.showAscended = true;

      if (_appliedFilters.availableStandardGrades.isNotEmpty) {
        _appliedFilters.minSelectedStandardGrade =
            widget.filters.availableStandardGrades.first;
        _appliedFilters.maxSelectedStandardGrade =
            widget.filters.availableStandardGrades.last;
      }

      _currentRangeValues = RangeValues(
        0,
        (_appliedFilters.availableStandardGrades.length - 1).toDouble(),
      );

      // Optionally clear the competition filter as well
      _appliedFilters.competitionId = null;

      _appliedFilters.filtersApplied = false;
    });
    applyFilters(filtersApplied: false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // This container can be placed in a side panel or show up as a drawer,
    // depending on your app’s navigation approach.
    return Container(
      // Fixed width to act like a side panel
      width: 300,
      // Use a background color that contrasts well with your text and checkboxes
      color: theme.colorScheme.surface,
      child: Column(
        children: [
          // ======== Top Bar with Title and Close Icon ========
          Container(
            color: theme.colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Filters',
                    style: TextStyle(
                      color: theme.colorScheme.onPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(
                    Icons.close,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),

          // ======== Body ========
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ------- Filter by Color -------
                  Text(
                    'Filter by Color',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // A subtle container behind the color checkboxes
                  Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondaryContainer, // or any color you like
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: widget.filters.availableGrades.map((grade) {
                        return CheckboxListTile(
                          title: Text(
                            grade.gradeName,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          value: _appliedFilters.selectedGrades
                              .contains(grade.gradeName),
                          onChanged: (isChecked) =>
                              _onGradeChanged(isChecked, grade.gradeName),
                          secondary: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: grade.gradeColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          controlAffinity: ListTileControlAffinity.leading,
                          activeColor: grade.gradeColor,
                          checkColor: getTextColorFromBgColor(grade.gradeColor?? Colors.white),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ------- Show Ascended -------
                  Divider(color: theme.dividerColor),
                  SwitchListTile(
                    title: Text(
                      'Show ascended',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    value: _appliedFilters.showAscended,
                    onChanged: onAscendedChanged,
                    activeColor: theme.colorScheme.primary,
                  ),

                  Divider(color: theme.dividerColor),
                  const SizedBox(height: 8),

                  // ------- Select Grade Range -------
                  if (_appliedFilters.availableStandardGrades.isNotEmpty &&
                      _appliedFilters.availableStandardGrades.length > 1) ...[
                    Text(
                      'Select Grade Range',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RangeSlider(
                      values: _currentRangeValues,
                      min: 0,
                      max: (_appliedFilters.availableStandardGrades.length - 1)
                          .toDouble(),
                      divisions:
                      _appliedFilters.availableStandardGrades.length - 1,
                      labels: RangeLabels(
                        _appliedFilters.availableStandardGrades[
                        _currentRangeValues.start.round()]
                            .gradeName,
                        _appliedFilters.availableStandardGrades[
                        _currentRangeValues.end.round()]
                            .gradeName,
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _currentRangeValues = values;
                          _appliedFilters.minSelectedStandardGrade =
                          _appliedFilters.availableStandardGrades[
                          _currentRangeValues.start.round()];
                          _appliedFilters.maxSelectedStandardGrade =
                          _appliedFilters.availableStandardGrades[
                          _currentRangeValues.end.round()];
                        });
                      },
                    ),
                    Divider(color: theme.dividerColor),
                  ],

                  // ------- Competition Dropdown -------
                  if (competitions.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Select Competition',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 12.0,
                        ),
                      ),
                      style: TextStyle(color: theme.colorScheme.onSurface),
                      iconEnabledColor: theme.colorScheme.onSurface,
                      value: (competitions.any((comp) =>
                      comp.competitionId == _appliedFilters.competitionId))
                          ? _appliedFilters.competitionId
                          : null,
                      items: competitions.map((comp) {
                        return DropdownMenuItem<int>(
                          value: comp.competitionId,
                          child: Text(comp.competitionName),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        setState(() {
                          _appliedFilters.competitionId = newValue;
                        });
                      },
                      hint: const Text('Select a competition'),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // ======== Bottom Bar with Clear / Apply ========
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: theme.colorScheme.primary,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: handleClearFilter,
                  child: Text(
                    'Clear',
                    style: TextStyle(color: theme.colorScheme.onPrimary),
                  ),
                ),
                ElevatedButton(
                  onPressed: applyFilters,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.onPrimary,
                    // or use theme.colorScheme.secondary, etc.
                  ),
                  child: Text(
                    'Apply',
                    style: TextStyle(color: theme.colorScheme.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
