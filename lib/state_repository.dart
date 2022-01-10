import 'dart:math';

class UnauthenticatedError extends Error {}

class StateRepository {
  const StateRepository();

  Future<List<String>> getStates() async {
    await Future.delayed(const Duration(seconds: 2));

    if (Random().nextDouble() < 0.3) throw UnauthenticatedError();

    return [
      'VIC',
      'ACT',
      'NSW',
    ];
  }
}
