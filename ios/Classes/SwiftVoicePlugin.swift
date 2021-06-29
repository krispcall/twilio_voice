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



public class SwiftTwilioVoice: NSObject, FlutterPlugin, AVAudioPlayerDelegate{


    private var activeCall: Call?
    var callKitProvider: CXProvider
    var audioDevice: DefaultAudioDevice = DefaultAudioDevice()

    private var activeCallInvite: CallInvite?
    private var cancelledCallInvites: CancelledCallInvite?
    var callKitCompletionCallback: ((Bool)->Swift.Void?)? = nil
    var incomingPushCompletionCallback: (()->Swift.Void?)? = nil

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
        
//        let registrar = controller.registrar(forPlugin: "TwilioVoice")
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
                print("this is error",error.localizedDescription)
//                self.sendPhoneCallEvents(description: "LOG|Failed to report incoming call successfully: \(error.localizedDescription).", isError: false)
            } else {
//                self.sendPhoneCallEvents(description: "LOG|Incoming call successfully reported.", isError: false)
            }
        }
    }
    
    func performAnswerVoiceCall(uuid: UUID, completionHandler: @escaping (Bool) -> Swift.Void) {
        if let ci = self.activeCallInvite {
            let acceptOptions: AcceptOptions = AcceptOptions(callInvite: ci) { (builder) in
                builder.uuid = ci.uuid
            }
            let theCall = ci.accept(options: acceptOptions, delegate: self)
            self.activeCall = theCall
            self.activeCallInvite = nil
            
            guard #available(iOS 13, *) else {
                self.incomingPushHandled()
                return
            }
        } else {
            sendEventIncomingCall("onConnectFailure",data:Mapper.callToDict(activeCall), error: nil)
        }
    }
    
    func performEndCallAction(uuid: UUID) {
        let endCallAction = CXEndCallAction(call: uuid)
        let transaction = CXTransaction(action: endCallAction)
        
        callKitCallController.request(transaction) { error in
            if let error = error {
                print("this is error",error.localizedDescription)
            } else {
                print("this is performEndCallAction")
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
        
        print("Inside onRegister")
        
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
        print("Inside Registration")
        let arguments:Dictionary<String, AnyObject> = call.arguments as! Dictionary<String,   AnyObject>;
        
        print("Argments for Registation")
        print("Arguments",arguments)
        
        
        guard let token = self.deviceToken as NSData? else {
            print("Missing 'deviceToken' parameter")
            return result (["result": true])
        }
        
        guard let accessToken = arguments["accessToken"] as? String else {
            
            print("Missing 'accessToken' parameter")
        
            return result (["result": true])
        
        }
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted: Bool, _: Error?) in
                SwiftTwilioVoice.debug("User responded to permissions request: \(granted)")
                if granted {
                    DispatchQueue.main.async {
                        SwiftTwilioVoice.debug("Requesting APNS token")
                        SwiftTwilioVoice.reasonForTokenRetrieval = "register"
                        UIApplication.shared.registerForRemoteNotifications()
            
                        
                        TwilioVoiceSDK.register(accessToken: accessToken,
                                                deviceToken: token as Data) { (error) in
                            if let error = error {
                                print("error")
                                print ("Successfully Registered accessToken $accessToken fcmToken $fcmToken")
                                
                                self.sendNotificationEvent("registerForNotification", data: ["result": true], error: error)
                               return result( ["result" : true])
                                
                            }
                            else {
                                print("Successfully registered accessToken $accessToken fcmToken $fcmToken")
                                print("this is access token", accessToken)
                                print("this is device token", token)
                                
                                self.sendNotificationEvent("registerForNotification", data: ["result": true], error: error)
                                
                               return result (["result": true])
                            }
                        }
                        
                    }
                }
            }

        }
        
    }
    
    public func makeCallWithSid(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
        print("Inside makeCall")
        _result = result
        
        let arguments:Dictionary<String, AnyObject> = call.arguments as! Dictionary<String, AnyObject>;
        callOutgoing = true;
        print("Arguments for makCall1")
//        print(arguments)

        guard let callTo = arguments["To"] as? String else {
            print("this is call to ",arguments["To"] as? String ?? "no data")
            return  result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'callTo' parameter", details: nil))}
        print("Arguments for makCall2")

        guard let callFrom = arguments["from"] as? String else { return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'from' parameter", details: nil))}

        print("Arguments for makCall3")

        guard let workspaceSid = arguments["workspaceSid"] as?String else { return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'workspaceSid' parameter", details: nil))}
        print("Arguments for makCall4")


        guard  let  channelSid = arguments["channelSid"] as?String else{ return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'channelSid' parameter", details: nil))}
        
        print("Arguments for makCall5")
        
        guard  let  agentId = arguments["agentId"] as?String else{ return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'channelSid' parameter", details: nil))}
        
        print("Arguments for makCall6")

        
        let connectOptions = ConnectOptions(accessToken: accessToken) { builder in
            builder.params = ["To": callTo,
                              "From":callFrom,
                              "workspace_sid":workspaceSid,
                              "channel_sid":channelSid,
                              "agent_id": agentId ]
        }
        
        print("this is formated data" ,connectOptions);
        activeCall  = TwilioVoiceSDK.connect(options: connectOptions,delegate: self)
        print("call ",call)
    }
    
    
//    public func makeCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
//
//        print("Inside makeCall")
//        _result = result
//
//        let arguments:Dictionary<String, AnyObject> = call.arguments as! Dictionary<String, AnyObject>;
//        callOutgoing = true;
//        print("Arguments for makCall1")
////        print(arguments)
//
//        guard let callTo = arguments["To"] as? String else {
//            print("this is call to ",arguments["To"] as? String ?? "no data")
//            return  result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'callTo' parameter", details: nil))}
//        print("Arguments for makCall2")
//
//        guard let callFrom = arguments["from"] as? String else { return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'from' parameter", details: nil))}
//
//        print("Arguments for makCall3")
//
//        guard let accessToken = arguments["accessToken"] as?String else { return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'accessToken' parameter", details: nil))}
//        print("Arguments for makCall4")
//
//
//        guard  let  displayName = arguments["displayName"] as?String else{ return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'displayName' parameter", details: nil))}
//
//        print("Arguments for makCall5")
//
//
//        let connectOptions = ConnectOptions(accessToken: accessToken) { builder in
//            builder.params = ["To": callTo,
//                              "from":callFrom,
//                              "accessToken":accessToken,
//                              "displayName":displayName ]
//        }
//
//        print("this is formated data" ,connectOptions);
//        activeCall  = TwilioVoiceSDK.connect(options: connectOptions,delegate: self)
//        print("call ",call)
//    }
    
    
    public  func sendDigit(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        print("Inside SendDigit")
        
        let arguments:Dictionary<String, AnyObject> = call.arguments as! Dictionary<String,   AnyObject>;
        
        print("Arguments for sendDigit")
        print(arguments)
        
        guard let digit = arguments["digit"] as? String
        else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'digit' parameter", details: nil))
        }
        
        activeCall?.sendDigits(digit)
        
        }
    
    
    
    public func handleMessage(_ message: FlutterMethodCall, result: @escaping FlutterResult) {
        print("Indise Handle Message")
        let arguments:Dictionary<String, AnyObject> = message.arguments as! Dictionary<String,   AnyObject>;
        print("arguments for handleMessage")
        print(arguments)
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted: Bool, _: Error?) in
                SwiftTwilioVoice.debug("User responded to permissions request: \(granted)")
                if granted {
                    DispatchQueue.main.async {
                        SwiftTwilioVoice.debug("Requesting APNS token")
                        SwiftTwilioVoice.reasonForTokenRetrieval = "register"
                        UIApplication.shared.registerForRemoteNotifications()
                        print("TwilioVoiceSDK initialize")
                        TwilioVoiceSDK.handleNotification(arguments, delegate:self, delegateQueue:nil)
                    }
                }
            }
        }
    }
    
    func showMissedCallNotification(from:String?, to:String?){
        guard UserDefaults.standard.optionalBool(forKey: "show-notifications") ?? true else{return}
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
                        print(jsonString)
                        content.userInfo["body"] = jsonString
                        userName = self.clients[from]
                        print("this is notification username",userName ?? "null")
                    }
                }
                
            }
            let title = userName ?? self.clients["defaultCaller"] ?? self.defaultCaller
            print("this is notification username",title )
            content.title = String(format:  NSLocalizedString("Missed Call", comment: ""),title)
            print("this is notification username",content.title )
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            print("this is notification trigger",trigger)
            let request = UNNotificationRequest(identifier: UUID().uuidString,
                                                content: content,
                                                trigger: trigger)
            print("this is notification request",request)
                notificationCenter.add(request) { (error) in
                    if let error = error {
                        print("Notification Error: ", error)
                    }
                }
            
          }
        }
    }
    
    
    
    
    
    public func rejectCall(){
        print("Inside rejectCall")
        
        if(activeCallInvite != nil)
        {
            print("activeCallInvite?.reject() called")
            
            activeCallInvite?.reject()
        }
        else
        {
            NSLog(TAG, "handleMessage kt: activeCallInvite is null. Pass handleMessage before invoking")
        }
    }
    
    public func disConnect(){
        print("Inside Disconnect")
        callOutgoing = false;
        activeCall?.disconnect()
        guard let id = activeCall?.uuid else {
            return
        }
        let direction = (self.callOutgoing ? "Outgoing" : "Incoming")

        if(direction == "Incoming"){
            callKitProvider.reportCall(with: id, endedAt: Date(), reason: .answeredElsewhere)
        }

    }
    
    public func hold(){
        print("this is hold 2")
        if(activeCall != nil){
            let hold = !(activeCall?.isOnHold ?? false) as Bool
            activeCall?.isOnHold = hold
            print("hold:",hold)
        }
    }
    
    public func mute(){
        print("Inside Mute")
        
        if (activeCall != nil)
        {
            print("this is activeCall");
            if((activeCall?.isMuted == false)){
                //TODO: unable to find the mute method
                print("call is mute");
                //activeCall.mute()
                activeCall?.isMuted = true;
            }else {
                print("this is activeCall");
                print("call is unmute");
                activeCall?.isMuted = false;
            }
        }
        
    }
    
    
    public func acceptCall(){
        print("Inside AcceptCall")
        if(activeCall != nil){
            print("activeCallInvite?.accept(with: IncomingCallDelegate()) iniated")
            activeCallInvite?.accept(with: self)
        }
    }
    
    
    
    
    
    
    public func unregisterForNotification(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        print("Inside unRegisterForNotification")
        let arguments:Dictionary<String, AnyObject> = call.arguments as! Dictionary<String,   AnyObject>;
        print("Arguments for registration");
        print(arguments)
        guard let token = deviceToken as NSData? else { return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'deviceToken' parameter", details: nil))}
        guard let accessToken = arguments["accessToken"] as? String else{ return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'accessToken' parameter", details: nil))}
        if #available(iOS 10.0, *) {
            DispatchQueue.main.async {
                SwiftTwilioVoice.debug("Requesting APNS token")
                SwiftTwilioVoice.reasonForTokenRetrieval = "deregister"
                UIApplication.shared.registerForRemoteNotifications()
                TwilioVoiceSDK.unregister(accessToken: accessToken, deviceToken: token as Data) { (error) in
                    if let error = error {
                        print ("Successfully Un-Registered accessToken $accessToken fcmToken $fcmToken")
                        self.sendNotificationEvent("unregisterForNotification",data:["result": true],error: error as NSError)
                       return result( ["result" : true])
                    }
                    else {
                        print("Successfully Unregistered accessToken $accessToken fcmToken $fcmToken")
                        self.sendNotificationEvent("unregisterForNotification",data:["result": true],error: nil)
                        
                       return result (["result": true])
                    }
                }
                
            }
        }
    
    }
    
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Inside get device Token")
        self.deviceToken = deviceToken
    }
    
    
    public func application(_ application:UIApplication,didFailToRegisterForRemoteNotificationsWithError
                                error: Error) {
        print("Inside application")
        SwiftTwilioVoice.debug("didFailToRegisterForRemoteNotificationsWithError => onFail")
        sendNotificationEvent("registered", data: ["result": false], error: error)
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
        if type == PKPushType.voIP {
            print("Inside pushRegistry")
            self.deviceToken = pushCredentials.token as Data;

            print("deviceToken")
            print(deviceToken! as Data);
        }
    }
    
    public func pushRegistry(_ registry: PKPushRegistry, didReceiveIncomingPushWith payload: PKPushPayload, for type: PKPushType, completion: @escaping () -> Void) {
        print("this is payload",payload);
        // Save for later when the notification is properly handled.
//        self.incomingPushCompletionCallback = completion
        if (type == PKPushType.voIP) {
            print("this is incoming call");
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
            print("version greater than 13")
            completion()
        }
    }
    
    public func pushRegistry(_ registry: PKPushRegistry, didInvalidatePushTokenFor type: PKPushType) {
        print("Failed to get notificatin Push Registary")
    }
}

