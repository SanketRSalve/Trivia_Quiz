## TRIVIA QUIZ APP

1[Banner Image](images/TriviaQuizApp.png)

Trivia Quiz App is a Flutter-based mobile application that quizzes users with 10 random questions. Users need to select the correct answers to earn 1 point for each question.

[![Flutter Version](https://img.shields.io/badge/Flutter-latest-blue.svg)](https://flutter.dev/docs/get-started/install)
[![Dart Version](https://img.shields.io/badge/Dart-latest-blue.svg)](https://dart.dev/get-dart)

## Features

- Presents users with 10 random questions.
- Users choose the correct answer for each question.
- Users earn 1 point for each correct answer.
- Fetches trivia questions from a Trivia API.

## Dependencies

- [Riverpod](https://pub.dev/packages/flutter_riverpod)
- [dio](https://pub.dev/packages/dio)
- [hooks](https://pub.dev/packages/hooks_riverpod)

To install these dependencies, add the following to your `pubspec.yaml` file and run `flutter pub get`:

```
dependencies:
  dio: ^latest_version
  riverpod: ^latest_version
  hooks_riverpod: ^latest_version
```

## Installation

1. Clone the repository:

```https://github.com/SanketRSalve/Trivia_Quiz.git
cd Trivia_Quiz/
```

2. Install dependencies:

```
flutter pub get
```

4. Run the app:

```
flutter run
```

For more details on Flutter installation and setup, refer to the [Flutter Documentation](https://docs.flutter.dev/get-started/install).

## Usage

- Open the app and start the quiz.
- Answer the 10 random questions by selecting the correct answers.
- At the end of the quiz, view your score.

## Acknowledgments

- [Trivia Api](https://opentdb.com/api_config.php) for providing questions.
