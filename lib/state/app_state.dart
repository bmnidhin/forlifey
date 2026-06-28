import 'package:flutter/material.dart';
import '../models/checklist.dart';

class AppState extends ChangeNotifier {
  // Predefined templates
  final List<ChecklistTemplate> templates = [
    const ChecklistTemplate(
      id: 'morning_routine',
      title: 'Morning Routine',
      description: 'Start your day with energy, focus, and clarity.',
      icon: '🌅',
      category: 'Productivity',
      gradientColors: [Color(0xFFFF9500), Color(0xFFFF9500)],
      items: [
        ChecklistTemplateItem(id: 'mr_1', title: 'Drink a large glass of water', description: 'Rehydrate after a long sleep.'),
        ChecklistTemplateItem(id: 'mr_2', title: 'Stretch or Yoga (10 mins)', description: 'Awaken your muscles and joints.'),
        ChecklistTemplateItem(id: 'mr_3', title: 'Mindful Meditation (5 mins)', description: 'Center your mind for the day.'),
        ChecklistTemplateItem(id: 'mr_4', title: 'Write down top 3 daily goals', description: 'Focus on what truly matters today.'),
        ChecklistTemplateItem(id: 'mr_5', title: 'Eat a nutritious breakfast', description: 'Fuel your body with healthy foods.'),
      ],
    ),
    const ChecklistTemplate(
      id: 'travel_packing',
      title: 'Travel Packing Essentials',
      description: 'Never forget your important gear when going on a trip.',
      icon: '✈️',
      category: 'Travel',
      gradientColors: [Color(0xFF007AFF), Color(0xFF007AFF)],
      items: [
        ChecklistTemplateItem(id: 'tp_1', title: 'Passport / ID & Wallet', description: 'Essential documents and cash/cards.'),
        ChecklistTemplateItem(id: 'tp_2', title: 'Phone, Laptop & Chargers', description: 'Keep all your electronic devices powered.'),
        ChecklistTemplateItem(id: 'tp_3', title: 'Toiletries & Personal Hygiene', description: 'Toothbrush, skincare, deodorant, etc.'),
        ChecklistTemplateItem(id: 'tp_4', title: 'Clothing (planned by day count)', description: 'Socks, underwear, shirts, and pants.'),
        ChecklistTemplateItem(id: 'tp_5', title: 'First-aid & Medications', description: 'Painkillers, band-aids, prescriptions.'),
        ChecklistTemplateItem(id: 'tp_6', title: 'Universal plug adapter', description: 'For international sockets.'),
      ],
    ),
    const ChecklistTemplate(
      id: 'dev_release',
      title: 'Developer Release Checklist',
      description: 'Ensure a smooth and bug-free release cycle.',
      icon: '💻',
      category: 'Work',
      gradientColors: [Color(0xFF5856D6), Color(0xFF5856D6)],
      items: [
        ChecklistTemplateItem(id: 'dr_1', title: 'Run all unit and integration tests', description: 'Make sure no existing code is broken.'),
        ChecklistTemplateItem(id: 'dr_2', title: 'Perform static code analysis', description: 'Run lints and formatting checks.'),
        ChecklistTemplateItem(id: 'dr_3', title: 'Update project versioning', description: 'Increment version in pubspec.yaml.'),
        ChecklistTemplateItem(id: 'dr_4', title: 'Review pull request descriptions', description: 'Clear changelogs and document dependencies.'),
        ChecklistTemplateItem(id: 'dr_5', title: 'Verify release build builds locally', description: 'Test building release APK/IPA/Bundle.'),
        ChecklistTemplateItem(id: 'dr_6', title: 'Draft Github release notes', description: 'Summarize user-facing improvements.'),
      ],
    ),
    const ChecklistTemplate(
      id: 'gym_workout',
      title: 'Full Body Gym Workout',
      description: 'A balanced, effective full-body training session.',
      icon: '🏋️‍♂️',
      category: 'Health',
      gradientColors: [Color(0xFFFF2D55), Color(0xFFFF2D55)],
      items: [
        ChecklistTemplateItem(id: 'gw_1', title: 'Cardio Warm-up (5-10 mins)', description: 'Treadmill, rowing, or dynamic stretching.'),
        ChecklistTemplateItem(id: 'gw_2', title: 'Barbell Squats (3 sets x 10 reps)', description: 'Focus on depth and clean form.'),
        ChecklistTemplateItem(id: 'gw_3', title: 'Flat Bench Press (3 sets x 10 reps)', description: 'Controlled descent and push.'),
        ChecklistTemplateItem(id: 'gw_4', title: 'Barbell Rows (3 sets x 12 reps)', description: 'Keep your spine neutral and squeeze shoulder blades.'),
        ChecklistTemplateItem(id: 'gw_5', title: 'Planks (3 sets x 1 min)', description: 'Keep your core engaged throughout.'),
        ChecklistTemplateItem(id: 'gw_6', title: 'Cool-down stretches', description: 'Hold each stretch for 20-30 seconds.'),
      ],
    ),
    const ChecklistTemplate(
      id: 'sunday_clean',
      title: 'Sunday Deep Clean',
      description: 'Reset your living space for a fresh start to the week.',
      icon: '🧹',
      category: 'Home',
      gradientColors: [Color(0xFF34C759), Color(0xFF34C759)],
      items: [
        ChecklistTemplateItem(id: 'sc_1', title: 'Wash bedsheets and towels', description: 'Get them cycling in the machine first.'),
        ChecklistTemplateItem(id: 'sc_2', title: 'Vacuum and mop all floors', description: 'Clear dust from rugs and hard floors.'),
        ChecklistTemplateItem(id: 'sc_3', title: 'Dust surfaces & shelves', description: 'Wipe down tables, shelves, and electronics.'),
        ChecklistTemplateItem(id: 'sc_4', title: 'Clean bathroom sink & mirror', description: 'Sanitize key bathroom fixtures.'),
        ChecklistTemplateItem(id: 'sc_5', title: 'Empty all trash cans', description: 'Take the trash out to the main bins.'),
        ChecklistTemplateItem(id: 'sc_6', title: 'Wipe down kitchen counters', description: 'Keep food prep areas clean.'),
      ],
    ),
    const ChecklistTemplate(
      id: 'deep_work',
      title: 'Deep Work Setup',
      description: 'Minimize distractions and enter flow state quickly.',
      icon: '🧘',
      category: 'Productivity',
      gradientColors: [Color(0xFF30B0C7), Color(0xFF30B0C7)],
      items: [
        ChecklistTemplateItem(id: 'dw_1', title: 'Put phone in Do Not Disturb', description: 'Place it face down or in another room.'),
        ChecklistTemplateItem(id: 'dw_2', title: 'Close unrelated browser tabs', description: 'Remove distractions and visual clutter.'),
        ChecklistTemplateItem(id: 'dw_3', title: 'Fill a large glass/bottle of water', description: 'Stay hydrated without leaving your desk.'),
        ChecklistTemplateItem(id: 'dw_4', title: 'Start a focus timer (90 mins)', description: 'Commit to uninterrupted focus.'),
        ChecklistTemplateItem(id: 'dw_5', title: 'Put on focus soundscapes/music', description: 'Binaural beats, ambient, or lo-fi.'),
      ],
    ),
  ];

