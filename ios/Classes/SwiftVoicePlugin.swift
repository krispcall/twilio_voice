import Flutter
import UIKit
import TwilioVoice
import CallKit
import PushKit
import UserNotifications
//import Foundation
import AVFoundation



var  TAG = "TwilioVoiceIOS";

/**
 ERROR:Twilio:[Signaling](0x16f913000): RESIP::TRANSPORT: Got TLS read ret=0 error=5 error:00000005:invalid library (0):OPENSSL_internal:Diffie-Hellman routines - intermediate certificates may be missing from local PEM file
 */



public class SwiftTwilioVoice: NSObject, FlutterPlugin, AVAudioPlayerDelegate {
    
    private var activeCall: Call?
    var callKitProvider: CXProvider
    var audioDevice: DefaultAudioDevice = DefaultAudioDevice()
    
    private var activeCallInvite: CallInvite?
    private var dumpActiveCallInvite: CallInvite?
    private var cancelledCallInvites: CancelledCallInvite?
    var callKitCompletionCallback: ((Bool)->Swift.Void?)? = nil
    var incomingPushCompletionCallback: (()->Swift.Void?)? = nil
    var accessToken:String?
    let kRegistrationTTLInDays = 365
    
    var _result: FlutterResult?
    public static var loggingSink: FlutterEventSink?
    public static  var nativeDebug = false
    public static var messenger: FlutterBinaryMessenger?
    public static var reasonForTokenRetrieval: String?
    public static  var instance: SwiftTwilioVoice?
    var callKitCallController: CXCallController
    var callOutgoing: Bool = false;
    var defaultCaller = "Unknown Caller"
    private var clients: [String:String]!
    //    var callKitProvider: CXProvider
    let kClientList = "TwilioContactList"
    
    let kCachedDeviceToken = "CachedDeviceToken"
    let kCachedBindingDate = "CachedBindingDate"
    var voipRegistry: PKPushRegistry
    
    var deviceToken: Data? {
        get{UserDefaults.standard.data(forKey: kCachedDeviceToken)}
        set{UserDefaults.standard.setValue(newValue, forKey: kCachedDeviceToken)}
    }
    
    
    private  var methodChannel: FlutterMethodChannel?
    public static var methodChannelSink: FlutterEventSink?
    
    private  var registrationChannel: FlutterEventChannel?
    public  static var notificationSink: FlutterEventSink?
    
    public  var handleMessageChannel: FlutterEventChannel?
    public  static var handleMessageSink: FlutterEventSink?
    
    private  var callOutGoingChannel: FlutterEventChannel?
    public  static var callOutGoingSink: FlutterEventSink?
    
    private  var callIncomingChannel: FlutterEventChannel?
    public  static var callIncomingSink: FlutterEventSink?
    
    //intit
    public override init() {
        let configuration = CXProviderConfiguration(localizedName: "Test" as String)
        configuration.maximumCallGroups = 1
        configuration.maximumCallsPerCallGroup = 1
        if let callKitIcon = UIImage(named: "logo_white") {
            configuration.iconTemplateImageData = callKitIcon.pngData()
        }
        self.voipRegistry = PKPushRegistry.init(queue: DispatchQueue.main)
        callKitProvider = CXProvider(configuration: configuration)
        callKitCallController = CXCallController()
        clients = UserDefaults.standard.object(forKey: kClientList)  as? [String:String] ?? [:]
        
        super.init()
        callKitProvider.setDelegate(self, queue: nil)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = Set([PKPushType.voIP])
        
        let appDelegate = UIApplication.shared.delegate
        
        guard let controller = appDelegate?.window??.rootViewController as? FlutterViewController else {
            fatalError("rootViewController is not type FlutterViewController")
        }
        TwilioVoiceSDK.setLogLevel(TwilioVoiceSDK.LogLevel.all, module: TwilioVoiceSDK.LogModule.signaling)
        TwilioVoiceSDK.setLogLevel(TwilioVoiceSDK.LogLevel.all, module: TwilioVoiceSDK.LogModule.core)
        TwilioVoiceSDK.setLogLevel(TwilioVoiceSDK.LogLevel.all, module: TwilioVoiceSDK.LogModule.webRTC)
        TwilioVoiceSDK.setLogLevel(TwilioVoiceSDK.LogLevel.all, module: TwilioVoiceSDK.LogModule.platform)
        TwilioVoiceSDK.isInsightsEnabled = true
    }
    
