import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auto_route/auto_route.dart';
import '../../cubits/task/task_cubit.dart';
import '../../models/task_model.dart';
import '../../utils/app_enums.dart';
import '../../widgets/category_selector.dart';
import '../../utils/theme_constants.dart';

@RoutePage()
class EditTaskScreen extends StatefulWidget {
  final Task task;

  EditTaskScreen({super.key, required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _titleController;

  late List<String> selectedCategories;
  late Difficulty difficulty;
  late bool isPositive;
  late RepeatInterval repeat;
  late int interval;
  late DateTime dueDate;
  late int cost;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);

    selectedCategories = List<String>.from(widget.task.categoryIds);
    difficulty = widget.task.difficulty ?? Difficulty.medium;
    isPositive = widget.task.isPositive ?? true;
    repeat = widget.task.repeat ?? RepeatInterval.daily;
    interval = widget.task.interval ?? 1;
    dueDate =
        widget.task.dueDate ?? DateTime.now().add(const Duration(days: 1));
    cost = widget.task.cost ?? 1;
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _saveTask() {
    Task updatedTask;

    switch (widget.task.type) {
      case TaskType.habit:
        updatedTask = widget.task.copyWith(
          title: _titleController.text.trim(),
          categoryIds: selectedCategories,
          difficulty: difficulty,
          isPositive: isPositive,
        );
        break;
      case TaskType.daily:
        updatedTask = widget.task.copyWith(
          title: _titleController.text.trim(),
          categoryIds: selectedCategories,
          difficulty: difficulty,
          repeat: repeat,
          interval: interval,
        );
        break;
      case TaskType.todo:
        updatedTask = widget.task.copyWith(
          title: _titleController.text.trim(),
          categoryIds: selectedCategories,
          difficulty: difficulty,
          dueDate: dueDate,
        );
        break;
      case TaskType.reward:
        updatedTask = widget.task.copyWith(
          title: _titleController.text.trim(),
          categoryIds: selectedCategories,
          cost: cost,
        );
        break;
    }

    context.read<TaskCubit>().updateTask(updatedTask);
    context.router.pop();
  }

  String get _screenTitle {
    switch (widget.task.type) {
      case TaskType.habit:
        return 'Зуршил засах';
      case TaskType.daily:
        return 'Даалгавар засах';
      case TaskType.todo:
        return 'Зорилго засах';
      case TaskType.reward:
        return 'Урамшуулал засах';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screenTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.router.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Гарчиг',
              style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              decoration: AppTheme.inputDecoration(),
              style: const TextStyle(color: AppTheme.textPrimary),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Гарчиг заавал оруулна уу';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            _buildTaskTypeSpecificFields(),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _saveTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Хадгалах',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                context.read<TaskCubit>().deleteTask(widget.task);
                context.router.pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: AppTheme.negativeRed,
              ),
              child: const Center(
                child: Text(
                  'Устгах',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskTypeSpecificFields() {
    switch (widget.task.type) {
      case TaskType.habit:
        return _buildHabitFields();
      case TaskType.daily:
        return _buildDailyFields();
      case TaskType.todo:
        return _buildTodoFields();
      case TaskType.reward:
        return _buildRewardFields();
    }
  }

  Widget _buildHabitFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Тохируулга',
          style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isPositive = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color:
                          isPositive
                              ? AppTheme.accentPurple
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_circle,
                            color:
                                isPositive
                                    ? Colors.white
                                    : AppTheme.accentPurple,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Эерэг',
                            style: TextStyle(
                              color:
                                  isPositive
                                      ? Colors.white
                                      : AppTheme.accentPurple,
                              fontWeight:
                                  isPositive
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isPositive = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color:
                          !isPositive
                              ? AppTheme.accentPurple
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.remove_circle,
                            color:
                                !isPositive
                                    ? Colors.white
                                    : AppTheme.accentPurple,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Сөрөг',
                            style: TextStyle(
                              color:
                                  !isPositive
                                      ? Colors.white
                                      : AppTheme.accentPurple,
                              fontWeight:
                                  !isPositive
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Хүндрэл',
          style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDifficultyOption(Difficulty.easy, 'Амархан', '✦'),
              _buildDifficultyOption(Difficulty.medium, 'Дундаж', '✦✦'),
              _buildDifficultyOption(Difficulty.hard, 'Хэцүү', '✦✦✦'),
            ],
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Төрөл',
          style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: CategorySelector(
            selectedCategoryIds: selectedCategories,
            onCategoriesChanged: (categories) {
              setState(() {
                selectedCategories = categories;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDailyFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Хувaарь',
          style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Давтамж:',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 150,
                    decoration: BoxDecoration(
                      color: AppTheme.darkBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<RepeatInterval>(
                        value: repeat,
                        dropdownColor: AppTheme.darkBackground,
                        style: TextStyle(color: AppTheme.textPrimary),
                        items: [
                          DropdownMenuItem<RepeatInterval>(
                            value: RepeatInterval.daily,
                            child: const Text('Өдөр'),
                          ),
                          DropdownMenuItem<RepeatInterval>(
                            value: RepeatInterval.weekly,
                            child: const Text('Долоо хоног'),
                          ),
                          DropdownMenuItem<RepeatInterval>(
                            value: RepeatInterval.monthly,
                            child: const Text('Сар'),
                          ),
                        ],
                        onChanged: (RepeatInterval? newValue) {
                          if (newValue != null) {
                            setState(() {
                              repeat = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              Container(
                height: 1,
                color: AppTheme.textSecondary.withValues(alpha: 0.2),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Text(
                    'Интервал:',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppTheme.darkBackground,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<int>(
                        value: interval,
                        dropdownColor: AppTheme.darkBackground,
                        style: TextStyle(color: AppTheme.textPrimary),
                        items: _getIntervalOptions().map((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value'),
                          );
                        }).toList(),
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            setState(() {
                              interval = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Хүндрэл',
          style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDifficultyOption(Difficulty.easy, 'Амархан', '✦'),
              _buildDifficultyOption(Difficulty.medium, 'Дундаж', '✦✦'),
              _buildDifficultyOption(Difficulty.hard, 'Хэцүү', '✦✦✦'),
            ],
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Төрөл',
          style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: CategorySelector(
            selectedCategoryIds: selectedCategories,
            onCategoriesChanged: (categories) {
              setState(() {
                selectedCategories = categories;
              });
            },
          ),
        ),
      ],
    );
  }

  List<int> _getIntervalOptions() {
    switch (repeat) {
      case RepeatInterval.daily:
        return List.generate(10, (index) => index + 1);
      case RepeatInterval.weekly:
        return List.generate(4, (index) => index + 1);
      case RepeatInterval.monthly:
        return List.generate(12, (index) => index + 1);
    }
  }

  Widget _buildTodoFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Хугацаа',
          style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: InkWell(
            onTap: () async {
              final pickedDate = await showDatePicker(
                context: context,
                initialDate: dueDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.dark(
                        primary: AppTheme.accentPurple,
                        onPrimary: Colors.white,
                        surface: AppTheme.cardBackground,
                        onSurface: Colors.white,
                      ), dialogTheme: DialogThemeData(backgroundColor: AppTheme.darkBackground),
                    ),
                    child: child!,
                  );
                },
              );

              if (pickedDate != null) {
                setState(() {
                  dueDate = pickedDate;
                });
              }
            },
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: AppTheme.accentPurple,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  '${dueDate.day}/${dueDate.month}/${dueDate.year}',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.textSecondary,
                  size: 16,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Хүндрэл',
          style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildDifficultyOption(Difficulty.easy, 'Амархан', '✦'),
              _buildDifficultyOption(Difficulty.medium, 'Дундаж', '✦✦'),
              _buildDifficultyOption(Difficulty.hard, 'Хэцүү', '✦✦✦'),
            ],
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Төрөл',
          style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: CategorySelector(
            selectedCategoryIds: selectedCategories,
            onCategoriesChanged: (categories) {
              setState(() {
                selectedCategories = categories;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRewardFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Үнэ',
          style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.remove_circle,
                  color: AppTheme.accentPurple,
                  size: 28,
                ),
                onPressed: () {
                  setState(() {
                    if (cost > 1) {
                      cost--;
                    }
                  });
                },
              ),
              const SizedBox(width: 16),
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.darkBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: AppTheme.coinOrange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      cost.toString(),
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(
                  Icons.add_circle,
                  color: AppTheme.accentPurple,
                  size: 28,
                ),
                onPressed: () {
                  setState(() {
                    cost++;
                  });
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        const Text(
          'Төрөл',
          style: TextStyle(fontSize: 14, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: CategorySelector(
            selectedCategoryIds: selectedCategories,
            onCategoriesChanged: (categories) {
              setState(() {
                selectedCategories = categories;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDifficultyOption(Difficulty value, String label, String stars) {
    return GestureDetector(
      onTap: () {
        setState(() {
          difficulty = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: difficulty == value ? Border.all(color: AppTheme.accentPurple) : null,
        ),
        child: Column(
          children: [
            Text(
              stars,
              style: TextStyle(
                color: AppTheme.accentPurple,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 12,
                fontWeight: difficulty == value ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
