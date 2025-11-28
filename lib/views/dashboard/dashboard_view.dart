import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../../models/habit_model.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<DashboardViewModel>().loadHabits();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DashboardViewModel(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            'Meus Hábitos',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications, color: Colors.teal[700]),
              onPressed: () {
                Navigator.pushNamed(context, '/notifications');
              },
            ),
            IconButton(
              icon: Icon(Icons.account_circle, color: Colors.teal[700]),
              onPressed: () {
                // TODO: Abrir perfil
              },
            ),
          ],
        ),
        body: Consumer<DashboardViewModel>(
          builder: (context, viewModel, _) {
            if (viewModel.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Seção de Progresso
                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Progresso Diário',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${viewModel.completedHabits}/${viewModel.totalHabits} hábitos',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal[700],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${viewModel.progressPercentage.toStringAsFixed(0)}% concluído',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.teal[50],
                              ),
                              child: Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: CircularProgressIndicator(
                                        value: viewModel.progressPercentage / 100,
                                        strokeWidth: 8,
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.teal[700]!,
                                        ),
                                        backgroundColor: Colors.grey[300],
                                      ),
                                    ),
                                    Text(
                                      '${viewModel.progressPercentage.toStringAsFixed(0)}%',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.teal[700],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Seção de Hábitos
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Seus Hábitos',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  if (viewModel.habits.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          children: [
                            Icon(
                              Icons.inbox,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Nenhum hábito criado ainda',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: viewModel.habits.length,
                      itemBuilder: (context, index) {
                        final habit = viewModel.habits[index];
                        return HabitCard(
                          habit: habit,
                          onTap: () {
                            // TODO: Navegar para detalhes do hábito
                          },
                          onToggle: () {
                            viewModel.toggleHabit(habit.id);
                          },
                        );
                      },
                    ),
                  
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal[700],
          onPressed: () {
            Navigator.pushNamed(context, '/habit-creation');
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
            BottomNavigationBarItem(icon: Icon(Icons.trending_up), label: 'Progresso'),
            BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Conquistas'),
          ],
          onTap: (index) {
            setState(() => _selectedIndex = index);
            switch (index) {
              case 0:
                // Já estamos na dashboard
                break;
              case 1:
                Navigator.pushNamed(context, '/progress');
                break;
              case 2:
                Navigator.pushNamed(context, '/gamification');
                break;
            }
          },
        ),
      ),
    );
  }
}

// Widget customizado para cada card de hábito
class HabitCard extends StatelessWidget {
  final Habit habit;
  final VoidCallback onTap;
  final VoidCallback onToggle;

  const HabitCard({
    Key? key,
    required this.habit,
    required this.onTap,
    required this.onToggle,
  }) : super(key: key);

  IconData _getHabitIcon(String habitName) {
    habitName = habitName.toLowerCase();
    if (habitName.contains('água')) return Icons.water_drop;
    if (habitName.contains('ler') || habitName.contains('leitura')) return Icons.auto_stories;
    if (habitName.contains('medit')) return Icons.self_improvement;
    if (habitName.contains('corrida') || habitName.contains('exerc')) return Icons.directions_run;
    return Icons.favorite;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.teal[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getHabitIcon(habit.name),
                color: Colors.teal[700],
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${habit.time} - ${habit.frequency}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onToggle,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: habit.isCompleted ? Colors.teal[100] : Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  habit.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: habit.isCompleted ? Colors.teal[700] : Colors.grey[400],
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
