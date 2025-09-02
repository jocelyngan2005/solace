import 'package:flutter/material.dart';

class AIChatbot extends StatelessWidget {
  const AIChatbot({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _showChatbot(context),
      child: const Icon(Icons.chat_bubble_rounded),
    );
  }

  void _showChatbot(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ChatbotModal(),
    );
  }
}

class ChatbotModal extends StatefulWidget {
  const ChatbotModal({super.key});

  @override
  State<ChatbotModal> createState() => _ChatbotModalState();
}

class _ChatbotModalState extends State<ChatbotModal> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    // Initial greeting
    _messages.add(ChatMessage(
      text: "Hi there! 👋 I'm Solace, your AI wellness companion. How are you feeling today?",
      isUser: false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Color(0xFFFEFEFE),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFB8E0D2),
                  child: Icon(Icons.psychology_rounded, color: Color(0xFFFEFEFE)),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Solace AI',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          
          // Chat messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ChatBubble(message: message);
              },
            ),
          ),
          
          // Input field
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(top: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Color(0xFFFEFEFE),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: IconButton(
                    onPressed: () => _sendMessage(_controller.text),
                    icon: const Icon(Icons.send, color: Color(0xFFFEFEFE)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _controller.clear();
    });

    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _messages.add(ChatMessage(
          text: _getAIResponse(text),
          isUser: false,
        ));
      });
    });
  }

  String _getAIResponse(String userMessage) {
    final message = userMessage.toLowerCase();
    
    // Crisis keywords
    if (message.contains('suicidal') || message.contains('kill myself') || 
        message.contains('end it all') || message.contains('hurt myself')) {
      return "I'm really concerned about you. Please reach out to someone right now:\n\n🆘 Crisis Text Line: Text HOME to 741741\n📞 National Suicide Prevention Lifeline: 988\n\nYou matter, and help is available. Would you like me to help you find local campus counseling services?";
    }
    
    // Stressed/anxiety responses
    if (message.contains('stressed') || message.contains('anxiety') || message.contains('anxious')) {
      return "I understand you're feeling stressed. 😔 Let's try a quick breathing exercise together:\n\n1. Breathe in for 4 counts\n2. Hold for 4 counts\n3. Breathe out for 6 counts\n\nWould you like me to guide you through some grounding techniques or suggest a mindfulness exercise?";
    }
    
    // Exam/academic stress
    if (message.contains('exam') || message.contains('test') || message.contains('assignment')) {
      return "Academic pressure can be overwhelming! 📚 Remember:\n\n• Take breaks every 25 minutes (Pomodoro technique)\n• Break large tasks into smaller steps\n• Practice self-compassion\n\nWould you like me to help you create a study schedule or suggest some relaxation techniques?";
    }
    
    // Sad/depressed responses
    if (message.contains('sad') || message.contains('depressed') || message.contains('down')) {
      return "I'm sorry you're feeling down. 💙 It's okay to have difficult days. Some things that might help:\n\n• Go for a short walk outside\n• Call a friend or family member\n• Practice gratitude (name 3 good things from today)\n\nRemember, your feelings are valid and this feeling will pass. How can I support you right now?";
    }
    
    // Sleep issues
    if (message.contains('sleep') || message.contains('tired') || message.contains('insomnia')) {
      return "Sleep is so important for your wellbeing! 😴 Here are some tips:\n\n• No screens 1 hour before bed\n• Try the 4-7-8 breathing technique\n• Keep your room cool and dark\n• Try a guided sleep meditation\n\nWould you like me to suggest some relaxation exercises to help you unwind?";
    }
    
    // Default positive responses
    final positiveResponses = [
      "That's interesting! Tell me more about how you're feeling. I'm here to listen and support you. 💙",
      "Thank you for sharing that with me. How can I help you feel more supported today?",
      "I appreciate you opening up. Remember, taking care of your mental health is just as important as your physical health. What would be most helpful right now?",
      "It sounds like you're going through a lot. You're not alone in this. What's one small thing we could do together to help you feel better?",
      "Your feelings are completely valid. Let's explore some ways to support your wellbeing. Would you like to try a mindfulness exercise or talk about coping strategies?",
    ];
    
    return positiveResponses[(userMessage.hashCode % positiveResponses.length).abs()];
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            const CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFB8E0D2),
              child: Icon(Icons.psychology_rounded, size: 16, color: Color(0xFFFEFEFE)),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: message.isUser 
                  ? Theme.of(context).colorScheme.primary
                  : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Color(0xFFFEFEFE) : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: const Icon(Icons.person, size: 16, color: Color(0xFFFEFEFE)),
            ),
          ],
        ],
      ),
    );
  }
}