    deinit {
        // CallKit has an odd API contract where the developer must call invalidate or the CXProvider is leaked.
        callKitProvider.invalidate()
    }
    
    //Registry
    public static func register(with registrar: FlutterPluginRegistrar) {
        instance = SwiftTwilioVoice()
        instance?.onRegister(registrar)
    }
    
    func reportIncomingCall(from: String, uuid: UUID) {
        let callHandle = CXHandle(type: .generic, value: from)
        let callUpdate = CXCallUpdate()
        callUpdate.remoteHandle = callHandle
        callUpdate.localizedCallerName = from
        callUpdate.supportsDTMF = true
        callUpdate.supportsHolding = true
        callUpdate.supportsGrouping = false
        callUpdate.supportsUngrouping = false
        callUpdate.hasVideo = false
        
        callKitProvider.reportNewIncomingCall(with: uuid, update: callUpdate) { error in
            if let error = error {
                //                self.sendPhoneCallEvents(description: "LOG|Failed to report incoming call successfully: \(error.localizedDescription).", isError: false)
            } else {
                //                self.sendPhoneCallEvents(description: "LOG|Incoming call successfully reported.", isError: false)
            }
        }
    }
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    func performAnswerVoiceCall(uuid: UUID, completionHandler: @escaping (Bool) -> Swift.Void) {
        if let ci = self.activeCallInvite {
            let acceptOptions: AcceptOptions = AcceptOptions(callInvite: ci) { (builder) in
                builder.uuid = ci.uuid
            }
            let theCall = ci.accept(options: acceptOptions, delegate: self)
            sendEventHandleCall("onAnswerCall", data:Mapper.callInviteToDict(ci),error:nil)
            self.activeCall = theCall
            self.activeCallInvite = nil
            guard #available(iOS 13, *) else {
                self.incomingPushHandled()
                return
            }
            UserDefaults.standard.setValue(true, forKey: "flutter.VALUE_HOLDER_USER_INCOMING_CALL_IN_PROGRESS")
        } else {
            sendEventIncomingCall("onConnectFailure",data:Mapper.callToDict(activeCall), error: nil)
        }
    }
    
    func performEndCallAction(uuid: UUID) {
        let endCallAction = CXEndCallAction(call: uuid)
        let transaction = CXTransaction(action: endCallAction)
        
        callKitCallController.request(transaction) { error in
            if let error = error {
                print("Twilio Voice: this is error",error.localizedDescription)
            } else {
                print("Twilio Voice: this is performEndCallAction")
            }
        }
    }
    
    func incomingPushHandled() {
        if let completion = self.incomingPushCompletionCallback {
            self.incomingPushCompletionCallback = nil
            completion()
        }
    }
    
    public static func debug(_ msg: String) {
        if SwiftTwilioVoice.nativeDebug {
            NSLog(msg)
            guard let loggingSink = loggingSink else {
                return
            }
            loggingSink(msg)
        }
    }
    
    public func onRegister(_ registrar: FlutterPluginRegistrar) {
        SwiftTwilioVoice.messenger = registrar.messenger()
        let pluginHandler = PluginHandler()
        
        methodChannel = FlutterMethodChannel(name: "TwilioVoice", binaryMessenger: registrar.messenger())
        methodChannel?.setMethodCallHandler(pluginHandler.handle)
        
        registrationChannel = FlutterEventChannel(name: "TwilioVoice/registrationChannel",binaryMessenger: registrar.messenger())
        registrationChannel?.setStreamHandler(RegistrationStreamHandler())
        
        handleMessageChannel = FlutterEventChannel(name:"TwilioVoice/handleMessage",binaryMessenger:registrar.messenger())
        handleMessageChannel?.setStreamHandler((HanldeMessageChannelStream()))
        
        callOutGoingChannel = FlutterEventChannel(name:"TwilioVoice/callOutGoingChannel",binaryMessenger:registrar.messenger())
        callOutGoingChannel?.setStreamHandler((CallOutGoingHandler()))
        
        
        callIncomingChannel = FlutterEventChannel(name:"TwilioVoice/callIncomingChannel",binaryMessenger:registrar.messenger())
        callIncomingChannel?.setStreamHandler((CallIncomingHandler()))
        
        
        registrar.addApplicationDelegate(self)
    }
    
    public func registerForNotification(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments:Dictionary<String, AnyObject> = call.arguments as! Dictionary<String,   AnyObject>;
        
        
        guard let accessToken = arguments["accessToken"] as? String else {
            return result (["result": true])
        }
        SwiftTwilioVoice.reasonForTokenRetrieval = "register"
        UIApplication.shared.registerForRemoteNotifications()
        
        if let deviceToken = self.deviceToken, let token = accessToken as? String {
            TwilioVoiceSDK.register(accessToken: token, deviceToken: deviceToken) { (error) in
                if let error = error {
                    self.sendNotificationEvent("registerForNotification", data: ["result": false, "errorCode": error._code, "errorMsg": error.localizedDescription], error: error)
                    return result(["result" : false, "errorCode": error._code, "errorMsg": error.localizedDescription] as [String : Any])
                }
                else {
                    self.sendNotificationEvent("registerForNotification", data: ["result": true, "errorCode": "000000000", "errorMsg": ""], error: error)
                }
                return result( ["result" : true, "errorCode": "000000000", "errorMsg": ""] as [String : Any])
            }
        }
    }
    
    public func makeCallWithSid(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        _result = result
        
        let arguments:Dictionary<String, AnyObject> = call.arguments as! Dictionary<String, AnyObject>;
        callOutgoing = true;
        
        guard let accessToken = arguments["accessToken"] as?String else { return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'accessToken' parameter", details: nil))}
        
        guard let callTo = arguments["To"] as? String else {
            return  result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'callTo' parameter", details: nil))}
        
        guard let callFrom = arguments["from"] as? String else { return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'from' parameter", details: nil))}
        
        guard let workspaceSid = arguments["workspaceSid"] as?String else { return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'workspaceSid' parameter", details: nil))}
        
        guard  let  channelSid = arguments["channelSid"] as?String else{ return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'channelSid' parameter", details: nil))}
        
        guard  let  agentId = arguments["agentId"] as?String else{ return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'agentId' parameter", details: nil))}
        
        guard  let  hubspotClient = arguments["hubspotClient"] as?String else{ return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'hubspotClient' parameter", details: nil))}
        
        guard  let  conversationSid = arguments["conversationSid"] as?String else{ return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'conversationSid' parameter", details: nil))}
        
        let connectOptions = ConnectOptions(accessToken: accessToken) { builder in
            builder.params = ["To": callTo,
                              "From":callFrom,
                              "workspace_sid":workspaceSid,
                              "channel_sid":channelSid,
                              "agent_id": agentId ,
                              "platform": "mobile",
                              "hubspot_client":hubspotClient,
                              "conversationSid":conversationSid,]
        }
        
        activeCall  = TwilioVoiceSDK.connect(options: connectOptions, delegate: self)
    }
    
    public func makeCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        _result = result
        
        let arguments:Dictionary<String, AnyObject> = call.arguments as! Dictionary<String, AnyObject>;
        callOutgoing = true;
        
        guard let callTo = arguments["To"] as? String else {
            return  result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'callTo' parameter", details: nil))}
        
        guard let callFrom = arguments["from"] as? String else { return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'from' parameter", details: nil))}
        
        guard let accessToken = arguments["accessToken"] as?String else { return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'accessToken' parameter", details: nil))}
        
        guard  let  displayName = arguments["displayName"] as?String else{ return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'displayName' parameter", details: nil))}
        
        let connectOptions = ConnectOptions(accessToken: accessToken) { builder in
            builder.params = ["To": callTo,
                              "from":callFrom,
                              "accessToken":accessToken,
                              "displayName":displayName ]
        }
        
        activeCall  = TwilioVoiceSDK.connect(options: connectOptions,delegate: self)
    }
    
    public  func sendDigit(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        let arguments:Dictionary<String, AnyObject> = call.arguments as! Dictionary<String,   AnyObject>;
        
        guard let digit = arguments["digit"] as? String
        else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'digit' parameter", details: nil))
        }
        activeCall?.sendDigits(digit)
    }
    
    public func handleMessage(_ message: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments:Dictionary<String, AnyObject> = message.arguments as! Dictionary<String,   AnyObject>;
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted: Bool, _: Error?) in
                SwiftTwilioVoice.debug("User responded to permissions request: \(granted)")
                if granted {
                    DispatchQueue.main.async {
                        SwiftTwilioVoice.debug("Requesting APNS token")
                        SwiftTwilioVoice.reasonForTokenRetrieval = "register"
                        UIApplication.shared.registerForRemoteNotifications()
                        TwilioVoiceSDK.handleNotification(arguments, delegate:self, delegateQueue:nil)
                    }
                }
            }
        }
    }
    
    func showMissedCallNotification(from:String?, to:String?){
        guard UserDefaults.standard.bool(forKey: "show-notifications") else{return}
        let notificationCenter = UNUserNotificationCenter.current()
        
        
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                let content = UNMutableNotificationContent()
                var userName:String?
                
                if var from = from{
                    from = from.replacingOccurrences(of: "client:", with: "")
                    content.userInfo = ["type":"Missed Call", "From":from]
                    if let to = to{
                        content.userInfo["To"] = to
                    }
                    let encoder = JSONEncoder()
                    if let jsonData = try? encoder.encode(["content": [ "id": "1", "channelKey": "basic_channel", "title": "Missed Call","body": "From: \(from)"]]) {
                        if let jsonString = String(data: jsonData, encoding: .utf8) {
                            content.userInfo["body"] = jsonString
                            userName = self.clients[from]
                        }
                    }
                    
                }
                let title = userName ?? self.clients["defaultCaller"] ?? self.defaultCaller
                content.title = String(format:  NSLocalizedString("Missed Call", comment: ""),title)
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                    content: content,
                                                    trigger: trigger)
                notificationCenter.add(request) { (error) in
                    if let error = error {
                    }
                }
                
            }
        }
    }
    
    public func rejectCall(){
        if(activeCallInvite != nil)
        {
            activeCallInvite?.reject()
        }
        else
        {
            NSLog(TAG, "handleMessage kt: activeCallInvite is null. Pass handleMessage before invoking")
        }
    }
    
    public func disConnect(){
        activeCall?.disconnect()
        guard let id = activeCall?.uuid else {
            return
        }
        let direction = (self.callOutgoing ? "Outgoing" : "Incoming")
        if(direction == "Incoming"){
            callKitProvider.reportCall(with: id, endedAt: Date(), reason: .answeredElsewhere)
        }else{
            callKitProvider.reportCall(with: id, endedAt: Date(), reason: .answeredElsewhere)
        }
    }
    
    public func hold(){
        if(activeCall != nil){
            let hold = !(activeCall?.isOnHold ?? false) as Bool
            activeCall?.isOnHold = hold
        }
    }
    
    public func mute(){
        if (activeCall != nil)
        {
            if((activeCall?.isMuted == false)){
                activeCall?.isMuted = true;
            }else {
                activeCall?.isMuted = false;
            }
        }
    }
    
    public func acceptCall(){
        if(activeCall != nil){
            activeCallInvite?.accept(with: self)
        }
    }
    
    public func unregisterForNotification(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let arguments:Dictionary<String, AnyObject> = call.arguments as! Dictionary<String,   AnyObject>;
        
        guard let accessToken = arguments["accessToken"] as? String else {
            return result (["result": true])
        }
        SwiftTwilioVoice.debug("Requesting APNS token")
        SwiftTwilioVoice.reasonForTokenRetrieval = "deregister"
        UIApplication.shared.registerForRemoteNotifications()
        
        if let deviceToken = self.deviceToken, let token = accessToken as? String {
            TwilioVoiceSDK.unregister(accessToken: token, deviceToken: deviceToken) { (error) in
                if let error = error {
                    self.sendNotificationEvent("unregisterForNotification",data:["result": false, "errorCode": error._code, "errorMsg": error.localizedDescription],error: error as NSError)
                    return result( ["result" : false, "errorCode": error._code, "errorMsg": error.localizedDescription] as [String : Any])
                }
                else {
                    self.sendNotificationEvent("unregisterForNotification",data:["result": true, "errorCode": "000000000", "errorMsg": ""],error: nil)
                    return result (["result": true, "errorCode": "000000000", "errorMsg": ""] as [String : Any])
                }
            }
        }
        
    }
    
    class CallOutGoingHandler: NSObject, FlutterStreamHandler {
        
        func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
            debug("CallOutGoingHandler.onListen => MediaProgress eventChannel attached")
            callOutGoingSink = events
            return nil
        }
        
        func onCancel(withArguments arguments: Any?) -> FlutterError? {
            debug("CallOutGoingHandler.onCancel => MediaProgress eventChannel detached")
            callOutGoingSink = nil
            return nil
        }
    }
    
    class CallIncomingHandler: NSObject, FlutterStreamHandler {
        
        func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
            debug("CallOutIncomingHandler.onListen => MediaProgress eventChannel attached")
            callIncomingSink = events
            return nil
        }
        
        func onCancel(withArguments arguments: Any?) -> FlutterError? {
            debug("CallIncomingHandler.onCancel => MediaProgress eventChannel detached")
            callIncomingSink = nil
            return nil
        }
    }
    
    class LoggingStreamHandler: NSObject, FlutterStreamHandler {
        
        func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
            SwiftTwilioVoice.debug("LoggingStreamHandler.onListen => Logging eventChannel attached")
            loggingSink = events
            return nil
        }
        
        func onCancel(withArguments arguments: Any?) -> FlutterError? {
            SwiftTwilioVoice.debug("LoggingStreamHandler.onCancel => Logging eventChannel detached")
            loggingSink = nil
            return nil
        }
        
    }
    
    class HanldeMessageChannelStream: NSObject, FlutterStreamHandler {
        
        func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
            SwiftTwilioVoice.debug("HandleMessageStreamHandler.onListen => Message eventChannel attached")
            handleMessageSink = events
            return nil
        }
        
        func onCancel(withArguments arguments: Any?) -> FlutterError? {
            SwiftTwilioVoice.debug("HandleMessageStreamHandler.onCancel => Message eventChannel detached")
            handleMessageSink = nil
            return nil
        }
    }
    
    //Notification registration event hadlers------------------------------------------------------
    
    private func sendNotificationEvent(_ name: String, data: [String: Any]? = nil, error: Error? = nil) {
        let eventData = ["name": name, "data": data, "error": Mapper.errorToDict(error)] as [String: Any?]
        
        if let notificationSink = SwiftTwilioVoice.notificationSink {
            notificationSink(eventData)
        }
    }
    
    class RegistrationStreamHandler: NSObject, FlutterStreamHandler {
        
        func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
            SwiftTwilioVoice.debug("NotificationStreamHandler.onListen => Registration eventChannel attached")
            notificationSink = events
            return nil
        }
        
        func onCancel(withArguments arguments: Any?) -> FlutterError? {
            SwiftTwilioVoice.debug("NotificationStreamHandler.onCancel => Registration eventChannel detached")
            notificationSink = nil
            return nil
        }
    }
    
    public func trackLog(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        return result (["result": [], "errorCode": "000000000", "errorMsg": ""])
    }
}

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}


