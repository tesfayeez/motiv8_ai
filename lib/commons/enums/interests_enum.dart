enum Interest {
  fitness,
  productivity,
  mindfulness,
  finance,
  career,
  education,
  travel,
  social,
  family,
  creativity
}

extension InterestExtension on Interest {
  String get name {
    switch (this) {
      case Interest.fitness:
        return 'Fitness';
      case Interest.productivity:
        return 'Productivity';
      case Interest.mindfulness:
        return 'Mindfulness';
      case Interest.finance:
        return 'Finance';
      case Interest.career:
        return 'Career';
      case Interest.education:
        return 'Education';
      case Interest.travel:
        return 'Travel';
      case Interest.social:
        return 'Social';
      case Interest.family:
        return 'Family';
      case Interest.creativity:
        return 'Creativity';
    }
  }
}
