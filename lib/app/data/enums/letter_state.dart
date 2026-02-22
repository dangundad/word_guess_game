enum LetterState {
  absent,
  present,
  correct;

  int get priority {
    switch (this) {
      case LetterState.absent:
        return 0;
      case LetterState.present:
        return 1;
      case LetterState.correct:
        return 2;
    }
  }
}