extension SwiftTwilioVoice: PKPushRegistryDelegate {
    
    public func pushRegistry(_ registry: PKPushRegistry, didUpdate
                             pushCredentials: PKPushCredentials, for type: PKPushType) {
        if type != PKPushType.voIP {
            self.deviceToken = pushCredentials.token as Data;
            return
        }
        
        guard registrationRequired() || deviceToken != pushCredentials.token else { return }
        
        let deviceToken = pushCredentials.token
        if  let token = self.accessToken as? String {
            TwilioVoiceSDK.register(accessToken: token, deviceToken: deviceToken) { (error) in
                if let error = error {
                    self.sendNotificationEvent("registerForNotification", data: ["result": true], error: error)
                }
                else {
                    self.sendNotificationEvent("registerForNotification", data: ["result": true], error: error)
                }
            }
        }
        self.deviceToken = deviceToken
        UserDefaults.standard.set(Date(), forKey: kCachedBindingDate)
    }
    
    /**
     * The TTL of a registration is 1 year. The TTL for registration for this device/identity pair is reset to
     * 1 year whenever a new registration occurs or a push notification is sent to this device/identity pair.
     * This method checks if binding exists in UserDefaults, and if half of TTL has been passed then the method
     * will return true, else false.
     */
    func registrationRequired() -> Bool {
        guard
            let lastBindingCreated = UserDefaults.standard.object(forKey: kCachedBindingDate)
        else { return true }
        
        let date = Date()
        var components = DateComponents()
        components.setValue(kRegistrationTTLInDays/2, for: .day)
        let expirationDate = Calendar.current.date(byAdding: components, to: lastBindingCreated as! Date)!
        
        if expirationDate.compare(date) == ComparisonResult.orderedDescending {
            return false
        }
        return true;
    }
    
