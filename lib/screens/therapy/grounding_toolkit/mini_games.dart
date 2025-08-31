import 'package:flutter/material.dart';
import 'dart:math';

class MiniGamesPage extends StatefulWidget {
  const MiniGamesPage({super.key});

  @override
  State<MiniGamesPage> createState() => _MiniGamesPageState();
}

class _MiniGamesPageState extends State<MiniGamesPage> {
  String selectedGame = 'categories';
  bool isActive = false;
  
  // Categories Game
  String currentCategory = '';
  List<String> categoryAnswers = [];
  TextEditingController categoryController = TextEditingController();
  
  // Alphabet Game
  String currentLetter = 'A';
  int alphabetIndex = 0;
  List<String> alphabetAnswers = [];
  TextEditingController alphabetController = TextEditingController();
  
  // Math Game
  int mathProblem1 = 0;
  int mathProblem2 = 0;
  String mathOperation = '-';
  int mathAnswer = 0;
  int mathScore = 0;
  int mathQuestionCount = 0;
  TextEditingController mathController = TextEditingController();
  
  final List<String> categories = [
    'Animals', 'Foods', 'Colors', 'Countries', 'Movies', 'Books', 
    'Sports', 'Flowers', 'Cities', 'Professions'
  ];
  
  final Map<String, CognitiveGame> games = {
    'categories': CognitiveGame(
      name: 'Categories Game',
      icon: Icons.category,
      color: const Color(0xFF8B5FBF),
      instructions: 'Try to name at least 5 items in the given category',
    ),
    'alphabet': CognitiveGame(
      name: 'Alphabet Game',
      icon: Icons.abc,
      color: const Color(0xFF5FB3BF),
      instructions: 'Name something that starts with each letter A-Z',
    ),
    'math': CognitiveGame(
      name: 'Math Mini-Tasks',
      icon: Icons.calculate,
      color: const Color(0xFF7FB35F),
      instructions: 'Solve simple math problems to redirect your thoughts',
    ),
  };

  @override
  void dispose() {
    categoryController.dispose();
    alphabetController.dispose();
    mathController.dispose();
    super.dispose();
  }

  void _startGame() {
    setState(() {
      isActive = true;
      
      if (selectedGame == 'categories') {
        _startCategoriesGame();
      } else if (selectedGame == 'alphabet') {
        _startAlphabetGame();
      } else if (selectedGame == 'math') {
        _startMathGame();
      }
    });
  }

  void _startCategoriesGame() {
    final random = Random();
    setState(() {
      currentCategory = categories[random.nextInt(categories.length)];
      categoryAnswers.clear();
    });
  }

  void _startAlphabetGame() {
    setState(() {
      alphabetIndex = 0;
      currentLetter = 'A';
      alphabetAnswers.clear();
    });
  }

  void _startMathGame() {
    setState(() {
      mathScore = 0;
      mathQuestionCount = 0;
    });
    _generateMathProblem();
  }

  void _generateMathProblem() {
    final random = Random();
    setState(() {
      mathProblem1 = random.nextInt(50) + 10;
      mathProblem2 = random.nextInt(20) + 1;
      mathOperation = random.nextBool() ? '+' : '-';
      
      if (mathOperation == '-' && mathProblem2 > mathProblem1) {
        final temp = mathProblem1;
        mathProblem1 = mathProblem2;
        mathProblem2 = temp;
      }
      
      mathAnswer = mathOperation == '+' 
        ? mathProblem1 + mathProblem2 
        : mathProblem1 - mathProblem2;
    });
  }

  void _addCategoryAnswer() {
    if (categoryController.text.trim().isEmpty) return;
    
    setState(() {
      categoryAnswers.add(categoryController.text.trim());
      categoryController.clear();
    });
  }

