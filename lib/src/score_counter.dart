import 'dart:async';

class ScoreCounter{

  StreamController<int> scoreEventPublisher = StreamController<int>.broadcast();
  StreamController<int> bestScoreEventPublisher = StreamController<int>.broadcast();

  int _bestScore = 0;

  int _currentScore = 0;

  int get bestScore => _bestScore;

  void init(){
    scoreEventPublisher.stream.listen((score) {
      if(score > bestScore){
        _updateBestScore(score);
        bestScoreEventPublisher.add(score);
      }
    });
  }

  void getScore(){
    _currentScore++;
    scoreEventPublisher.add(_currentScore);
  }

  void resetState(){
    _currentScore = 0;
    scoreEventPublisher.add(0);
  }

  void _updateBestScore(int score){
    _bestScore = score;
  }
}

ScoreCounter counter = ScoreCounter()..init();