// import 'package:flutter_test/flutter_test.dart';
// import 'package:social_share/social_share.dart';
// import 'package:social_share/social_share_platform_interface.dart';
// import 'package:social_share/social_share_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockSocialSharePlatform
//     with MockPlatformInterfaceMixin
//     implements SocialSharePlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final SocialSharePlatform initialPlatform = SocialSharePlatform.instance;

//   test('$MethodChannelSocialShare is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelSocialShare>());
//   });

//   test('getPlatformVersion', () async {
//     SocialShare socialSharePlugin = SocialShare();
//     MockSocialSharePlatform fakePlatform = MockSocialSharePlatform();
//     SocialSharePlatform.instance = fakePlatform;

//     expect(await socialSharePlugin.getPlatformVersion(), '42');
//   });
// }