  // User's active checklist instances
  final List<ChecklistInstance> _instances = [];

  List<ChecklistInstance> get instances => List.unmodifiable(_instances);

  // Instantiates a checklist from template
  ChecklistInstance instantiateTemplate(ChecklistTemplate template) {
    final instanceItems = template.items.map((item) {
      return ChecklistInstanceItem(
        id: '${template.id}_inst_${DateTime.now().millisecondsSinceEpoch}_${item.id}',
        title: item.title,
        isCompleted: false,
      );
    }).toList();

    // Generate a unique ID for the checklist instance
    final instanceId = '${template.id}_instance_${DateTime.now().millisecondsSinceEpoch}';

    // Count duplicate titles to append a number if necessary
    final existingWithTitle = _instances.where((i) => i.title.startsWith(template.title)).length;
    final displayTitle = existingWithTitle > 0 
        ? '${template.title} (${existingWithTitle + 1})' 
        : template.title;

    final instance = ChecklistInstance(
      id: instanceId,
      templateId: template.id,
      title: displayTitle,
      icon: template.icon,
      gradientColors: template.gradientColors,
      items: instanceItems,
      createdAt: DateTime.now(),
    );

    _instances.add(instance);
    notifyListeners();
    return instance;
  }

  // Toggle item completion
  void toggleItem(String instanceId, String itemId) {
    final instanceIndex = _instances.indexWhere((i) => i.id == instanceId);
    if (instanceIndex != -1) {
      final itemIndex = _instances[instanceIndex].items.indexWhere((item) => item.id == itemId);
      if (itemIndex != -1) {
        _instances[instanceIndex].items[itemIndex].isCompleted = 
            !_instances[instanceIndex].items[itemIndex].isCompleted;
        notifyListeners();
      }
    }
  }

  // Add custom item to instance
  void addItemToInstance(String instanceId, String title) {
    if (title.trim().isEmpty) return;
    final instanceIndex = _instances.indexWhere((i) => i.id == instanceId);
    if (instanceIndex != -1) {
      final newItem = ChecklistInstanceItem(
        id: 'custom_item_${DateTime.now().millisecondsSinceEpoch}',
        title: title.trim(),
        isCompleted: false,
      );
      _instances[instanceIndex].items.add(newItem);
      notifyListeners();
    }
  }

  // Remove item from instance
  void removeItemFromInstance(String instanceId, String itemId) {
    final instanceIndex = _instances.indexWhere((i) => i.id == instanceId);
    if (instanceIndex != -1) {
      _instances[instanceIndex].items.removeWhere((item) => item.id == itemId);
      notifyListeners();
    }
  }

  // Delete checklist instance
  void deleteInstance(String instanceId) {
    _instances.removeWhere((i) => i.id == instanceId);
    notifyListeners();
  }

  // Reset checklist instance (uncheck all items)
  void resetInstance(String instanceId) {
    final instanceIndex = _instances.indexWhere((i) => i.id == instanceId);
    if (instanceIndex != -1) {
      for (var item in _instances[instanceIndex].items) {
        item.isCompleted = false;
      }
      notifyListeners();
    }
  }
}

class AppStateProvider extends InheritedNotifier<AppState> {
  const AppStateProvider({
    super.key,
    required AppState super.notifier,
    required super.child,
  });

  static AppState of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AppStateProvider>();
    assert(provider != null, 'No AppStateProvider found in context');
    return provider!.notifier!;
  }
}
