import 'dart:io';

import '../repositories/channel_repository.dart';

class UpdateBannerUrl {
  final ChannelRepository repository;

  UpdateBannerUrl(this.repository);

  Future<void> call(File imageFile) async {
    await repository.uploadBanner(imageFile);
  }
}
