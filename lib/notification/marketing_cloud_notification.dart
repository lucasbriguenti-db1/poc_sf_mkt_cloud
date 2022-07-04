// ignore_for_file: public_member_api_docs, sort_constructors_first
class MarketingCloudNotification {
  final String title;
  final String body;
  final String? subtitle;
  MarketingCloudNotification({
    required this.title,
    required this.body,
    this.subtitle,
  });

  factory MarketingCloudNotification.fromMap(Map<String, dynamic> map) {
    return MarketingCloudNotification(
      title: map['title'].toString(),
      body: map['alert'].toString(),
      subtitle: map['subtitle']?.toString(),
    );
  }

  @override
  String toString() => 'MarketingCloudNotification(title: $title, body: $body, subtitle: $subtitle)';
}
