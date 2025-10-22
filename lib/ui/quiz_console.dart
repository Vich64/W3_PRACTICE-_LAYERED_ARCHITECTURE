import 'dart:io';

import '../domain/quiz.dart';

class QuizConsole {
  Quiz quiz;
  Map<String, int> playerScores = {};
  QuizConsole({required this.quiz});

  void startQuiz() {
    print('--- Welcome to the Quiz ---\n');

    while (true) {
      stdout.write('Enter your name: ');
      String? name = stdin.readLineSync();

      if (name == null || name.isEmpty) {
        print("\nExiting... Final Scores:");
        showAllScores();
        break;
      }

      quiz.answers.clear();


      for (var question in quiz.questions) {
        print('Question: ${question.title}');
        print('Choices: ${question.choices}');
        stdout.write('Your answer: ');
        String? userInput = stdin.readLineSync();

      // Check for null input
        if (userInput != null && userInput.isNotEmpty) {
          Answer answer = Answer(question: question, answerChoice: userInput);
          quiz.addAnswer(answer);
        } 
        else {
          print('No answer entered. Skipping question.');
      }
      print('');
    }
 
    num score = quiz.getScoreInPercentage();
    num totalSCore = quiz.getScoreInTotal();

    playerScores[name] = quiz.getScoreInTotal();
    print('--- Quiz Finished ---');
    print('Your score: $score % correct');
    print('Your Total score: $totalSCore');

    showAllScores();
  }
  }
   void showAllScores() {
    if (playerScores.isEmpty) {
      print('No scores yet.');
    } else {
      playerScores.forEach((player, score) {
        print(' - $player: $score points');
      });
    }
   }
  
}
 