import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/animated_card.dart';
import '../widgets/gradient_button.dart';
import '../models/food_entry.dart';
import '../services/food_service.dart';

class FoodLogScreen extends StatefulWidget {
  const FoodLogScreen({super.key});

  @override
  _FoodLogScreenState createState() => _FoodLogScreenState();
}

class _FoodLogScreenState extends State<FoodLogScreen> {
  List<MealEntry> _todayMeals = [];
  Map<String, int> _todayNutrition = {};
  bool _isLoading = true;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadTodayData();
  }

  Future<void> _loadTodayData() async {
    try {
      final meals = await FoodService.getMealEntriesForDate(_selectedDate);
      final nutrition = await FoodService.getTodayNutrition();
      
      setState(() {
        _todayMeals = meals;
        _todayNutrition = nutrition;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppTheme.lightGray,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.lightGray,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            // Header
            _buildHeader(),
            const SizedBox(height: 32),

            // Date Selector
            _buildDateSelector(),
            const SizedBox(height: 32),

            // Nutrition Summary
            _buildNutritionSummary(),
            const SizedBox(height: 32),

            // Meals
            _buildMealsSection(),
            const SizedBox(height: 100), // Bottom padding
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMealDialog(),
        backgroundColor: AppTheme.primaryGreen,
        child: const Icon(Icons.add, color: AppTheme.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.secondaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.mediumShadow,
      ),
      child: Row(
        children: [
          const Icon(Icons.restaurant, color: AppTheme.white, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nutrition Tracker',
                  style: TextStyle(
                    color: AppTheme.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Fuel your body right',
                  style: TextStyle(
                    color: AppTheme.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.analytics_outlined,
              color: AppTheme.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return AnimatedCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _selectedDate = _selectedDate.subtract(const Duration(days: 1));
              });
              _loadTodayData();
            },
            icon: const Icon(Icons.chevron_left, color: AppTheme.primaryBlue),
          ),
          Text(
            '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed: _selectedDate.isBefore(DateTime.now()) ? () {
              setState(() {
                _selectedDate = _selectedDate.add(const Duration(days: 1));
              });
              _loadTodayData();
            } : null,
            icon: Icon(
              Icons.chevron_right, 
              color: _selectedDate.isBefore(DateTime.now()) 
                  ? AppTheme.primaryBlue 
                  : AppTheme.mediumGray,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionSummary() {
    final calories = _todayNutrition['calories'] ?? 0;
    final protein = _todayNutrition['protein'] ?? 0;
    final carbs = _todayNutrition['carbs'] ?? 0;
    final fat = _todayNutrition['fat'] ?? 0;

    return AnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today\'s Nutrition',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Calories
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.orange.withOpacity(0.1), AppTheme.orange.withOpacity(0.05)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.local_fire_department, color: AppTheme.orange, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Calories',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  '$calories kcal',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.orange,
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Macros
          Row(
            children: [
              Expanded(
                child: _buildMacroCard('Protein', '${protein}g', Colors.red[400]!),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMacroCard('Carbs', '${carbs}g', AppTheme.primaryBlue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMacroCard('Fat', '${fat}g', AppTheme.yellow),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealsSection() {
    final mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meals',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        
        Column(
          children: mealTypes.map((mealType) {
            final mealsForType = _todayMeals.where((meal) => 
              meal.mealType.toLowerCase() == mealType.toLowerCase()
            ).toList();
            
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: _buildMealTypeCard(mealType, mealsForType),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildMealTypeCard(String mealType, List<MealEntry> meals) {
    final totalCalories = meals.fold<int>(0, (sum, meal) => (sum ?? 0) + (meal.totalCalories ?? 0));
    final mealIcon = _getMealIcon(mealType);
    final mealColor = _getMealColor(mealType);
    
    return AnimatedCard(
      padding: EdgeInsets.zero,
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: mealColor.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: mealColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(mealIcon, color: mealColor, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    mealType,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: mealColor,
                    ),
                  ),
                ),
                Text(
                  '$totalCalories cal',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: mealColor,
                  ),
                ),
              ],
            ),
          ),
          
          // Meals
          if (meals.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No ${mealType.toLowerCase()} logged yet',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            Column(
              children: meals.map((meal) => 
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: meal.foods.map((foodWithQuantity) => 
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${foodWithQuantity.foodEntry.name} (${foodWithQuantity.quantity}x)',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Text(
                              '${(foodWithQuantity.foodEntry.calories * foodWithQuantity.quantity).round()} cal',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                                color: AppTheme.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      )
                    ).toList(),
                  ),
                )
              ).toList(),
            ),
        ],
      ),
    );
  }

  IconData _getMealIcon(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return Icons.free_breakfast;
      case 'lunch':
        return Icons.lunch_dining;
      case 'dinner':
        return Icons.dinner_dining;
      case 'snacks':
        return Icons.cookie;
      default:
        return Icons.restaurant;
    }
  }

  Color _getMealColor(String mealType) {
    switch (mealType.toLowerCase()) {
      case 'breakfast':
        return AppTheme.orange;
      case 'lunch':
        return AppTheme.primaryGreen;
      case 'dinner':
        return AppTheme.primaryBlue;
      case 'snacks':
        return AppTheme.purple;
      default:
        return AppTheme.textSecondary;
    }
  }

  void _showAddMealDialog() {
    showDialog(
      context: context,
      builder: (context) => AddMealDialog(
        selectedDate: _selectedDate,
        onMealAdded: () {
          _loadTodayData();
        },
      ),
    );
  }
}

class AddMealDialog extends StatefulWidget {
  final DateTime selectedDate;
  final VoidCallback onMealAdded;

  const AddMealDialog({
    super.key,
    required this.selectedDate,
    required this.onMealAdded,
  });

  @override
  _AddMealDialogState createState() => _AddMealDialogState();
}

class _AddMealDialogState extends State<AddMealDialog> {
  String _selectedMealType = 'Breakfast';
  List<FoodEntry> _availableFoods = [];
  final List<FoodEntryWithQuantity> _selectedFoods = [];
  bool _isLoading = true;
  final _searchController = TextEditingController();

  final List<String> _mealTypes = ['Breakfast', 'Lunch', 'Dinner', 'Snacks'];

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFoods() async {
    try {
      final foods = await FoodService.getFoodDatabase();
      setState(() {
        _availableFoods = foods;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _searchFoods(String query) async {
    try {
      final foods = await FoodService.searchFood(query);
      setState(() {
        _availableFoods = foods;
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: AppTheme.white,
      child: Container(
        width: double.maxFinite,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Meal',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close, color: AppTheme.textSecondary),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Meal Type Selector
            DropdownButtonFormField<String>(
              value: _selectedMealType,
              decoration: const InputDecoration(
                labelText: 'Meal Type',
              ),
              items: _mealTypes.map((type) => 
                DropdownMenuItem(
                  value: type,
                  child: Text(type),
                )
              ).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMealType = value!;
                });
              },
            ),
            
            const SizedBox(height: 20),
            
            // Search
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Foods',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _searchFoods,
            ),
            
            const SizedBox(height: 20),
            
            // Selected Foods
            if (_selectedFoods.isNotEmpty) ...[
              Text(
                'Selected Foods:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  itemCount: _selectedFoods.length,
                  itemBuilder: (context, index) {
                    final foodWithQuantity = _selectedFoods[index];
                    return ListTile(
                      title: Text(foodWithQuantity.foodEntry.name),
                      subtitle: Text('Quantity: ${foodWithQuantity.quantity}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _selectedFoods.removeAt(index);
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
            
            // Available Foods
            Text(
              'Available Foods:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: _availableFoods.length,
                      itemBuilder: (context, index) {
                        final food = _availableFoods[index];
                        return ListTile(
                          title: Text(food.name),
                          subtitle: Text('${food.calories} cal • ${food.category}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: AppTheme.primaryGreen),
                            onPressed: () => _showQuantityDialog(food),
                          ),
                        );
                      },
                    ),
            ),
            
            const SizedBox(height: 24),
            
            // Save Button
            SizedBox(
              width: double.infinity,
              child: GradientButton(
                text: 'Save Meal',
                onPressed: _selectedFoods.isNotEmpty ? _saveMeal : null,
                gradient: AppTheme.secondaryGradient,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuantityDialog(FoodEntry food) {
    final quantityController = TextEditingController(text: '1');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Add ${food.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Serving size: ${food.servingSize}'),
            const SizedBox(height: 16),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: 'Quantity',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () {
              final quantity = double.tryParse(quantityController.text) ?? 1.0;
              setState(() {
                _selectedFoods.add(FoodEntryWithQuantity(
                  foodEntry: food,
                  quantity: quantity,
                ));
              });
              Navigator.pop(context);
            },
            child: const Text('Add', style: TextStyle(color: AppTheme.primaryBlue)),
          ),
        ],
      ),
    );
  }

  Future<void> _saveMeal() async {
    try {
      final meal = MealEntry(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        date: widget.selectedDate,
        mealType: _selectedMealType,
        foods: _selectedFoods,
      );

      await FoodService.addMealEntry(meal);
      
      widget.onMealAdded();
      Navigator.pop(context);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Meal added successfully!'),
          backgroundColor: AppTheme.primaryGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add meal'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}