    /**
     * Try using the `pushRegistry:didReceiveIncomingPushWithPayload:forType:withCompletionHandler:` method if
     * your application is targeting iOS 11. According to the docs, this delegate method is deprecated by Apple.
     */
    public func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType) {
        self.callOutgoing = false;
        if (type == PKPushType.voIP) {
            TwilioVoiceSDK.handleNotification(payload.dictionaryPayload, delegate: self, delegateQueue: nil)
        }
    }
    
    /**
     * This delegate method is available on iOS 11 and above. Call the completion handler once the
     * notification payload is passed to the `TwilioVoice.handleNotification()` method.
     */
    public func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        self.callOutgoing = false;
        if (type == PKPushType.voIP) {
            TwilioVoiceSDK.handleNotification(payload.dictionaryPayload, delegate: self, delegateQueue: nil)
        }
        
        if let version = Float(UIDevice.current.systemVersion), version < 13.0 {
            // Save for later when the notification is properly handled.
            self.incomingPushCompletionCallback = completion
        } else {
            /**
             * The Voice SDK processes the call notification and returns the call invite synchronously. Report the incoming call to
             * CallKit and fulfill the completion before exiting this callback method.
             */
            completion()
        }
    }
    
    public func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
    }
}

extension SwiftTwilioVoice: CXProviderDelegate{
    // MARK: CXProviderDelegate
    public func providerDidReset(_ provider: CXProvider) {
        audioDevice.isEnabled = false
    }
    
