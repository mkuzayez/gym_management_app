class GymSession {
  final int? id;
  final String memberId;
  final DateTime entryTime;
  final DateTime exitTime;
  final double duration;

  GymSession({
    this.id,
    required this.memberId,
    required this.entryTime,
    required this.exitTime,
    required this.duration,
  });

  factory GymSession.fromJson(Map<String, dynamic> json) {
    return GymSession(
      id: json['id'],
      memberId: json['member'],
      entryTime: DateTime.parse(json['entry_time']),
      exitTime: DateTime.parse(json['exit_time']),
      duration: json['duration'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'member': memberId,
      'entry_time': entryTime.toIso8601String(),
      'exit_time': exitTime.toIso8601String(),
      'duration': duration,
    };
  }
}
