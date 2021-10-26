import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    let chatChannel = "com.example.demo_twilio/chatChannel"
    var methodChannel: FlutterMethodChannel?
    var flutterResult: FlutterResult?
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    methodChannel = FlutterMethodChannel(name: chatChannel, binaryMessenger: controller.binaryMessenger)
    methodChannel?.setMethodCallHandler {
        (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
        self.flutterResult = result
        switch call.method {
        default:
            print(" call.method  error \(call.method)")
        }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

extension AppDelegate: AppDelegateCallback {
    func onCreateBasicChatClientComplete() {
        
    }
    
    func refreshChannelList() {
        
    }
    
    func refreshMessagesList() {
        
    }
    
    func joinChannelSuccess() {
        
    }
    
    func joinChannelError() {
        
    }
    
    func generateNewAccessToken() {
        
    }
    
    
}

class MethodChannelChat {
    public static let initBasicChatClient = "initBasicChatClient"
    public static let refreshChannelList = "refreshChannelList"
    public static let getChannels = "getChannels"
    public static let getMessages = "getMessages"
    public static let refreshMessagesList = "refreshMessagesList"
    public static let removeChannelListener = "removeChannelListener"
    public static let sendMessage = "sendMessage"
    public static let joinChannel = "joinChannel"
    public static let generateNewAccessToken = "generateNewAccessToken"
    public static let generateNewAccessSuccess = "generateNewAccessSuccess"
    public static let deleteMessage = "deleteMessage"
    public static let deleteMessageSuccess = "deleteMessageSuccess"
    public static let updateMessage = "updateMessage"
    public static let updateMessageSuccess = "updateMessageSuccess"
    public static let createChannel = "createChannel"
    public static let inviteByIdentity = "inviteByIdentity"
    public static let typing = "typing"
    public static let onTypingStarted = "onTypingStarted"
    public static let onTypingEnded = "onTypingEnded"
    public static let getMessageBefore = "getMessageBefore"
}

protocol AppDelegateCallback {
    func onCreateBasicChatClientComplete()
    func refreshChannelList()
    func refreshMessagesList()
    func joinChannelSuccess()
    func joinChannelError()
    func generateNewAccessToken()
}