    public func providerDidBegin(_ provider: CXProvider) {
    }
    
    public func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        audioDevice.isEnabled = true
    }
    
    public func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        audioDevice.isEnabled = false
    }
    
    public func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
    }
    
    public func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        provider.reportOutgoingCall(with: action.callUUID, startedConnectingAt: Date())
        action.fulfill()
    }
    
    public func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        self.performAnswerVoiceCall(uuid: action.callUUID) { (success) in
            if success {
                self.callOutgoing = false;
            } else {
                self.sendEventIncomingCall("onConnectFailure",data:Mapper.callToDict(self.activeCall), error: nil)
            }
        }
        action.fulfill()
    }
    
    
    public func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        if (self.activeCallInvite != nil) {
            self.activeCallInvite?.reject()
            self.activeCallInvite = nil
        }else if let call = self.activeCall {
            callOutgoing = false;
            call.disconnect()
        }
        action.fulfill()
    }
    
    public func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        if let call = self.activeCall {
            call.isOnHold = action.isOnHold
            action.fulfill()
        } else {
            action.fail()
        }
    }
    
    public func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        if let call = self.activeCall {
            call.isMuted = action.isMuted
            action.fulfill()
        } else {
            action.fail()
        }
    }
}

extension SwiftTwilioVoice: NotificationDelegate{
    // MARK: Call Receive
    
