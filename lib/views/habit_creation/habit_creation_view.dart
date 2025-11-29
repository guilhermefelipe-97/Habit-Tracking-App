import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/habit_creation_viewmodel.dart';

class HabitCreationView extends StatefulWidget {
  const HabitCreationView({Key? key}) : super(key: key);

  @override
  State<HabitCreationView> createState() => _HabitCreationViewState();
}

class _HabitCreationViewState extends State<HabitCreationView> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  String _selectedFrequency = 'daily';
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 0);
  String _selectedTemplate = '';

  final List<Map<String, String>> habitTemplates = [
    {
      'name': 'Beber Água',
      'description': 'Beber 8 copos de água',
      'icon': '💧',
    },
    {
      'name': 'Exercitar',
      'description': 'Fazer exercícios físicos',
      'icon': '🏃',
    },
    {
      'name': 'Meditação',
      'description': 'Meditar por 10 minutos',
      'icon': '🧘',
    },
    {
      'name': 'Leitura',
      'description': 'Ler por 20 minutos',
      'icon': '📚',
    },
    {
      'name': 'Dormir Cedo',
      'description': 'Ir para cama às 22h',
      'icon': '😴',
    },
    {
      'name': 'Skincare',
      'description': 'Rotina de cuidados com a pele',
      'icon': '💆',
    },
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            'Criar Novo Hábito',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.teal[700]),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Seção de Templates
                Text(
                  'Templates Populares',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: habitTemplates.length,
                    itemBuilder: (context, index) {
                      final template = habitTemplates[index];
                      final isSelected = _selectedTemplate == template['name'];
                      
                      return Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedTemplate = template['name']!;
                              _nameController.text = template['name']!;
                              _descriptionController.text = template['description']!;
                            });
                          },
                          child: Container(
                            width: 80,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.teal[100] : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? Colors.teal[700]! : Colors.grey[300]!,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  template['icon']!,
                                  style: const TextStyle(fontSize: 32),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  template['name']!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // Seção de Detalhes
                Container(
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
                      // Nome do Hábito
                      Text(
                        'Nome do Hábito',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: 'Ex: Beber água',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Descrição
                      Text(
                        'Descrição',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Descreva seu hábito...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Frequência
                      Text(
                        'Frequência',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButton<String>(
                        value: _selectedFrequency,
                        isExpanded: true,
                        items: [
                          const DropdownMenuItem(
                            value: 'daily',
                            child: Text('Diariamente'),
                          ),
                          const DropdownMenuItem(
                            value: 'weekdays',
                            child: Text('Dias da semana'),
                          ),
                          const DropdownMenuItem(
                            value: 'weekends',
                            child: Text('Fins de semana'),
                          ),
                          const DropdownMenuItem(
                            value: 'weekly',
                            child: Text('Semanalmente'),
                          ),
                          const DropdownMenuItem(
                            value: 'custom',
                            child: Text('Customizado'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() => _selectedFrequency = value ?? 'daily');
                        },
                      ),
                      const SizedBox(height: 20),

                      // Horário
                      Text(
                        'Horário do Lembrete',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: _selectedTime,
                          );
                          if (time != null) {
                            setState(() => _selectedTime = time);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _selectedTime.format(context),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[800],
                                ),
                              ),
                              Icon(Icons.access_time, color: Colors.teal[700]),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Botão Criar
                Consumer<HabitCreationViewModel>(
                  builder: (context, viewModel, _) {
                    return SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: viewModel.isLoading
                            ? null
                            : () {
                          viewModel.createHabit(
                            _nameController.text,
                            _descriptionController.text,
                            _selectedFrequency,
                            _selectedTime,
                            context,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[700],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: viewModel.isLoading
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          'Criar Hábito',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                if (context.watch<HabitCreationViewModel>().errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red[300]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red[700]),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              context.read<HabitCreationViewModel>().errorMessage ?? '',
                              style: TextStyle(
                                color: Colors.red[700],
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      );
  }
}
