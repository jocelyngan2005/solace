import 'package:flutter/material.dart';

class SensoryGroundingPage extends StatefulWidget {
  const SensoryGroundingPage({super.key});

  @override
  State<SensoryGroundingPage> createState() => _SensoryGroundingPageState();
}

class _SensoryGroundingPageState extends State<SensoryGroundingPage> {
  int currentStep = 0;
  bool isActive = false;
  
  final List<GroundingStep> steps = [
    GroundingStep(
      number: 5,
      sense: 'See',
      instruction: 'Name 5 things you can SEE 👀',
      icon: Icons.visibility,
      color: Colors.lightBlueAccent,
      items: [],
    ),
    GroundingStep(
      number: 4,
      sense: 'Touch',
      instruction: 'Name 4 things you can TOUCH ✋',
      icon: Icons.touch_app,
      color: Colors.green[300]!,
      items: [],
    ),
    GroundingStep(
      number: 3,
      sense: 'Hear',
      instruction: 'Name 3 things you can HEAR 👂',
      icon: Icons.hearing,
      color: Colors.orangeAccent,
      items: [],
    ),
    GroundingStep(
      number: 2,
      sense: 'Smell',
      instruction: 'Name 2 things you can SMELL 👃',
      icon: Icons.air,
      color: Colors.redAccent,
      items: [],
    ),
    GroundingStep(
      number: 1,
      sense: 'Taste',
      instruction: 'Name 1 thing you can TASTE 👅',
      icon: Icons.local_dining,
      color: Colors.deepPurpleAccent,
      items: [],
    ),
  ];

  TextEditingController textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  void _startGrounding() {
    setState(() {
      isActive = true;
      currentStep = 0;
      for (var step in steps) {
        step.items.clear();
      }
    });
  }

  void _addItem() {
    if (textController.text.trim().isEmpty) return;
    
    setState(() {
      steps[currentStep].items.add(textController.text.trim());
      textController.clear();
      
      if (steps[currentStep].items.length >= steps[currentStep].number) {
        if (currentStep < steps.length - 1) {
          currentStep++;
        } else {
          _completeGrounding();
        }
      }
    });
  }

  void _completeGrounding() {
    setState(() {
      isActive = false;
    });
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Well Done! 🌟'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('You\'ve completed the 5-4-3-2-1 grounding technique.'),
            SizedBox(height: 12),
            Text('Take a moment to notice how you feel now compared to when you started.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resetGrounding();
            },
            child: const Text('Start Again'),
          ),
        ],
      ),
    );
  }

  void _resetGrounding() {
    setState(() {
      isActive = false;
      currentStep = 0;
      for (var step in steps) {
        step.items.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('5-4-3-2-1 Grounding'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (isActive)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _resetGrounding,
              tooltip: 'Reset',
            ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
            '5-4-3-2-1 Technique',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ground yourself using your five senses',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
              
              const SizedBox(height: 24),
              
              if (!isActive) ...[
                // Instructions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'How it works:',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'This technique helps ground you in the present moment by engaging all your senses. It\'s particularly helpful during anxiety or panic attacks.',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'You\'ll be guided through:',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...steps.map((step) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: step.color.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${step.number}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: step.color,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(step.instruction)),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Start Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _startGrounding,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Start 5-4-3-2-1 Exercise',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ] else ...[
                // Active Exercise
                _buildActiveExercise(),
              ],
              
              if (isActive) ...[
                const SizedBox(height: 24),
                _buildProgressIndicator(),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildActiveExercise() {
    final step = steps[currentStep];
    final remainingItems = step.number - step.items.length;
    
    return Expanded(
      child: Column(
        children: [
          // Current Step Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: step.color.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        step.icon,
                        color: step.color,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.instruction,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$remainingItems more to go',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: step.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Input Field
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: textController,
                        decoration: InputDecoration(
                          hintText: 'What do you ${step.sense.toLowerCase()}?',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: step.color.withOpacity(0.3)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: step.color, width: 2),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (_) => _addItem(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _addItem,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: step.color,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(16),
                      ),
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Items List
          if (step.items.isNotEmpty)
            Expanded(
              child: Container(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'You\'ve identified:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        itemCount: step.items.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: step.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: step.color,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    step.items[index],
                                    style: TextStyle(
                                      color: step.color,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildProgressIndicator() {
    return Container(
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: steps.asMap().entries.map((entry) {
          final index = entry.key;
          final step = entry.value;
          final isCompleted = step.items.length >= step.number;
          final isCurrent = index == currentStep;
          
          return Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: isCompleted 
                    ? step.color 
                    : isCurrent 
                      ? step.color.withOpacity(0.3)
                      : Colors.grey[200],
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCompleted
                    ? const Icon(Icons.check, color: Colors.white, size: 20)
                    : Text(
                        '${step.number}',
                        style: TextStyle(
                          color: isCurrent ? step.color : Colors.grey[500],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                step.sense,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isCompleted || isCurrent ? step.color : Colors.grey[500],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class GroundingStep {
  final int number;
  final String sense;
  final String instruction;
  final IconData icon;
  final Color color;
  final List<String> items;

  GroundingStep({
    required this.number,
    required this.sense,
    required this.instruction,
    required this.icon,
    required this.color,
    required this.items,
  });
} 