    // Call
    
    public func callInviteReceived(callInvite: CallInvite) {
        let isOutgoingInProgress = UserDefaults.standard.bool(forKey: "flutter.VALUE_HOLDER_USER_OUTGOING_CALL_IN_PROGRESS")
        let isIncomingInProgress = UserDefaults.standard.bool(forKey: "flutter.VALUE_HOLDER_USER_INCOMING_CALL_IN_PROGRESS")
        if(isOutgoingInProgress){
            callInvite.reject()
            return
        }
        else if(isIncomingInProgress){
            callInvite.reject()
            return
        }
        else{
            activeCallInvite = callInvite
            self.dumpActiveCallInvite = callInvite
            sendEventHandleCall("onCallInvite",data:Mapper.callInviteToDict(callInvite),error:nil)
            let contactName:String? = callInvite.customParameters?["contact_name"]
            let contactNumber:String? = "+\(callInvite.customParameters?["from"]?.trimmingCharacters(in: .whitespaces) ?? "")"
            var channelName:String? = ""
            do {
                let dump:String? = callInvite.customParameters?["channel_info"]
                let cleaned = dump!.replacingOccurrences(of: "\'", with: "\"")
                
                let data = Data(cleaned.utf8)
                if let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    channelName = dictionary["name"] as? String
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
            
            let result:String? = ((contactName != nil && (contactName?.lowercased() != "null")) && (contactName != nil && contactName?.lowercased() != "unknown")) ? ((contactName ?? "") + "(" + (channelName ?? "")) + ")" : ((contactNumber ?? "") + "(" + (channelName ?? "") + ")" )
            
            reportIncomingCall(from: result ?? "", uuid: callInvite.uuid)
            self.activeCallInvite = callInvite
        }
    }
    
    public func cancelledCallInviteReceived(cancelledCallInvite: CancelledCallInvite,error:Error) {
        cancelledCallInvites = cancelledCallInvite
        sendEventHandleCall("onCancelledCallInvite", data:Mapper.cancelledCallInviteToDict(cancelledCallInvite),error:nil)
        if let ci = self.activeCallInvite {
            performEndCallAction(uuid: ci.uuid)
        }
    }
}

extension SwiftTwilioVoice: CallDelegate{
    public func callDidReconnect(call: Call) {
        if(self.callOutgoing){
            sendEventOutGoingCall("onReconnected",data:Mapper.callToDict(call), error:nil)
        }else {
            sendEventIncomingCall("onReconnected",data:Mapper.callInviteToDict(self.dumpActiveCallInvite), error:nil)
        }
    }
    
