# MapleLingo – Speech-Based Pronunciation Coach

**MapleLingo** is a voice-driven AI chatbot that helps you master pronunciation in multiple languages.  
Just speak → get instant feedback on your pronunciation, receive corrections, hear native-like examples, and improve naturally through conversation.

Perfect for language learners seeking an assistant that scales with their progress. The AI avoids repetition, dynamically increasing vocabulary complexity as your skills evolve.

<br>

## ✨ Core Features

- **Voice-first interaction** — speak directly to the AI
- Multiple chat rooms (separate conversations per language / goal)
- Real-time pronunciation feedback & corrections
- Simple, focused mobile-friendly interface
- Create / rename / delete chat rooms easily

<br>

## Screenshots

### Chat Room Management
<img src="https://github.com/user-attachments/assets/06f6ab58-9dc1-4cb9-ba39-96e8ad2b9047" width="38%" alt="Chat room list screen">

### Creating a New Chat Room
<img src="https://github.com/user-attachments/assets/0850e2ae-e438-46c3-b622-bfaf60c13570" width="38%" alt="Create new chat room">

### Deleting a Chat Room
<img src="https://github.com/user-attachments/assets/56268132-fe69-4f23-8a75-abb1e758f392" width="38%" alt="Delete chat room confirmation">

### First Message from Assistant
<img src="https://github.com/user-attachments/assets/e693546d-992b-454a-a068-a7ead956c284" width="38%" alt="Initial assistant greeting">

### Typical Interaction (Prototype)
<img src="https://github.com/user-attachments/assets/863683c6-1574-4ab7-aebc-dc80b83a7661" width="38%" alt="Normal conversation example">

<br>

## How to Use (Quick Start)

1. Open the app
2. Create a new chat room (give it a name like “French daily phrases”, “Spanish rolling R”, …)
3. Start speaking — say any word or sentence
4. Listen to the AI’s feedback + corrected pronunciation
5. Keep the conversation going to practice longer phrases


<br>

## Tech Stack (so far)

- **Frontend Framework** — Flutter (Dart)
- **UI & App Logic** — Dart
- **Speech Recognition** — [speech_to_text](https://pub.dev/packages/speech_to_text) plugin  
  (device-native STT on Android/iOS)
- **Text-to-Speech** — [flutter_tts](https://pub.dev/packages/flutter_tts) plugin  
  (cross-platform TTS with voice selection & speed control)
- **AI / Language Model** — OpenAI GPT-3.5 Turbo (via API calls)
- **Backend** — PHP (REST API endpoints)  
  → Handles chat history, user sessions, proxying OpenAI requests (recommended pattern)
- **Database** — MySQL  
  → Stores chat rooms, conversation history, user preferences
- **Local Development Server** — XAMPP (Apache + MySQL + PHP) + phpMyAdmin
- **API Communication** — `http` / `dio` package (Flutter → PHP backend)

<br>