extension SwiftTwilioVoice: CXProviderDelegate{
    // MARK: CXProviderDelegate
    public func providerDidReset(_ provider: CXProvider) {
        print("This is CXProviderDelegate DidReset")
        audioDevice.isEnabled = false
    }
    
    public func providerDidBegin(_ provider: CXProvider) {
        print("This is CXProviderDelegate DidBegin")
    }
    
    public func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        print("This is CXProviderDelegate isEnabled true")
        audioDevice.isEnabled = true
    }
    
    public func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        print("This is CXProviderDelegate isEnabled false")
        audioDevice.isEnabled = false
    }
    
    public func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        print("This is CXProviderDelegate timedOutPerformingAction")
    }
    
    public func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        provider.reportOutgoingCall(with: action.callUUID, startedConnectingAt: Date())
        action.fulfill()
    }
    
    public func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        self.performAnswerVoiceCall(uuid: action.callUUID) { (success) in
            if success {
                print("Answer Call Success")
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
            callOutgoing = true;
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
        print("This is incoming event callDidDisconnect",callInvite.callSid)
        activeCallInvite = callInvite
        sendEventHandleCall("onCallInvite",data:Mapper.callInviteToDict(callInvite),error:nil)
        reportIncomingCall(from: callInvite.from! as String, uuid: callInvite.uuid)
        self.activeCallInvite = callInvite
    }
    

    
    
    public func cancelledCallInviteReceived(cancelledCallInvite: CancelledCallInvite,error:Error) {
        print("this is cancelledCallInviteReceived",error)
        cancelledCallInvites = cancelledCallInvite
        sendEventHandleCall("onCancelledCallInvite", data:Mapper.cancelledCallInviteToDict(cancelledCallInvite),error:nil)
        self.showMissedCallNotification(from: cancelledCallInvite.from, to: cancelledCallInvite.to)
        if let ci = self.activeCallInvite {
            performEndCallAction(uuid: ci.uuid)
        }
    }
}


