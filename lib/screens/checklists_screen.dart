import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/checklist.dart';
import '../theme/glass_theme.dart';
import '../widgets/glass_card.dart';
import 'checklist_detail_screen.dart';

class ChecklistsScreen extends StatelessWidget {
  final List<ChecklistInstance> instances;
  final VoidCallback onExplorePressed;

  const ChecklistsScreen({
    super.key,
    required this.instances,
    required this.onExplorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 60, 24, 16),
          child: Text(
            'My Checklists',
            style: GlassTheme.largeTitle,
          ),
        ),
        Expanded(
          child: instances.isEmpty 
              ? _buildEmptyState(context) 
              : _buildInstancesList(context),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Center(
        child: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon container with gradient backing
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      GlassTheme.primaryAccent.withOpacity(0.4),
                      GlassTheme.secondaryAccent.withOpacity(0.4),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.08),
                    width: 1,
                  ),
                ),
                child: const Center(
                  child: Text(
                    '📋',
                    style: TextStyle(fontSize: 36),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No Active Checklists',
                style: GlassTheme.title2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Launch a new checklist from our curated templates to start tracking your progress.',
                style: GlassTheme.subhead,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              // Explore templates button
              GlassCard(
                borderRadius: 20,
                opacity: 0.16,
                borderOpacity: 0.3,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                onTap: onExplorePressed,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Explore Templates',
                      style: TextStyle(
                        color: GlassTheme.secondaryAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      CupertinoIcons.arrow_right,
                      color: GlassTheme.secondaryAccent,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInstancesList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 100),
      itemCount: instances.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final instance = instances[index];
        final progress = instance.progress;
        final completed = instance.completedCount;
        final total = instance.totalCount;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: GlassCard(
            padding: const EdgeInsets.all(18),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ChecklistDetailScreen(instanceId: instance.id),
                ),
              );
            },
            child: Row(
              children: [
                // Icon with gradient background
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: instance.gradientColors.map((c) => c.withOpacity(0.6)).toList(),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    border: Border.all(
                      color: Colors.black.withOpacity(0.08),
                      width: 1.0,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      instance.icon,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // Titles and progress bar
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        instance.title,
                        style: GlassTheme.headline,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$completed of $total items completed',
                        style: GlassTheme.footnote,
                      ),
                      const SizedBox(height: 10),
                      // Liquid progress bar
                      LayoutBuilder(
                        builder: (context, constraints) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Stack(
                              children: [
                                Container(
                                  height: 6,
                                  color: Colors.black.withOpacity(0.06),
                                ),
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: constraints.maxWidth * progress,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    gradient: LinearGradient(
                                      colors: instance.gradientColors,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: instance.gradientColors.first.withOpacity(0.4),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  CupertinoIcons.chevron_right,
                  color: GlassTheme.textSecondary.withOpacity(0.5),
                  size: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
