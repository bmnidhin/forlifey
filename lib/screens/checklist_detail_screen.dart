import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/checklist.dart';
import '../state/app_state.dart';
import '../theme/glass_theme.dart';
import '../widgets/glass_card.dart';
import '../widgets/glass_checkbox.dart';
import '../widgets/liquid_background.dart';

class ProgressRingPainter extends CustomPainter {
  final double progress;
  final List<Color> colors;

  ProgressRingPainter({required this.progress, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 10.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background track
    final trackPaint = Paint()
      ..color = Colors.black.withOpacity(0.06)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, trackPaint);

    // Draw progress arc
    final rect = Rect.fromCircle(center: center, radius: radius);
    const startAngle = -math.pi / 2;
    final sweepAngle = 2 * math.pi * progress;

    if (progress > 0) {
      final progressPaint = Paint()
        ..shader = SweepGradient(
          colors: colors,
          startAngle: 0.0,
          endAngle: math.pi * 2,
          transform: const GradientRotation(-math.pi / 2),
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(rect, startAngle, sweepAngle, false, progressPaint);
    }
  }

  @override
  bool shouldRepaint(covariant ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.colors != colors;
  }
}

class LiquidProgressRing extends StatelessWidget {
  final double progress;
  final List<Color> colors;
  final Widget child;

  const LiquidProgressRing({
    super.key,
    required this.progress,
    required this.colors,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.0, end: progress),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
      builder: (context, animValue, _) {
        return Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 140,
              height: 140,
              child: CustomPaint(
                painter: ProgressRingPainter(
                  progress: animValue,
                  colors: colors,
                ),
              ),
            ),
            child,
          ],
        );
      },
    );
  }
}

class ChecklistDetailScreen extends StatefulWidget {
  final String instanceId;

  const ChecklistDetailScreen({
    super.key,
    required this.instanceId,
  });

  @override
  State<ChecklistDetailScreen> createState() => _ChecklistDetailScreenState();
}

class _ChecklistDetailScreenState extends State<ChecklistDetailScreen> {
  final TextEditingController _addItemController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _addItemController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _confirmDelete(BuildContext context, AppState state, ChecklistInstance instance) {
    showCupertinoDialog(
      context: context,
      builder: (dialogContext) {
        return CupertinoAlertDialog(
          title: const Text('Delete Checklist'),
          content: Text('Are you sure you want to delete "${instance.title}"? This cannot be undone.'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(dialogContext),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(dialogContext); // Close dialog
                state.deleteInstance(widget.instanceId);
                Navigator.pop(context); // Close screen
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _addNewItem(AppState state) {
    final text = _addItemController.text.trim();
    if (text.isNotEmpty) {
      state.addItemToInstance(widget.instanceId, text);
      _addItemController.clear();
      // Scroll to bottom
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);
    final instances = state.instances;
    final instanceIndex = instances.indexWhere((i) => i.id == widget.instanceId);

    // If the instance was deleted, handle safely
    if (instanceIndex == -1) {
      return const SizedBox.shrink();
    }

    final instance = instances[instanceIndex];
    final progress = instance.progress;
    final percent = (progress * 100).toInt();

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
          actions: [
            IconButton(
              icon: const Icon(CupertinoIcons.refresh, color: GlassTheme.textPrimary),
              tooltip: 'Reset Checklist',
              onPressed: () => state.resetInstance(widget.instanceId),
            ),
            IconButton(
              icon: const Icon(CupertinoIcons.trash, color: GlassTheme.textPrimary),
              tooltip: 'Delete Checklist',
              onPressed: () => _confirmDelete(context, state, instance),
            ),
          ],
          title: Text(
            instance.title,
            style: GlassTheme.headline,
            overflow: TextOverflow.ellipsis,
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Progress Header Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: GlassCard(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                child: Row(
                  children: [
                    LiquidProgressRing(
                      progress: progress,
                      colors: instance.gradientColors,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '$percent%',
                            style: GlassTheme.title1.copyWith(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'done',
                            style: GlassTheme.footnote,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Emoji Title row
                          Row(
                            children: [
                              Text(
                                instance.icon,
                                style: const TextStyle(fontSize: 24),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  instance.title,
                                  style: GlassTheme.title2.copyWith(fontSize: 20),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Keep going! You have completed ${instance.completedCount} out of ${instance.totalCount} items.',
                            style: GlassTheme.subhead.copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Scrollable Items List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
                itemCount: instance.items.length + 1,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  // The last item is the Add Item input field
                  if (index == instance.items.length) {
                    return _buildAddItemCard(state);
                  }

                  final item = instance.items[index];
                  return _buildItemCard(state, item, instance);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(AppState state, ChecklistInstanceItem item, ChecklistInstance instance) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Dismissible(
        key: Key(item.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.3),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(CupertinoIcons.trash, color: Colors.white),
        ),
        onDismissed: (direction) {
          state.removeItemFromInstance(widget.instanceId, item.id);
        },
        child: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          onTap: () {
            state.toggleItem(widget.instanceId, item.id);
          },
          child: Row(
            children: [
              // Custom Animated Glass Checkbox
              IgnorePointer(
                child: GlassCheckbox(
                  value: item.isCompleted,
                  activeColor: instance.gradientColors.first,
                  onChanged: (val) {},
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    fontSize: 16,
                    color: item.isCompleted 
                        ? GlassTheme.textSecondary.withOpacity(0.5) 
                        : GlassTheme.textPrimary,
                    decoration: item.isCompleted 
                        ? TextDecoration.lineThrough 
                        : TextDecoration.none,
                    decorationColor: GlassTheme.textSecondary.withOpacity(0.3),
                    fontWeight: FontWeight.w500,
                  ),
                  child: Text(item.title),
                ),
              ),
              const SizedBox(width: 8),
              // Manual delete action for non-touchpad desktop builds
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(CupertinoIcons.clear, color: GlassTheme.textSecondary.withOpacity(0.4), size: 16),
                onPressed: () {
                  state.removeItemFromInstance(widget.instanceId, item.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddItemCard(AppState state) {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 24),
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        opacity: 0.05,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _addItemController,
                style: const TextStyle(color: GlassTheme.textPrimary, fontSize: 16),
                decoration: InputDecoration(
                  hintText: 'Add custom item...',
                  hintStyle: TextStyle(color: GlassTheme.textSecondary.withOpacity(0.4), fontSize: 16),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
                textCapitalization: TextCapitalization.sentences,
                onSubmitted: (value) => _addNewItem(state),
              ),
            ),
            IconButton(
              icon: Icon(CupertinoIcons.add_circled_solid, color: GlassTheme.secondaryAccent),
              onPressed: () => _addNewItem(state),
            ),
          ],
        ),
      ),
    );
  }
}