extension SwiftTwilioVoice: CallDelegate{
    public func callDidReconnect(call: Call) {
        print("This is outgoing event onReconnected")
        sendEventOutGoingCall("onReconnected",data:Mapper.callToDict(call), error:nil)
    }
         
    public func callDidStartRinging(call: Call) {
        print("This is outgoing event callDidStartRinging")
        sendEventOutGoingCall("onRinging",data:Mapper.callToDict(call),  error: nil)
    }
    
    public func callDidReceiveQualityWarnings(call: Call, currentWarnings: Set<NSNumber>, previousWarnings: Set<NSNumber>) {
        print("This is outgoing event callDidReceivedQualityWarning")
        sendEventOutGoingCall("onCallQualityWarningsChanged",data:Mapper.callToDict(call),error: nil)
    }
    
    public func callIsReconnecting(call: Call, error: Error) {
        print("This is outgoing event callIsIsReconnecting")
        sendEventOutGoingCall("onReconnecting",data:Mapper.callToDict(call), error:error)
    }
    
    
    public func callDidConnect(call: Call) {
        let direction = (self.callOutgoing ? "Outgoing" : "Incoming")
        if(direction == "Outgoing"){
            print("This is outgoing event callDidConnect")
            sendEventOutGoingCall("onConnected",data:Mapper.callToDict(call), error: nil)
        }else {
            sendEventIncomingCall("onConnected",data:Mapper.callToDict(call), error: nil)
        }
    }
    