    public func callDidStartRinging(call: Call) {
        if(self.callOutgoing){
            sendEventOutGoingCall("onRinging",data:Mapper.callToDict(call), error: nil)
        }else {
            sendEventIncomingCall("onRinging",data:Mapper.callInviteToDict(self.dumpActiveCallInvite), error: nil)
        }
    }
    
    public func callDidReceiveQualityWarnings(call: Call, currentWarnings: Set<NSNumber>, previousWarnings: Set<NSNumber>) {
        if(self.callOutgoing){
            sendEventOutGoingCall("onCallQualityWarningsChanged",data:Mapper.callToDict(call), error: nil)
        }else {
            sendEventIncomingCall("onCallQualityWarningsChanged",data:Mapper.callInviteToDict(self.dumpActiveCallInvite), error: nil)
        }
    }
    
    public func callIsReconnecting(call: Call, error: Error) {
        if(self.callOutgoing){
            sendEventOutGoingCall("onReconnecting",data:Mapper.callToDict(call), error:error)
        }else {
            sendEventIncomingCall("onReconnecting",data:Mapper.callInviteToDict(self.dumpActiveCallInvite), error:error)
        }
    }
    
    public func callDidConnect(call: Call) {
        if(self.callOutgoing){
            sendEventOutGoingCall("onConnected",data:Mapper.callToDict(call), error: nil)
        }else {
            sendEventIncomingCall("onConnected",data:Mapper.callInviteToDict(self.dumpActiveCallInvite), error: nil)
        }
    }
    
    public func callDidFailToConnect(call: Call, error: Error) {
        if(self.callOutgoing){
            sendEventOutGoingCall("onConnectFailure",data:Mapper.callToDict(call), error: error)
        }else {
            sendEventIncomingCall("onConnectFailure",data:Mapper.callInviteToDict(self.dumpActiveCallInvite), error: error)
        }
    }
    
    public func callDidDisconnect(call: Call, error: Error?) {
        if(self.callOutgoing){
            sendEventOutGoingCall("onDisconnected",data:Mapper.callToDict(call), error: error)
            self.callOutgoing = false;
        }else {
            sendEventIncomingCall("onDisconnected",data:Mapper.callInviteToDict(self.dumpActiveCallInvite), error: error)
            guard let id = activeCall?.uuid else {
                return
            }
            callKitProvider.reportCall(with: id, endedAt: Date(), reason: .answeredElsewhere)
        }
    }
    
    //outgoing event-------------------------------------------------------------------------------
    
    func sendEventOutGoingCall(_ name: String, data: [String: Any]? = nil, error: Error? = nil) {
        let eventData = ["name": name, "data": data, "error": Mapper.errorToDict(error)] as [String: Any?]
        if let outgoingCallEventSink = SwiftTwilioVoice.callOutGoingSink {
            outgoingCallEventSink(eventData)
        }
    }
    
    func sendEventHandleCall(_ name: String, data: [String: Any]? = nil, error: Error? = nil) {
        let eventData = ["name": name, "data": data, "error": Mapper.errorToDict(error)] as [String: Any?]
        if let incomingCallEventSink = SwiftTwilioVoice.handleMessageSink {
            incomingCallEventSink(eventData)
        }
    }
    
    func sendEventIncomingCall(_ name: String, data: [String: Any]? = nil, error: Error? = nil) {
        let eventData = ["name": name, "data": data, "error": Mapper.errorToDict(error)] as [String: Any?]
        if let incomingCallEventSink = SwiftTwilioVoice.callIncomingSink {
            incomingCallEventSink(eventData)
        }
    }
}
