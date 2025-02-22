import Flutter
import UIKit

public class SocialSharePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "social_share", binaryMessenger: registrar.messenger())
    let instance = SocialSharePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
     switch call.method {
        case "shareInstagramStory", "shareFacebookStory":
            handleStoryShare(call: call, result: result)
        case "copyToClipboard":
            handleCopyToClipboard(call: call, result: result)
        case "shareTwitter":
            handleShareTwitter(call: call, result: result)
        case "shareSms":
            handleShareSms(call: call, result: result)
        case "shareSlack":
            result(true)
        case "shareWhatsapp":
            handleShareWhatsapp(call: call, result: result)
        case "shareTelegram":
            handleShareTelegram(call: call, result: result)
        case "shareOptions":
            handleShareOptions(call: call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    private func handleStoryShare(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            result("iOS could not recognize flutter arguments in method: (sendParams)")
            return
        }
        
        let destination: String
        let stories: String
        if call.method == "shareInstagramStory" {
            destination = "com.instagram.sharedSticker"
            stories = "instagram-stories"
        } else {
            destination = "com.facebook.sharedSticker"
            stories = "facebook-stories"
        }
        
        let stickerImage = args["stickerImage"] as? String
        let backgroundTopColor = args["backgroundTopColor"] as? String
        let backgroundBottomColor = args["backgroundBottomColor"] as? String
        let attributionURL = args["attributionURL"] as? String
        let backgroundImage = args["backgroundImage"] as? String
        let backgroundVideo = args["backgroundVideo"] as? String
        
        let fileManager = FileManager.default
        var appId = args["appId"] as? String
        
        if backgroundTopColor == nil {
            if let path = Bundle.main.path(forResource: "Info", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String: Any] {
                appId = dict["FacebookAppID"] as? String
            }
        }
        
        var pasteboardItems: [String: Any] = [:]
        
        if let stickerImage = stickerImage, fileManager.fileExists(atPath: stickerImage),
        let imgShare = try? Data(contentsOf: URL(fileURLWithPath: stickerImage)) {
            pasteboardItems["\(destination).stickerImage"] = imgShare
        }
        
        if let backgroundTopColor = backgroundTopColor {
            pasteboardItems["\(destination).backgroundTopColor"] = backgroundTopColor
        }
        
        if let backgroundBottomColor = backgroundBottomColor {
            pasteboardItems["\(destination).backgroundBottomColor"] = backgroundBottomColor
        }
        
        if let attributionURL = attributionURL {
            pasteboardItems["\(destination).contentURL"] = attributionURL
        }
        
        if let appId = appId, call.method == "shareFacebookStory" {
            pasteboardItems["\(destination).appID"] = appId
        }
        
        if let backgroundImage = backgroundImage, fileManager.fileExists(atPath: backgroundImage),
        let imgBackgroundShare = try? Data(contentsOf: URL(fileURLWithPath: backgroundImage)) {
            pasteboardItems["\(destination).backgroundImage"] = imgBackgroundShare
        }
        
        if let backgroundVideo = backgroundVideo, fileManager.fileExists(atPath: backgroundVideo),
        let videoBackgroundShare = try? Data(contentsOf: URL(fileURLWithPath: backgroundVideo)) {
            pasteboardItems["\(destination).backgroundVideo"] = videoBackgroundShare
        }
        
        let urlScheme = URL(string: "\(stories)://share?source_application=\(appId ?? "")")!
        
        if UIApplication.shared.canOpenURL(urlScheme) {
            if #available(iOS 10.0, *) {
                let pasteboardOptions: [UIPasteboard.OptionsKey: Any] = [.expirationDate: Date().addingTimeInterval(60 * 5)]
                UIPasteboard.general.setItems([pasteboardItems], options: pasteboardOptions)
                UIApplication.shared.open(urlScheme, options: [:], completionHandler: nil)
                result("success")
            } else {
                result("error")
            }
        } else {
            result("error")
        }
    }
    
    private func handleCopyToClipboard(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            result("iOS could not recognize flutter arguments in method: (sendParams)")
            return
        }
        
        let content = args["content"] as? String
        let pasteboard = UIPasteboard.general
        
        if let content = content {
            pasteboard.string = content
        }
        
        if let image = args["image"] as? String, FileManager.default.fileExists(atPath: image),
        let imageData = UIImage(contentsOfFile: image) {
            pasteboard.image = imageData
        }
        
        result("success")
    }
    
    private func handleShareTwitter(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            result("iOS could not recognize flutter arguments in method: (sendParams)")
            return
        }
        
        let captionText = args["captionText"] as? String ?? ""
        let urlSchemeTwitter = "twitter://post?message=\(captionText)"
        let urlTextEscaped = urlSchemeTwitter.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlSchemeSend = URL(string: urlTextEscaped)!
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(urlSchemeSend, options: [:], completionHandler: nil)
            result("success")
        } else {
            result("error")
        }
    }
    
    private func handleShareSms(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            result("iOS could not recognize flutter arguments in method: (sendParams)")
            return
        }
        
        let msg = args["message"] as? String ?? ""
        let urlstring = args["urlLink"] as? String ?? ""
        let trailingText = args["trailingText"] as? String ?? ""
        
        let urlScheme = URL(string: "sms://")!
        
        let urlTextEscaped = urlstring.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let url = URL(string: urlTextEscaped)!
        
        if url.absoluteString.isEmpty {
            let urlSchemeSms = "sms:?&body=\(msg)"
            let urlSchemeMsg = URL(string: urlSchemeSms)!
            
            if UIApplication.shared.canOpenURL(urlScheme) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(urlSchemeMsg, options: [:], completionHandler: nil)
                    result("success")
                } else {
                    result("error")
                }
            } else {
                result("error")
            }
        } else {
            let urlSchemeSms = "sms:?&body=\(msg)"
            let urlWithLink = urlSchemeSms + url.absoluteString
            let finalUrl = urlWithLink + trailingText
            let urlSchemeMsg = URL(string: finalUrl)!
            
            if UIApplication.shared.canOpenURL(urlScheme) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(urlSchemeMsg, options: [:], completionHandler: nil)
                    result("success")
                } else {
                    result("error")
                }
            } else {
                result("error")
            }
        }
    }
    
    private func handleShareWhatsapp(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            result("iOS could not recognize flutter arguments in method: (sendParams)")
            return
        }
        
        let content = args["content"] as? String ?? ""
        let urlWhats = "whatsapp://send?text=\(content)"
        let whatsappURL = URL(string: urlWhats.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")!
        
        if UIApplication.shared.canOpenURL(whatsappURL) {
            UIApplication.shared.open(whatsappURL)
            result("success")
        } else {
            result("error")
        }
    }
    
    private func handleShareTelegram(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            result("iOS could not recognize flutter arguments in method: (sendParams)")
            return
        }
        
        let content = args["content"] as? String ?? ""
        let urlScheme = "tg://msg?text=\(content)"
        let telegramURL = URL(string: urlScheme.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")!
        
        if UIApplication.shared.canOpenURL(telegramURL) {
            UIApplication.shared.open(telegramURL)
            result("success")
        } else {
            result("error")
        }
    }
    
    private func handleShareOptions(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let args = call.arguments as? [String: Any] else {
            result("iOS could not recognize flutter arguments in method: (sendParams)")
            return
        }
        
        let content = args["content"] as? String ?? ""
        let image = args["image"] as? String ?? ""
        
        if image.isEmpty {
            let objectsToShare = [content]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            let controller = UIApplication.shared.keyWindow?.rootViewController
            controller?.present(activityVC, animated: true, completion: nil)
            result(true)
        } else {
            let fileManager = FileManager.default
            let isFileExist = fileManager.fileExists(atPath: image)
            var imgShare: UIImage? = nil
            if isFileExist {
                imgShare = UIImage(contentsOfFile: image)
            }
            let objectsToShare = [content, imgShare as Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            let controller = UIApplication.shared.keyWindow?.rootViewController
            controller?.present(activityVC, animated: true, completion: nil)
            result(true)
        }
    }
}
