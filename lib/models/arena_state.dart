import 'clip.dart';

class ArenaState {
  final Clip current;
  final Clip next;
  final List<Clip> upcoming;
  final String? selectedWinnerId;
  final int duelNumber;

  const ArenaState({
    required this.current,
    required this.next,
    required this.upcoming,
    this.selectedWinnerId,
    this.duelNumber = 1,
  });

  factory ArenaState.initial(List<Clip> clips) {
    if (clips.length < 3) {
      throw Exception('Need at least 3 clips to initialize arena');
    }
    return ArenaState(
      current: clips[0],
      next: clips[1],
      upcoming: clips.sublist(2),
      duelNumber: 1,
    );
  }

  ArenaState copyWith({
    Clip? current,
    Clip? next,
    List<Clip>? upcoming,
    String? selectedWinnerId,
    int? duelNumber,
  }) {
    return ArenaState(
      current: current ?? this.current,
      next: next ?? this.next,
      upcoming: upcoming ?? this.upcoming,
      selectedWinnerId: selectedWinnerId,
      duelNumber: duelNumber ?? this.duelNumber,
    );
  }

  ArenaState nextDuel() {
    if (upcoming.isEmpty) {
      return copyWith(
        current: next,
        next: current,
        selectedWinnerId: null,
        duelNumber: duelNumber + 1,
      );
    }

    final newUpcoming = List<Clip>.from(upcoming);
    final nextClip = newUpcoming.removeAt(0);
    newUpcoming.add(current);

    return ArenaState(
      current: next,
      next: nextClip,
      upcoming: newUpcoming,
      selectedWinnerId: null,
      duelNumber: duelNumber + 1,
    );
  }

  ArenaState selectWinner(String winnerId) {
    return copyWith(selectedWinnerId: winnerId);
  }

  Clip get loser {
    if (selectedWinnerId == null) {
      throw Exception('No winner selected yet');
    }
    return selectedWinnerId == current.id ? next : current;
  }

  Clip get winner {
    if (selectedWinnerId == null) {
      throw Exception('No winner selected yet');
    }
    return selectedWinnerId == current.id ? current : next;
  }

  @override
  String toString() {
    return 'ArenaState(duel: #$duelNumber, current: ${current.id}, next: ${next.id})';
  }
}