  void _addAlphabetAnswer() {
    if (alphabetController.text.trim().isEmpty) return;
    
    final userInput = alphabetController.text.trim();
    final firstLetter = userInput.toUpperCase().substring(0, 1);
    
    // Check if the word starts with the correct letter
    if (firstLetter != currentLetter) {
      // Show error message and keep the same letter
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a word that starts with "$currentLetter"'),
          backgroundColor: const Color(0xFFFB6376), 
          duration: const Duration(seconds: 2),
        ),
      );
      alphabetController.clear();
      return;
    }
    
    setState(() {
      alphabetAnswers.add('${currentLetter}: $userInput');
      alphabetController.clear();
      alphabetIndex++;
      
      if (alphabetIndex < 26) {
        currentLetter = String.fromCharCode(65 + alphabetIndex);
      } else {
        _completeGame();
      }
    });
  }

  void _checkMathAnswer() {
    if (mathController.text.trim().isEmpty) return;
    
    final userAnswer = int.tryParse(mathController.text.trim());
    if (userAnswer != null) {
      setState(() {
        if (userAnswer == mathAnswer) {
          mathScore++;
        }
        mathQuestionCount++;
        mathController.clear();
        
        if (mathQuestionCount < 10) {
          _generateMathProblem();
        } else {
          _completeGame();
        }
      });
    }
  }

  void _skipAlphabetLetter() {
    setState(() {
      alphabetAnswers.add('${currentLetter}: (skipped)');
      alphabetIndex++;
      
      if (alphabetIndex < 26) {
        currentLetter = String.fromCharCode(65 + alphabetIndex);
      } else {
        _completeGame();
      }
    });
  }

  void _completeGame() {
    setState(() {
      isActive = false;
    });
    
    String message = '';
    if (selectedGame == 'categories') {
      message = 'Great! You named ${categoryAnswers.length} items in the $currentCategory category.';
    } else if (selectedGame == 'alphabet') {
      message = 'Excellent! You went through ${alphabetAnswers.length} letters of the alphabet.';
    } else if (selectedGame == 'math') {
      message = 'Well done! You got $mathScore out of $mathQuestionCount math problems correct.';
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Complete! 🎉'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message),
            const SizedBox(height: 12),
            const Text('How does your mind feel now? Notice if you feel more focused.'),
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
              _resetGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      isActive = false;
      categoryAnswers.clear();
      alphabetAnswers.clear();
      alphabetIndex = 0;
      currentLetter = 'A';
      mathScore = 0;
      mathQuestionCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = games[selectedGame]!;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: const Text('Cognitive Grounding'),
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
              onPressed: _resetGame,
              tooltip: 'Reset',
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      game.color.withOpacity(0.1),
                      game.color.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: game.color.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.games,
                        color: game.color,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mini Games',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: game.color,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Focus your mind with engaging mini-games',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              if (!isActive) ...[
                // Game Selector
                Text(
                  'Choose Your Game',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                
                ...games.entries.map((entry) {
                  final key = entry.key;
                  final gameOption = entry.value;
                  final isSelected = selectedGame == key;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            selectedGame = key;
                          });
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected ? gameOption.color.withOpacity(0.1) : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected ? gameOption.color : Colors.grey[300]!,
                              width: 2,
                            ),
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
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: gameOption.color.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  gameOption.icon,
                                  color: gameOption.color,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      gameOption.name,
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isSelected ? gameOption.color : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (isSelected)
                                Icon(
                                  Icons.check_circle,
                                  color: gameOption.color,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                
                const SizedBox(height: 18),
                
                // Instructions
                Container(
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
                      Row(
                        children: [
                          Icon(Icons.info_outline, color: game.color),
                          const SizedBox(width: 8),
                          Text(
                            'How to play:',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(game.instructions),
                    ],
                  ),
                ),
                
                const SizedBox(height: 18),
                
                // Start Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _startGame,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: game.color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Start ${game.name}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ] else ...[
                // Active Game
                _buildActiveGame(),
              ],
            ],
          ),
        ),
      ),
      ),
    );
  }
  
  Widget _buildActiveGame() {
    switch (selectedGame) {
      case 'categories':
        return _buildCategoriesGame();
      case 'alphabet':
        return _buildAlphabetGame();
      case 'math':
        return _buildMathGame();
      default:
        return Container();
    }
  }
  
  Widget _buildCategoriesGame() {
    final game = games['categories']!;
    
    return Column(
      children: [
        // Game Header
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
              Text(
                'Categories Game',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Name items in this category:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: game.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  currentCategory,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: game.color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '${categoryAnswers.length} items named',
                style: TextStyle(
                  color: game.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Input
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: categoryController,
                decoration: InputDecoration(
                  hintText: 'Type an item...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: game.color, width: 2),
                  ),
                ),
                onSubmitted: (_) => _addCategoryAnswer(),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _addCategoryAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: game.color,
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
        
        const SizedBox(height: 20),
        
        // Answers List
        Container(
          height: 300,
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
                  'Your answers:',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                if (categoryAnswers.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text('Start typing to add items!'),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: categoryAnswers.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: game.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${index + 1}.',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: game.color,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(categoryAnswers[index]),
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
        
        const SizedBox(height: 16),
        
        // Complete Button
        if (categoryAnswers.length >= 5)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _completeGame,
              style: ElevatedButton.styleFrom(
                backgroundColor: game.color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Complete Game'),
            ),
          ),
      ],
    );
  }
  
  Widget _buildAlphabetGame() {
    final game = games['alphabet']!;
    
    return Column(
      children: [
        // Game Header
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
              Text(
                'Alphabet Game',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Name something that starts with:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: game.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    currentLetter,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: game.color,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: alphabetIndex / 26,
                backgroundColor: game.color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(game.color),
              ),
              const SizedBox(height: 8),
              Text(
                '${alphabetIndex + 1} / 26',
                style: TextStyle(
                  color: game.color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 20),
        
        // Input
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: alphabetController,
                decoration: InputDecoration(
                  hintText: 'Enter a word starting with $currentLetter...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: game.color, width: 2),
                  ),
                ),
                onSubmitted: (_) => _addAlphabetAnswer(),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _addAlphabetAnswer,
              style: ElevatedButton.styleFrom(
                backgroundColor: game.color,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(16),
              ),
              child: const Icon(Icons.arrow_forward),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Skip button
        TextButton(
          onPressed: _skipAlphabetLetter,
          child: Text('Skip $currentLetter'),
        ),
        
        const SizedBox(height: 20),
        
        // Previous answers
        if (alphabetAnswers.isNotEmpty)
          Container(
            height: 300,
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
                    'Your alphabet:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: ListView.builder(
                      itemCount: alphabetAnswers.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: game.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            alphabetAnswers[index],
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }
  
  Widget _buildMathGame() {
    final game = games['math']!;
    
    return Column(
      children: [
        // Game Header
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
              Text(
                'Math Mini-Tasks',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        'Question',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '${mathQuestionCount + 1}/10',
                        style: TextStyle(
                          color: game.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Score',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text(
                        '$mathScore',
                        style: TextStyle(
                          color: game.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: mathQuestionCount / 10,
                backgroundColor: game.color.withOpacity(0.2),
                valueColor: AlwaysStoppedAnimation<Color>(game.color),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 40),
        
        // Math Problem
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 400),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: game.color.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'What is:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                
                const SizedBox(height: 24),
                
                Text(
                  '$mathProblem1 $mathOperation $mathProblem2 = ?',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: game.color,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                SizedBox(
                  width: 150,
                  child: TextField(
                    controller: mathController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    decoration: InputDecoration(
                      hintText: '?',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: game.color, width: 2),
                      ),
                    ),
                    onSubmitted: (_) => _checkMathAnswer(),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                ElevatedButton(
                  onPressed: _checkMathAnswer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: game.color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit Answer',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class CognitiveGame {
  final String name;
  final IconData icon;
  final Color color;
  final String instructions;

  CognitiveGame({
    required this.name,
    required this.icon,
    required this.color,
    required this.instructions,
  });
}
