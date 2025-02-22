import 'social_share_platform_interface.dart';

class SocialShare {
  static Future<String?> shareInstagramStory({
    required String appId,
    required String imagePath,
    String? backgroundTopColor,
    String? backgroundBottomColor,
    String? backgroundResourcePath,
    String? attributionURL,
  }) {
    return SocialSharePlatform.instance.shareInstagramStory(
      appId: appId,
      imagePath: imagePath,
      backgroundTopColor: backgroundTopColor,
      backgroundBottomColor: backgroundBottomColor,
      attributionURL: attributionURL,
      backgroundResourcePath: backgroundResourcePath,
    );
  }

  static Future<String?> shareFacebookStory({
    required String appId,
    String? imagePath,
    String? backgroundTopColor,
    String? backgroundBottomColor,
    String? backgroundResourcePath,
    String? attributionURL,
  }) async {
    return SocialSharePlatform.instance.shareFacebookStory(
      appId: appId,
      imagePath: imagePath,
      backgroundTopColor: backgroundTopColor,
      backgroundBottomColor: backgroundBottomColor,
      attributionURL: attributionURL,
      backgroundResourcePath: backgroundResourcePath,
    );
  }

  static Future<String?> shareTwitter(
    String captionText, {
    List<String>? hashtags,
    String? url,
    String? trailingText,
  }) async {
    return SocialSharePlatform.instance.shareTwitter(captionText,
        hashtags: hashtags, url: url, trailingText: trailingText);
  }

  static Future<String?> shareSms(String message,
      {String? url, String? trailingText}) {
    return SocialSharePlatform.instance
        .shareSms(message, trailingText: trailingText, url: url);
  }

  static Future<String?> copyToClipboard({String? text, String? image}) async {
    return SocialSharePlatform.instance
        .copyToClipboard(image: image, text: text);
  }

  static Future<bool?> shareOptions(String contentText,
      {String? imagePath}) async {
    return SocialSharePlatform.instance
        .shareOptions(contentText, imagePath: imagePath);
  }

  static Future<String?> shareWhatsapp(String content) async {
    return SocialSharePlatform.instance.shareWhatsapp(content);
  }

  static Future<Map?> checkInstalledAppsForShare() async {
    return SocialSharePlatform.instance.checkInstalledAppsForShare();
  }

  static Future<String?> shareTelegram(String content) async {
    return SocialSharePlatform.instance.shareTelegram(content);
  }

  static Future<bool> reSaveImage(String? imagePath, String filename) async {
    return SocialSharePlatform.instance.reSaveImage(imagePath, filename);
  }
}
