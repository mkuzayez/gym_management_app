class Member {
  final String phoneNumber;
  final String name;
  final DateTime subscriptionStart;
  final DateTime? subscriptionEnd;
  final bool isInGym;
  final DateTime? entryTime;
  final DateTime dateJoined;
  final bool isActive;
  final bool hasActiveSubscription;

  Member({
    required this.phoneNumber,
    required this.name,
    required this.subscriptionStart,
    this.subscriptionEnd,
    this.isInGym = false,
    this.entryTime,
    required this.dateJoined,
    this.isActive = true,
    this.hasActiveSubscription = false,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      phoneNumber: json['phone_number'],
      name: json['name'],
      subscriptionStart: DateTime.parse(json['subscription_start']),
      subscriptionEnd: json['subscription_end'] != null 
          ? DateTime.parse(json['subscription_end']) 
          : null,
      isInGym: json['is_in_gym'],
      entryTime: json['entry_time'] != null 
          ? DateTime.parse(json['entry_time']) 
          : null,
      dateJoined: DateTime.parse(json['date_joined']),
      isActive: json['is_active'],
      hasActiveSubscription: json['has_active_subscription'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone_number': phoneNumber,
      'name': name,
      'subscription_start': subscriptionStart.toIso8601String(),
      'subscription_end': subscriptionEnd?.toIso8601String(),
      'is_in_gym': isInGym,
      'entry_time': entryTime?.toIso8601String(),
      'date_joined': dateJoined.toIso8601String(),
      'is_active': isActive,
      'has_active_subscription': hasActiveSubscription,
    };
  }
}
