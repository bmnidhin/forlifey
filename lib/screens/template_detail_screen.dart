import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/checklist.dart';
import '../state/app_state.dart';
import '../theme/glass_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/liquid_background.dart';
import 'checklist_detail_screen.dart';

class TemplateDetailScreen extends StatelessWidget {
  final ChecklistTemplate template;

  const TemplateDetailScreen({
    super.key,
    required this.template,
  });

  @override
  Widget build(BuildContext context) {
    return LiquidBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back, color: GlassTheme.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Template Preview',
            style: GlassTheme.headline,
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
              physics: const BouncingScrollPhysics(),
              children: [
                // Header Glass Card
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Emoji
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: template.gradientColors,
                          ),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: template.gradientColors.first.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            template.icon,
                            style: const TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        template.title,
                        style: GlassTheme.title1,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black.withOpacity(0.04),
                          border: Border.all(color: Colors.black.withOpacity(0.06)),
                        ),
                        child: Text(
                          template.category.toUpperCase(),
                          style: TextStyle(
                            color: GlassTheme.secondaryAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        template.description,
                        style: GlassTheme.body.copyWith(
                          color: GlassTheme.textSecondary,
                          height: 1.4,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Items Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Text(
                    'CHECKLIST ITEMS (${template.items.length})',
                    style: GlassTheme.footnote.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
                // Items Preview List
                ...template.items.map((item) => _buildPreviewItem(item)),
              ],
            ),
            // Sticky Floating Action Button at bottom
            Positioned(
              left: 24,
              right: 24,
              bottom: 30,
              child: GlassCard(
                borderRadius: 24,
                padding: const EdgeInsets.symmetric(vertical: 16),
                opacity: 0.22,
                borderOpacity: 0.35,
                onTap: () {
                  final state = AppStateProvider.of(context);
                  final instance = state.instantiateTemplate(template);
                  
                  // Navigate directly to detail execution page and replace preview
                  Navigator.pushReplacement(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => ChecklistDetailScreen(instanceId: instance.id),
                    ),
                  );
                },
                child: Center(
                  child: Text(
                    'Use this Template',
                    style: TextStyle(
                      color: GlassTheme.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: -0.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewItem(ChecklistTemplateItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Disabled styled checkbox
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black.withOpacity(0.18),
                  width: 1.5,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: GlassTheme.body.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (item.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.description!,
                      style: GlassTheme.footnote,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
