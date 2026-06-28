import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/checklist.dart';
import '../theme/glass_theme.dart';
import '../widgets/glass_card.dart';
import 'template_detail_screen.dart';

class DiscoverScreen extends StatefulWidget {
  final List<ChecklistTemplate> templates;

  const DiscoverScreen({
    super.key,
    required this.templates,
  });

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String _selectedCategory = 'All';

  List<String> get _categories {
    final categories = widget.templates.map((t) => t.category).toSet().toList();
    categories.sort();
    return ['All', ...categories];
  }

  @override
  Widget build(BuildContext context) {
    final filteredTemplates = _selectedCategory == 'All'
        ? widget.templates
        : widget.templates.where((t) => t.category == _selectedCategory).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Discover',
                style: GlassTheme.largeTitle,
              ),
              const SizedBox(height: 4),
              Text(
                'Curated templates to jumpstart your routines.',
                style: GlassTheme.subhead,
              ),
            ],
          ),
        ),
        
        // Category Chips
        SizedBox(
          height: 52,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            itemCount: _categories.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = _selectedCategory == category;

              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  borderRadius: 16,
                  isSelected: isSelected,
                  opacity: isSelected ? 0.2 : 0.08,
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: Text(
                    category,
                    style: TextStyle(
                      color: isSelected ? GlassTheme.secondaryAccent : GlassTheme.textPrimary,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Grid/List of templates
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 650;
              
              if (isWide) {
                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.45,
                  ),
                  itemCount: filteredTemplates.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) => _buildTemplateCard(context, filteredTemplates[index]),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
                itemCount: filteredTemplates.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: _buildTemplateCard(context, filteredTemplates[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTemplateCard(BuildContext context, ChecklistTemplate template) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => TemplateDetailScreen(template: template),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Emoji Icon with background gradient
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: template.gradientColors.map((c) => c.withOpacity(0.5)).toList(),
                  ),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.08),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    template.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
              ),
              // Category tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withOpacity(0.04),
                  border: Border.all(color: Colors.black.withOpacity(0.06)),
                ),
                child: Text(
                  template.category.toUpperCase(),
                  style: TextStyle(
                    color: GlassTheme.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            template.title,
            style: GlassTheme.title2.copyWith(fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            template.description,
            style: GlassTheme.subhead.copyWith(fontSize: 13),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${template.items.length} items',
                style: GlassTheme.footnote,
              ),
              Row(
                children: [
                  Text(
                    'Preview',
                    style: TextStyle(
                      color: GlassTheme.secondaryAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    CupertinoIcons.chevron_right,
                    color: GlassTheme.secondaryAccent,
                    size: 14,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
