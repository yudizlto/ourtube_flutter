class VideoItemEntity {
  final String videoId;
  final String title;
  final String channelTitle;
  final String thumbnailUrl;
  final String publishedAt;
  final String description;

  VideoItemEntity({
    required this.videoId,
    required this.title,
    required this.channelTitle,
    required this.thumbnailUrl,
    required this.publishedAt,
    required this.description,
  });

  factory VideoItemEntity.fromJson(Map<String, dynamic> json) {
    return VideoItemEntity(
      videoId: json["id"],
      title: json["snippet"]["title"],
      channelTitle: json["snippet"]["channelTitle"],
      thumbnailUrl: json["snippet"]["thumbnails"]["high"]["url"],
      publishedAt: json["snippet"]["publishedAt"],
      description: json["snippet"]["description"],
    );
  }
}
