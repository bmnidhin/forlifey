import 'package:flutter/material.dart';

class ChecklistTemplateItem {
  final String id;
  final String title;
  final String? description;

  const ChecklistTemplateItem({
    required this.id,
    required this.title,
    this.description,
  });
}

class ChecklistTemplate {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String category;
  final List<ChecklistTemplateItem> items;
  final List<Color> gradientColors;

  const ChecklistTemplate({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.items,
    required this.gradientColors,
  });
}

class ChecklistInstanceItem {
  final String id;
  final String title;
  bool isCompleted;

  ChecklistInstanceItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });
}

class ChecklistInstance {
  final String id;
  final String templateId;
  final String title;
  final String icon;
  final List<Color> gradientColors;
  final List<ChecklistInstanceItem> items;
  final DateTime createdAt;

  ChecklistInstance({
    required this.id,
    required this.templateId,
    required this.title,
    required this.icon,
    required this.gradientColors,
    required this.items,
    required this.createdAt,
  });

  double get progress {
    if (items.isEmpty) return 0.0;
    final completedCount = items.where((i) => i.isCompleted).length;
    return completedCount / items.length;
  }

  int get completedCount => items.where((i) => i.isCompleted).length;
  int get totalCount => items.length;
}
