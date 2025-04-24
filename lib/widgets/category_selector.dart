import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../utils/theme_constants.dart';
import '../extensions/color_extensions.dart';

class CategorySelector extends StatefulWidget {
  final List<String> selectedCategoryIds;
  final Function(List<String>) onCategoriesChanged;

  const CategorySelector({
    super.key,
    required this.selectedCategoryIds,
    required this.onCategoriesChanged,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  late List<String> _selectedCategoryIds;
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedCategoryIds = List.from(widget.selectedCategoryIds);
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance.collection('categories').get();
      _categories = snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
    } catch (e) {
      debugPrint('Error loading categories: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _categories.map((category) => _buildCategoryOption(category)).toList(),
    );
  }

  Widget _buildCategoryOption(Category category) {
    final isSelected = _selectedCategoryIds.contains(category.categoryId);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedCategoryIds.remove(category.categoryId);
          } else {
            _selectedCategoryIds.add(category.categoryId);
          }
        });
        widget.onCategoriesChanged(_selectedCategoryIds);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: isSelected ? category.color.withValues(alpha: 0.3) : AppTheme.cardBackground,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: category.color) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: category.color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              category.name,
              style: TextStyle(
                color: isSelected ? category.color : AppTheme.textPrimary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}