import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'social_share_method_channel.dart';

abstract class SocialSharePlatform extends PlatformInterface {
  SocialSharePlatform() : super(token: _token);
  static final Object _token = Object();
  static SocialSharePlatform _instance = MethodChannelSocialShare();
  static SocialSharePlatform get instance => _instance;

  static set instance(SocialSharePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> shareInstagramStory({
    required String appId,
    required String imagePath,
    String? backgroundTopColor,
    String? backgroundBottomColor,
    String? backgroundResourcePath,
    String? attributionURL,
  });

  Future<String?> shareFacebookStory({
    required String appId,
    String? imagePath,
    String? backgroundTopColor,
    String? backgroundBottomColor,
    String? backgroundResourcePath,
    String? attributionURL,
  });

  Future<String?> shareMetaStory({
    required String appId,
    required String platform,
    String? imagePath,
    String? backgroundTopColor,
    String? backgroundBottomColor,
    String? attributionURL,
    String? backgroundResourcePath,
  });

  Future<String?> shareTwitter(
    String captionText, {
    List<String>? hashtags,
    String? url,
    String? trailingText,
  });

  Future<String?> shareSms(String message, {String? url, String? trailingText});

  Future<String?> copyToClipboard({String? text, String? image});

  Future<bool?> shareOptions(String contentText, {String? imagePath});

  Future<String?> shareWhatsapp(String content);

  Future<Map?> checkInstalledAppsForShare();

  Future<String?> shareTelegram(String content);

  Future<bool> reSaveImage(String? imagePath, String filename);
}
