# 🌟 Solace - Mental Health Support for Students

> *A safe space where every feeling matters and support is always within reach.*

**Solace** is a comprehensive mental health mobile application designed specifically for university and college students. It provides private, judgment-free mental health support through self-care tools, mood tracking, wellness exercises, and academic-aware features to help students cope with the demands of university life.

## 🎯 Track: Student Lifestyle

### Problem Statement
**Mental Health Support for Students**

Many students don’t seek help because counseling resources are limited or they fear stigma. This challenge will explore creating tools for self care, mental health support and helping students cope with the demands of university life.

**Solace** addresses these challenges by providing a private, accessible platform that integrates seamlessly with student life while promoting proactive mental health care.

## 📱 Prototype 
Prototype: https://www.figma.com/design/leFYlfvw5etlQUYErLUJN3/solace---your-mindfulness-partner?node-id=0-1&t=8OicmM59rKQtfJF8-1

Pitch deck: https://www.canva.com/design/DAGyR7nvk1M/_dnVnDbizpvY0KNnmEDRDA/edit?utm_content=DAGyR7nvk1M&utm_campaign=designshare&utm_medium=link2&utm_source=sharebutton 

Video Presentation : https://youtu.be/TZ4KXeNrBEU

## 👥 Target Users

- **Primary**: University & college students (undergraduates and postgraduates)
- **Secondary**: University mental health teams & student support services (for integration & referrals).

## ✨ Core Features

### 🧠 Self-Care & Mood Tracking
- **Daily Mood Check-ins**: Interactive mood tracking with visual mood indicators
- **Mood Analysis**: Intelligent analysis with personalized recommendations
- **Journal Library**: Secure storage and review of past mood entries
- **Stress & Anxiety Monitoring**: Detailed tracking with visual stress level indicators
- **Habit Tracking**: Monitor wellness habits and self-care routines

### 🎓 Academic-Aware Support
- **Context-Sensitive Support**: Academic calendar integration 
- **Smart Notifications**: Proactive mental health reminders
- **Focus Mode**: Distraction-free environment for studying 

### 🧘 Wellness & Coping Tools
- **Guided Breathing Exercises**: Multiple breathing techniques (4-7-8, Box Breathing, Deep Belly, Calming Breath)
- **Mindfulness & Meditation**: Guided meditation sessions with customizable soundtracks
- **Grounding Techniques**: 5-4-3-2-1 sensory grounding and body scan exercises
- **Positive Affirmations**: Daily motivational messages and self-compassion practices

### 🔗 Professional Support
- **Mental Health Resources**: Curated links to professional support services
- **Crisis Support**: Quick access to emergency mental health resources
- **AI Chatbot**: Intelligent conversational support

### ♿ Accessibility & Personalization
- **Accessibility-First Design**: Screen reader support, dyslexia-friendly fonts
- **Calming UI**: Mood-based color schemes and intuitive navigation
- **Personalized Experience**: Adaptive interface based on user preferences
- **Speech-to-Text**: Voice input for journal entries

### 🎮 Engagement & Motivation
- **Progress Tracking**: Visual progress indicators and achievement system
- **Points System**: Gamified rewards for consistent self-care practices
- **Weekly Challenges**: Non-competitive wellness challenges 

## 🛠️ Tech Stack

### Frontend
- **Framework**: Flutter 3.9.0
- **UI Components**: Material Design 3 with custom theming
- **State Management**: StatefulWidget with ValueNotifier
- **Charts & Visualization**: fl_chart 0.68.0
- **Internationalization**: intl 0.19.0

### Backend (Planned)
- **Authentication**: Firebase Auth
- **Database**: Cloud Firestore
- **Storage**: Firebase Cloud Storage
- **Analytics**: Firebase Analytics

### AI/ML Integration (Planned)
- **Sentiment Analysis**: ML-based mood pattern recognition
- **Recommendation Engine**: Personalized wellness activity suggestions
- **AI Chatbot**: LLM-powered conversational support

### APIs & Integrations (Planned)
- **Google Calendar API**: Academic calendar integration
- **Device Health APIs**: Optional sleep/activity tracking
- **Push Notifications**: Firebase Cloud Messaging

## 🎨 Design Principles

### 🌈 **Mood-Responsive Design**
- Dynamic color schemes that adapt to user's current mood
- Calming visual aesthetics with smooth animations
- Minimalist interface to reduce cognitive load

### ♿ **Accessibility First**
- WCAG 2.1 AA compliance
- Screen reader optimization
- High contrast mode support
- Dyslexia-friendly typography options
- Voice input alternatives

### 🔒 **Privacy by Design**
- End-to-end encryption for sensitive data
- Local data storage with optional cloud sync
- Anonymous usage analytics only
- GDPR-compliant data handling

### 🎯 **Student-Centric UX**
- Academic calendar awareness
- Quick access to essential features
- Offline functionality for core features
- Minimal battery and data usage

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.9.0 or higher
- Dart SDK
- Android Studio / VS Code with Flutter extensions

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/jocelyngan2005/solace.git
   cd solace
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building for Production

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

## 🔐 Privacy & Ethics

- **Data Protection**: All mood entries and journal content are encrypted
- **Anonymous Analytics**: No personally identifiable information collected
- **Professional Disclaimer**: Clear messaging that the app supplements but doesn't replace professional care
- **Consent Management**: Granular privacy controls for users
- **Crisis Detection**: Responsible handling of crisis situations with appropriate resource redirection

## 🤝 Contributing

We welcome contributions from developers, mental health professionals, and UX designers! Here's how you can help:

### Development Guidelines
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 🗺️ Roadmap

### Prototype Phase: Core Features ✅
- [x] Mood tracking and analysis
- [x] Journal entry system
- [x] Basic wellness tools
- [x] Breathing exercises
- [x] Professional support and resources 
- [x] Gamification and habit tracking

### Building Phase: Enhanced Features 🚧
- [ ] Firebase backend integration
- [ ] Push notifications
- [ ] Advanced AI analytics
- [ ] Google Calendar integration
- [ ] AI-powered recommendations
- [ ] Multi-language support
- [ ] Wearable device integration
- [ ] Offline-first architecture

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## ⚠️ Important Disclaimer

**Solace is not a substitute for professional mental health care.** If you're experiencing a mental health crisis, please contact emergency services or a mental health professional immediately. This app is designed to supplement professional care and promote wellness, not replace clinical treatment.

---

*Built with ❤️ for student mental health and wellbeing*
