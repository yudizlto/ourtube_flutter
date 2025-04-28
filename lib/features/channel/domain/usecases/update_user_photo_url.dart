import 'dart:io';

import '../repositories/channel_repository.dart';

class UpdateUserPhotoUrl {
  final ChannelRepository repository;

  UpdateUserPhotoUrl(this.repository);

  Future<void> call(File imageFile) async {
    await repository.uploadPhotoProfile(imageFile);
  }
}
