import 'package:flutter/material.dart';

class CategoryList extends StatefulWidget {
  final List<String> categories;
  final ValueChanged<int>? onCategorySelected;

  const CategoryList({
    super.key,
    required this.categories,
    this.onCategorySelected,
  });

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        separatorBuilder: (_, __) =>
        const SizedBox(width: 9),
        itemBuilder: (_, index) {
          final isSelected = selected == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selected = index;
              });

              widget.onCategorySelected?.call(index);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF00D5E6)
                    : const Color(0xFF262433),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                widget.categories[index],
                style: TextStyle(
                  color: isSelected
                      ? Colors.black
                      : Colors.white60,
                  fontSize: 8,
                  fontWeight: isSelected
                      ? FontWeight.w700
                      : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}