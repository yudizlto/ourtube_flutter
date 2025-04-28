class SearchVideoEntity {
  final String? id;
  final String? type;
  final String? title;
  final String? description;
  final String? channelId;
  final String? channelTitle;
  final String? publishedAt;
  final String? thumbnailUrl;
  final List<String>? tags;
  final String? categoryId;
  final String? defaultLanguage;
  final String? defaultAudioLanguage;

  SearchVideoEntity({
    this.id,
    this.type,
    this.title,
    this.description,
    this.channelId,
    this.channelTitle,
    this.publishedAt,
    this.thumbnailUrl,
    this.tags,
    this.categoryId,
    this.defaultLanguage,
    this.defaultAudioLanguage,
  });

  factory SearchVideoEntity.fromJson(Map<String, dynamic> json) {
    String type = json["kind"] == "youtube#video" ? "video" : "channel";

    return SearchVideoEntity(
      id: json["id"]["channelId"] ?? json["id"]["videoId"],
      type: type,
      title: json["snippet"]["title"],
      description: json["snippet"]["description"],
      channelId: json["snippet"]["channelId"],
      channelTitle: json["snippet"]["channelTitle"],
      publishedAt: json["snippet"]["publishedAt"],
      thumbnailUrl: json["snippet"]["thumbnails"]["high"]["url"],
      tags: (json["snippet"]["tags"] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      categoryId: json["snippet"]["categoryId"],
      defaultLanguage: json["snippet"]["defaultLanguage"],
      defaultAudioLanguage: json["snippet"]["defaultAudioLanguage"],
    );
  }
}
