class PathHelper {
  static String generateUserImagePath(String userId) =>
      "photoProfile/p-$userId";

  static String generateUserBannerPath(String userId) => "banner/b-$userId";

  static String generateVideoThumbnailPath(String userId, String videoId) =>
      "thumbnail/thumbnail-$videoId-$userId";

  static String generateUserLongVideoPath(String videoId, String userId) {
    return "long-video/lv-$videoId-$userId";
  }

  static String generateUserShortVideoPath(String videoId, String userId) {
    return "short-video/lv-$videoId-$userId";
  }
}
