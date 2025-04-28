import '../../repositories/video_repository.dart';

class UpdateVideoChangesUseCase {
  final VideoRepository repository;

  UpdateVideoChangesUseCase(this.repository);

  Future<void> execute(
    String videoId,
    String title,
    String desc,
    String visibility,
    bool isCommentsEnabled,
    bool isAgeRestricted,
    bool isAudienceRestricted,
  ) async {
    return repository.updateVideo(
      videoId,
      title,
      desc,
      visibility,
      isCommentsEnabled,
      isAgeRestricted,
      isAudienceRestricted,
    );
  }
}
