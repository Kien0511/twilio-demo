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
        case MethodChannelChat.initBasicChatClient:
            let basicChatClientArgument = BasicChatClientArgument.fromMap(data: call.arguments as! [String: Any?])
            BasicChatClient.instance.setAppDelegateCallback(delegate: self)
            BasicChatClient.instance.createClient(accessToken: basicChatClientArgument.accessToken, firebaseToken: nil)
            break
        case MethodChannelChat.getChannels:
            BasicChatClient.instance.clearChannel()
            BasicChatClient.instance.getListConversation()
            break
        case MethodChannelChat.getMessages:
            BasicChatClient.instance.getmessages(conversationArgument: ConversationArgument.fromMap(data: call.arguments as! [String: Any]))
            break
        case MethodChannelChat.removeChannelListener:
            BasicChatClient.instance.removeConversationListener()
            break
        case MethodChannelChat.sendMessage:
            BasicChatClient.instance.sendMessage(message: call.arguments as! String)
            break
        case MethodChannelChat.joinChannel:
            BasicChatClient.instance.joinConversation(conversationArgument: ConversationArgument.fromMap(data: call.arguments as! [String: Any]))
            break
        case MethodChannelChat.generateNewAccessSuccess:
            BasicChatClient.instance.updateAccessToken(accessToken: call.arguments as! String)
            break
        case MethodChannelChat.deleteMessage:
            BasicChatClient.instance.deleteMessage(messageId: call.arguments as! String)
            break
        case MethodChannelChat.updateMessage:
            BasicChatClient.instance.updateMessage(messageArgument: UpdateMessageArgument.fromMap(json: call.arguments as! [String: Any]))
            break
        case MethodChannelChat.createChannel:
            BasicChatClient.instance.createConversation(conversationName: call.arguments as! String)
            break
        case MethodChannelChat.inviteByIdentity:
            BasicChatClient.instance.inviteByIdentity(identity: call.arguments as! String)
            break
        case MethodChannelChat.typing:
            BasicChatClient.instance.typing()
            break
        case MethodChannelChat.getMessageBefore:
            BasicChatClient.instance.getMessageBefore()
            break
        default:
            print(" call.method  error \(call.method)")
        }
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

extension AppDelegate: AppDelegateCallback {
    func createChannelResult(result: Any) {
        if let flutterResult = flutterResult {
            flutterResult(result)
        }
    }
    
    func onTypingStarted(description: String) {
        if let methodChannel = methodChannel {
            methodChannel.invokeMethod(MethodChannelChat.onTypingStarted, arguments: description)
        }
    }
    
    func onTypingEnded(description: String) {
        if let methodChannel = methodChannel {
            methodChannel.invokeMethod(MethodChannelChat.onTypingEnded, arguments: description)
        }
    }
    
    func loadMoreMessageComplete(list: [MessageItemArgument]) {
        if let flutterResult = flutterResult {
            flutterResult(MessageItemArgument.toMapList(list: list))
        }
    }
    
    func removeMessageSuccess(messageItemArgument: MessageItemArgument) {
        if let methodChannel = methodChannel {
            methodChannel.invokeMethod(MethodChannelChat.deleteMessageSuccess, arguments: messageItemArgument.toMap())
        }
    }
    
    func updateMessageSuccess(messageItemArgument: MessageItemArgument) {
        if let methodChannel = methodChannel {
            methodChannel.invokeMethod(MethodChannelChat.updateMessageSuccess, arguments: messageItemArgument.toMap())
        }
    }
    
    func onCreateBasicChatClientComplete() {
        if let flutterResult = flutterResult {
            flutterResult(true)
        }
    }
    
    func refreshChannelList() {
        if let methodChannel = methodChannel {
            methodChannel.invokeMethod(MethodChannelChat.refreshChannelList, arguments: BasicChatClient.instance.getConversations())
        }
    }
    
    func refreshMessagesList() {
        if let methodChannel = methodChannel {
            methodChannel.invokeMethod(MethodChannelChat.refreshMessagesList, arguments: BasicChatClient.instance.getMessageItemList())
        }
    }
    
    func joinChannelSuccess() {
        if let flutterResult = flutterResult {
            flutterResult(true)
        }
    }
    
    func joinChannelError() {
        if let flutterResult = flutterResult {
            flutterResult(false)
        }
    }
    
    func generateNewAccessToken() {
        if let methodChannel = methodChannel {
            methodChannel.invokeMethod(MethodChannelChat.generateNewAccessToken, arguments: nil)
        }
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
    func removeMessageSuccess(messageItemArgument: MessageItemArgument)
    func updateMessageSuccess(messageItemArgument: MessageItemArgument)
    func createChannelResult(result: Any)
    func onTypingStarted(description: String)
    func onTypingEnded(description: String)
    func loadMoreMessageComplete(list: [MessageItemArgument])
}
