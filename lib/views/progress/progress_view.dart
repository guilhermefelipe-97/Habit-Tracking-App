import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/progress_viewmodel.dart';

class ProgressView extends StatefulWidget {
  const ProgressView({Key? key}) : super(key: key);

  @override
  State<ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  String _selectedPeriod = 'week'; // 'week', 'month', 'year'

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ProgressViewModel>().loadProgressData(_selectedPeriod);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProgressViewModel(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            'Progresso Visual',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Consumer<ProgressViewModel>(
            builder: (context, viewModel, _) {
              if (viewModel.isLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Seletor de Período
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        _PeriodButton(
                          label: 'Semana',
                          value: 'week',
                          isSelected: _selectedPeriod == 'week',
                          onTap: () {
                            setState(() => _selectedPeriod = 'week');
                            viewModel.loadProgressData('week');
                          },
                        ),
                        const SizedBox(width: 8),
                        _PeriodButton(
                          label: 'Mês',
                          value: 'month',
                          isSelected: _selectedPeriod == 'month',
                          onTap: () {
                            setState(() => _selectedPeriod = 'month');
                            viewModel.loadProgressData('month');
                          },
                        ),
                        const SizedBox(width: 8),
                        _PeriodButton(
                          label: 'Ano',
                          value: 'year',
                          isSelected: _selectedPeriod == 'year',
                          onTap: () {
                            setState(() => _selectedPeriod = 'year');
                            viewModel.loadProgressData('year');
                          },
                        ),
                      ],
                    ),
                  ),

                  // Estatísticas Gerais
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
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
                            'Estatísticas',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _StatCard(
                                label: 'Total de Hábitos',
                                value: viewModel.totalHabits.toString(),
                                icon: Icons.check_circle,
                                color: Colors.teal,
                              ),
                              _StatCard(
                                label: 'Taxa de Conclusão',
                                value: '${viewModel.completionRate.toStringAsFixed(0)}%',
                                icon: Icons.trending_up,
                                color: Colors.blue,
                              ),
                              _StatCard(
                                label: 'Melhor Sequência',
                                value: '${viewModel.bestStreak} dias',
                                icon: Icons.local_fire_department,
                                color: Colors.orange,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Gráfico de Barras Semanal
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
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
                            'Progresso por Dia',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _ProgressChart(
                            data: viewModel.dailyProgressData,
                            period: _selectedPeriod,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Calendário
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
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
                            'Calendário de Hábitos',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _HabitCalendar(
                            completedDays: viewModel.completedDays,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Hábitos com Melhor Performance
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Seus Melhores Hábitos',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: viewModel.topHabits.map((habit) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _TopHabitCard(
                            habitName: habit['name'] as String,
                            completionRate: habit['completionRate'] as double,
                            streak: habit['streak'] as int,
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

// Widget para período seletor
class _PeriodButton extends StatelessWidget {
  final String label;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;

  const _PeriodButton({
    required this.label,
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.teal[700] : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Widget para card de estatística
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Widget para gráfico de progresso
class _ProgressChart extends StatelessWidget {
  final List<double> data;
  final String period;

  const _ProgressChart({
    required this.data,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    double maxValue = data.isEmpty ? 1 : data.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 200,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(
          data.length,
          (index) {
            double percentage = data[index] / maxValue;
            List<String> labels = period == 'week'
                ? ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab', 'Dom']
                : period == 'month'
                ? List.generate(data.length, (i) => '${i + 1}')
                : ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];

            return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      width: 24,
                      decoration: BoxDecoration(
                        color: Colors.teal[700],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor: percentage.isNaN ? 0 : percentage,
                          child: Container(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    labels[index < labels.length ? index : 0],
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Widget para calendário de hábitos
class _HabitCalendar extends StatelessWidget {
  final List<DateTime> completedDays;

  const _HabitCalendar({required this.completedDays});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime startOfMonth = DateTime(now.year, now.month, 1);
    
    int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    int firstDayOfWeek = startOfMonth.weekday - 1;

    List<Widget> calendarDays = [];

    // Dias vazios do mês anterior
    for (int i = 0; i < firstDayOfWeek; i++) {
      calendarDays.add(const SizedBox());
    }

    // Dias do mês
    for (int day = 1; day <= daysInMonth; day++) {
      DateTime date = DateTime(now.year, now.month, day);
      bool isCompleted = completedDays.any((d) =>
        d.year == date.year &&
        d.month == date.month &&
        d.day == date.day
      );

      calendarDays.add(
        Container(
          decoration: BoxDecoration(
            color: isCompleted ? Colors.teal[700] : Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$day',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isCompleted ? Colors.white : Colors.grey[600],
              ),
            ),
          ),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: calendarDays.length,
      itemBuilder: (context, index) => calendarDays[index],
    );
  }
}

// Widget para card de melhor hábito
class _TopHabitCard extends StatelessWidget {
  final String habitName;
  final double completionRate;
  final int streak;

  const _TopHabitCard({
    required this.habitName,
    required this.completionRate,
    required this.streak,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.teal[200]!,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.teal[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events,
              color: Colors.teal[700],
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  habitName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.trending_up, size: 14, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(
                      '${completionRate.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Icon(Icons.local_fire_department, size: 18, color: Colors.orange),
              const SizedBox(height: 2),
              Text(
                '$streak dias',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.orange,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