    public func callDidFailToConnect(call: Call, error: Error) {
        print("This is outgoing event callDidFailToConnect")
        sendEventOutGoingCall("onConnectFailure",data:Mapper.callToDict(call), error: error)
    }
    
    public func callDidDisconnect(call: Call, error: Error?) {
        print("This is outgoing event callDidDisconnect")
        let direction = (self.callOutgoing ? "Outgoing" : "Incoming")
        if(direction == "Outgoing"){
            print("This is outgoing event callDidConnect")
            sendEventOutGoingCall("onDisconnected",data:Mapper.callToDict(call), error: error)
        }else {
            sendEventIncomingCall("onDisconnected",data:Mapper.callToDict(call), error: error)
            guard let id = activeCall?.uuid else {
                return
            }
            let direction = (self.callOutgoing ? "Outgoing" : "Incoming")

            if(direction == "Incoming"){
                callKitProvider.reportCall(with: id, endedAt: Date(), reason: .answeredElsewhere)
            }
        }
    }
    
    //outgoing event-------------------------------------------------------------------------------
    
    func sendEventOutGoingCall(_ name: String, data: [String: Any]? = nil, error: Error? = nil) {
        let eventData = ["name": name, "data": data, "error": Mapper.errorToDict(error)] as [String: Any?]
        print("This is outgoing event",name)
        if let outgoingCallEventSink = SwiftTwilioVoice.callOutGoingSink {
            outgoingCallEventSink(eventData)
        }
    }
    
    
    func sendEventHandleCall(_ name: String, data: [String: Any]? = nil, error: Error? = nil) {
        let eventData = ["name": name, "data": data, "error": Mapper.errorToDict(error)] as [String: Any?]
        print("This is handle event",name)
        if let incomingCallEventSink = SwiftTwilioVoice.handleMessageSink {
            incomingCallEventSink(eventData)
        }
    }
    
    func sendEventIncomingCall(_ name: String, data: [String: Any]? = nil, error: Error? = nil) {
        let eventData = ["name": name, "data": data, "error": Mapper.errorToDict(error)] as [String: Any?]
        print("This is incoming event",name)
        if let incomingCallEventSink = SwiftTwilioVoice.callIncomingSink {
            incomingCallEventSink(eventData)
        }
    }
}

extension UserDefaults {
    public func optionalBool(forKey defaultName: String) -> Bool? {
        if let value = value(forKey: defaultName) {
            return value as? Bool
        }
        return nil
    }
}

