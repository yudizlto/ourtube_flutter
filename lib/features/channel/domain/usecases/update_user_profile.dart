import '../repositories/channel_repository.dart';

class UpdateUserProfile {
  final ChannelRepository repository;

  UpdateUserProfile(this.repository);

  Future<void> call(String field, dynamic value) async {
    await repository.updateUserDataField(field, value);
  }
}
