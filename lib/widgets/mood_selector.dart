import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MoodSelector extends StatefulWidget {
  final int selectedMood;
  final Function(int) onMoodSelected;

  const MoodSelector({
    super.key,
    required this.selectedMood,
    required this.onMoodSelected,
  });

  @override
  State<MoodSelector> createState() => _MoodSelectorState();
}

class _MoodSelectorState extends State<MoodSelector>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _scaleAnimations;

  final List<Map<String, dynamic>> _moods = [
    {'emoji': '😢', 'label': 'Sad', 'color': Colors.red},
    {'emoji': '😔', 'label': 'Down', 'color': Colors.orange},
    {'emoji': '😐', 'label': 'Okay', 'color': Colors.yellow},
    {'emoji': '😊', 'label': 'Good', 'color': AppTheme.primaryGreen},
    {'emoji': '😄', 'label': 'Great', 'color': Colors.green},
  ];

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      _moods.length,
      (index) => AnimationController(
        duration: const Duration(milliseconds: 200),
        vsync: this,
      ),
    );
    _scaleAnimations = _controllers.map((controller) =>
      Tween<double>(begin: 1.0, end: 1.2).animate(
        CurvedAnimation(parent: controller, curve: Curves.elasticOut),
      ),
    ).toList();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How are you feeling today?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_moods.length, (index) {
              final mood = _moods[index];
              final isSelected = widget.selectedMood == index + 1;
              
              return GestureDetector(
                onTap: () {
                  widget.onMoodSelected(index + 1);
                  _controllers[index].forward().then((_) {
                    _controllers[index].reverse();
                  });
                },
                child: AnimatedBuilder(
                  animation: _scaleAnimations[index],
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimations[index].value,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected 
                              ? mood['color'].withOpacity(0.2) 
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected 
                                ? mood['color'] 
                                : AppTheme.mediumGray,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              mood['emoji'],
                              style: const TextStyle(fontSize: 32),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              mood['label'],
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isSelected 
                                    ? mood['color'] 
                                    : AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}