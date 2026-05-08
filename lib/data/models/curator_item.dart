class CuratorItem {
  final String id;
  final String title;
  final String category;
  final String imageUrl;
  final String? aiNarrative;
  final DateTime createdAt;

  CuratorItem({
    required this.id,
    required this.title,
    required this.category,
    required this.imageUrl,
    this.aiNarrative,
    required this.createdAt,
  });

  factory CuratorItem.fromJson(Map<String, dynamic> json) {
    return CuratorItem(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      imageUrl: json['image_url'],
      aiNarrative: json['ai_narrative'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'image_url': imageUrl,
      'ai_narrative': aiNarrative,
    };
  }
}