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
      useSafeArea: true,
      enableDrag: true,
      isDismissible: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => ChatbotModal(
          dragScrollController: scrollController,
        ),
      ),
    );
  }
}

class ChatbotModal extends StatefulWidget {
  final ScrollController? dragScrollController;
  
  const ChatbotModal({super.key, this.dragScrollController});

  @override
  State<ChatbotModal> createState() => _ChatbotModalState();
}

class _ChatbotModalState extends State<ChatbotModal> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    // Initial greeting
    _messages.add(ChatMessage(
      text: "Hi there! 👋 I'm Solace, your AI wellness companion. How are you feeling today?",
      isUser: false,
    ));
    
    // Listen to focus changes to scroll to bottom when keyboard appears
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 300), () {
          _scrollToBottom();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Widget _buildDateSeparator() {
    final now = DateTime.now();
    final formattedDate = 
      "${_getWeekday(now.weekday).toUpperCase()}, ${now.day.toString().padLeft(2, '0')} ${_getMonth(now.month).toUpperCase()} ${now.year}";
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Expanded(child: Divider(color: Theme.of(context).colorScheme.outline)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              formattedDate,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12,
                color: Theme.of(context).colorScheme.outline,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Divider(color: Theme.of(context).colorScheme.outline)),
        ],
      ),
    );
  }

  String _getWeekday(int weekday) {
    const weekdays = [
      'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'
    ];
    return weekdays[(weekday - 1) % 7];
  }

  String _getMonth(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[(month - 1) % 12];
  }

  bool _shouldShowWarning(String message) {
    final lowerMessage = message.toLowerCase();
    return lowerMessage.contains('suicidal') || 
           lowerMessage.contains('kill myself') || 
           lowerMessage.contains('end it all') || 
           lowerMessage.contains('hurt myself') ||
           lowerMessage.contains('overwhelming') ||
           lowerMessage.contains('falling apart');
  }

  Widget _buildWarningBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.tertiary,
      borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
        Icons.warning,
        color: Theme.of(context).colorScheme.onPrimary,
        size: 10,
        ),
        Expanded(
        child: Center(
          child: Text(
          'WARNING: EXTREME NEGATIVE EMOTIONS DETECTED',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
          ),
        ),
        ),
      ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      height: screenHeight,
      padding: EdgeInsets.only(bottom: keyboardHeight),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.5),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20), bottom: Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1),
                  blurRadius: 1,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                    minimumSize: const Size(40, 40),
                    padding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: Text(
                    'AI Chatbot',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _messages.clear();
                      _messages.add(ChatMessage(
                        text: "Hi there! 👋 I'm Solace, your AI wellness companion. How are you feeling today?",
                        isUser: false,
                      ));
                    });
                  },
                  icon: const Icon(Icons.refresh, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.outline.withOpacity(0.1),
                    foregroundColor: Theme.of(context).colorScheme.onSurface,
                    minimumSize: const Size(40, 40),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
          
          // Chat messages
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + 1, // +1 for date separator
              itemBuilder: (context, index) {
                // Show date separator at the beginning
                if (index == 0) {
                  return _buildDateSeparator();
                }
                
                final messageIndex = index - 1;
                final message = _messages[messageIndex];
                
                // Check if this message should show a warning
                bool showWarning = false;
                if (!message.isUser && messageIndex > 0) {
                  final userMessage = _messages[messageIndex - 1];
                  if (userMessage.isUser) {
                    showWarning = _shouldShowWarning(userMessage.text);
                  }
                }
                
                return Column(
                  children: [
                    if (showWarning) _buildWarningBanner(),
                    ChatBubble(message: message),
                  ],
                );
              },
            ),
          ),
          
          // Input field
          Container(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: SafeArea(
              minimum: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: 44,
                        maxHeight: 120,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _controller,
                        focusNode: _focusNode,
                        maxLines: null,
                        minLines: 1,
                        textInputAction: TextInputAction.send,
                        textCapitalization: TextCapitalization.sentences,
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: InputDecoration(
                          hintText: 'How are you feeling today?',
                          hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          isDense: true,
                        ),
                        onSubmitted: _sendMessage,
                        onChanged: (text) {
                          // Auto-scroll to bottom when typing
                          Future.delayed(const Duration(milliseconds: 100), () {
                            _scrollToBottom();
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(               
                    child: Material(
                      color: Theme.of(context).colorScheme.onSurface,
                      shape: const CircleBorder(),
                      child: InkWell(
                        onTap: () => _sendMessage(_controller.text),
                        customBorder: const CircleBorder(),
                        child: Container(
                          width: 44,
                          height: 44,
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.send_rounded,
                            color: Theme.of(context).colorScheme.surface,
                            size: 20,
                          ),
                        ),
                      ),
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

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(text: text.trim(), isUser: true));
      _controller.clear();
    });

    // Unfocus the text field to hide keyboard if needed
    _focusNode.unfocus();

    // Scroll to bottom after adding user message
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToBottom();
    });

    // Simulate AI response
    Future.delayed(const Duration(milliseconds: 800), () {
      setState(() {
        _messages.add(ChatMessage(
          text: _getAIResponse(text),
          isUser: false,
        ));
      });
      
      // Scroll to bottom after AI response
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollToBottom();
      });
    });
  }

  String _getAIResponse(String userMessage) {
    final message = userMessage.toLowerCase();
    
    // Crisis keywords
    if (message.contains('suicidal') || message.contains('kill myself') || 
        message.contains('end it all') || message.contains('hurt myself')) {
      return "I'm really concerned about you. Please reach out to someone right now:\n\n🆘 Talian Kasih - 15555\n📞 Life Line Association: 15995\n\nYou matter, and help is available. Would you like me to help you find local campus counseling services?";
    }
    
    // Overwhelming/extreme stress responses
    if (message.contains('overwhelming') ||
        message.contains('falling apart') || message.contains('hopeless')) {
      return "I hear you—it sounds like today feels heavy, and that's okay. You're not alone in this, and I'm here to sit with you through it, alright?";
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
    
    // Gratitude/positive responses
    if (message.contains('thank you') || message.contains('grateful') || message.contains('appreciate') || 
        message.contains('better') || message.contains('helping') || message.contains('thanks') ) {
      return "You're very welcome! I'm really glad I could be here for you—you're stronger than you realize!";
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
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!message.isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFB9998D).withOpacity(0.3), // muted pink
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.psychology_rounded,
                size: 16,
                color: const Color(0xFFB9998D),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: message.isUser 
                  ? Theme.of(context).colorScheme.onSurface
                  : const Color(0xFFB9998D).withOpacity(0.3), // muted pink
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: message.isUser 
                    ? const Radius.circular(20) 
                    : const Radius.circular(4),
                  bottomRight: message.isUser 
                    ? const Radius.circular(4) 
                    : const Radius.circular(20),
                ),
                border: !message.isUser ? Border.all(
                  color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
                  width: 1,
                ) : null,
              ),
              child: Text(
                message.text,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: message.isUser 
                    ? Theme.of(context).colorScheme.surface 
                    : Theme.of(context).colorScheme.onSurface,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                size: 16,
                color: Theme.of(context).colorScheme.surface.withOpacity(0.7),
                
              ),
            ),
          ],
        ],
      ),
    );
  }
}
