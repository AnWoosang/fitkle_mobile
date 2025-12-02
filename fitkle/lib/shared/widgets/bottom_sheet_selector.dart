import 'package:flutter/material.dart';
import 'package:fitkle/core/theme/app_theme.dart';

/// Bottom sheet selector widget
///
/// A reusable bottom sheet modal for selecting items from a searchable list
class BottomSheetSelector<T> extends StatefulWidget {
  final String title;
  final String searchHint;
  final List<T> items;
  final T? selectedItem;
  final String Function(T) getItemLabel;
  final String? Function(T)? getItemSubtitle;
  final String? Function(T)? getItemLeading;
  final Function(T) onItemSelected;
  final List<T> Function(String)? onSearch;
  final double heightFactor;

  const BottomSheetSelector({
    super.key,
    required this.title,
    required this.searchHint,
    required this.items,
    this.selectedItem,
    required this.getItemLabel,
    this.getItemSubtitle,
    this.getItemLeading,
    required this.onItemSelected,
    this.onSearch,
    this.heightFactor = 0.6,
  });

  @override
  State<BottomSheetSelector<T>> createState() => _BottomSheetSelectorState<T>();

  /// Show the bottom sheet selector
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String searchHint,
    required List<T> items,
    T? selectedItem,
    required String Function(T) getItemLabel,
    String? Function(T)? getItemSubtitle,
    String? Function(T)? getItemLeading,
    List<T> Function(String)? onSearch,
    double heightFactor = 0.6,
  }) async {
    return await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => BottomSheetSelector<T>(
        title: title,
        searchHint: searchHint,
        items: items,
        selectedItem: selectedItem,
        getItemLabel: getItemLabel,
        getItemSubtitle: getItemSubtitle,
        getItemLeading: getItemLeading,
        onItemSelected: (item) {
          Navigator.pop(context, item);
        },
        onSearch: onSearch,
        heightFactor: heightFactor,
      ),
    );
  }
}

class _BottomSheetSelectorState<T> extends State<BottomSheetSelector<T>> {
  late TextEditingController _searchController;
  late List<T> _filteredItems;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredItems = widget.items;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else if (widget.onSearch != null) {
        _filteredItems = widget.onSearch!(query);
      } else {
        // Default search: filter by label
        _filteredItems = widget.items.where((item) {
          final label = widget.getItemLabel(item).toLowerCase();
          return label.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * widget.heightFactor,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Search field
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: widget.searchHint,
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[400],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.border, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.border, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: _onSearchChanged,
            ),
          ),

          // Item list
          Expanded(
            child: ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                final isSelected = item == widget.selectedItem;
                final label = widget.getItemLabel(item);
                final subtitle = widget.getItemSubtitle?.call(item);
                final leading = widget.getItemLeading?.call(item);

                return InkWell(
                  onTap: () => widget.onItemSelected(item),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppTheme.primary.withValues(alpha: 0.1) : null,
                      border: Border(
                        bottom: BorderSide(
                          color: AppTheme.border.withValues(alpha: 0.5),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        if (leading != null) ...[
                          Text(
                            leading,
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                label,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                  color: isSelected ? AppTheme.primary : Colors.black,
                                ),
                              ),
                              if (subtitle != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  subtitle,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: AppTheme.primary,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
