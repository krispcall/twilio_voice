import Flutter
import UIKit
import TwilioVoice
import CallKit
import PushKit
import UserNotifications
import Foundation


var  TAG = "TwilioVoiceIOS";


private var activeCall: Call?

private var activeCallInvite: CallInvite?
private var cancelledCallInvites: CancelledCallInvite?


public class SwiftTwilioVoice: NSObject, FlutterPlugin, PKPushRegistryDelegate{
    
    var _result: FlutterResult?
    public static var loggingSink: FlutterEventSink?
    public static  var nativeDebug = false
    public static var messenger: FlutterBinaryMessenger?
    public static var reasonForTokenRetrieval: String?
    public static  var instance: SwiftTwilioVoice?
    
    
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
        
        self.voipRegistry = PKPushRegistry.init(queue: DispatchQueue.main)
        super.init()
        
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = Set([PKPushType.voIP])
        
        let appDelegate = UIApplication.shared.delegate
        
        guard let controller = appDelegate?.window??.rootViewController as? FlutterViewController else {
            fatalError("rootViewController is not type FlutterViewController")
        }
        
//        let registrar = controller.registrar(forPlugin: "TwilioVoice")
    }
    
    
    //Registry
    public static func register(with registrar: FlutterPluginRegistrar) {
        instance = SwiftTwilioVoice()
        instance?.onRegister(registrar)
    }
        
 

    public func pushRegistry(_ registry: PKPushRegistry, didUpdate
                                pushCredentials: PKPushCredentials, for type: PKPushType) {
        
        NSLog("pushRegistry:didUpdatePushCredentials:forType:")
        
        if type == PKPushType.voIP {
            print("Inside pushRegistry")
            self.deviceToken = pushCredentials.token as Data;

            print("deviceToken")
            print(deviceToken! as Data);
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
        print(arguments)
        
        
        guard let token = self.deviceToken as NSData? else {
            print("Missing 'accessToken' parameter")
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
                                print ("Successfully Registered accessToken $accessToken fcmToken $fcmToken")
                                
                                self.sendNotificationEvent("registerForNotification", data: ["result": true], error: error)
                               return result( ["result" : true])
                                
                            }
                            else {
                                print("Successfully registered accessToken $accessToken fcmToken $fcmToken")
                                
                                self.sendNotificationEvent("registerForNotification", data: ["result": true], error: error)
                                
                               return result (["result": true])
                            }
                        }
                        
                    }
                }
            }
        
        }
        
    }
    
    
    public func makeCall(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    
        print("Inside makeCall")
        _result = result
        
        let arguments:Dictionary<String, AnyObject> = call.arguments as! Dictionary<String, AnyObject>;
        
        print("Arguments for makCall")
        print(arguments)

        guard let callTo = arguments["To"] as? String else {return  result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'callTo' parameter", details: nil))}
        
        guard let callFrom = arguments["from"] as? String else { return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'from' parameter", details: nil))}


        guard let accessToken = arguments["accessToken"] as?String else { return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'accessToken' parameter", details: nil))}


        guard  let  displayName = arguments["displayName"] as?String else{ return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'displayName' parameter", details: nil))}
        
        
        let connectOptions = ConnectOptions(accessToken: accessToken) { builder in
            builder.params = ["to": callTo,
                              "from":callFrom,
                              "accessToken":accessToken,
                              "displayName":displayName ]
        }
        
        let call = TwilioVoiceSDK.connect(options: connectOptions,
                                          delegate: OutGoingCallDelegate())
        
        print(call.from as Any)
        
        activeCall = call
                
    }
    
    
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
                        TwilioVoiceSDK.handleNotification(arguments, delegate:HandleNotificationDelegate(), delegateQueue:nil)
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
        activeCall?.disconnect()
    }
    
    public func mute(){
        print("Inside Mute")
        
        if (activeCall != nil)
        {
            if((activeCall?.isMuted) != nil){
                
                //TODO: unable to find the mute method
                
                //activeCall.mute()
                activeCall?.isMuted = true;
//                NSLog(TAG, "mute: $mute")
                
            }
        }
        
    }
    
    
    public func acceptCall(){
        
        print("Inside AcceptCall")
        
        if(activeCall != nil){
            print("activeCallInvite?.accept(with: IncomingCallDelegate()) iniated")
            activeCallInvite?.accept(with: IncomingCallDelegate())
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
    

class OutGoingCallDelegate:NSObject,CallDelegate{
        
        func callDidReconnect(call: Call) {
            NSLog(TAG, "\("onReconnected") \(String(describing: call.from))")
            NSLog(TAG, "\("onReconnected") \(String(describing: call.to))")
            NSLog(TAG, "\("onReconnected") \(call.callQualityWarnings)")
            NSLog(TAG, "\("onReconnected") \(call.isOnHold)")
            NSLog(TAG, "\("onReconnected") \(call.isMuted)")
            self.sendEventOutGoingCall("onReconnected", data:Mapper.callToDict(call),error:nil)
        }
        
        
        public func callInviteReceived(callInvite: CallInvite) {
            
            
        }
        
        public func callDidStartRinging(call: Call) {
            
            NSLog(TAG, "\("onRinging") \(String(describing: call.from))")
            NSLog(TAG, "\("onRinging") \(String(describing: call.to))")
            NSLog(TAG, "\("onRinging") \(call.callQualityWarnings)")
            NSLog(TAG, "\("onRinging") \( call.isOnHold)")
            NSLog(TAG,"\("onRinging") \(call.isMuted)")
            
            self.sendEventOutGoingCall("onRinging", data:Mapper.callToDict(call) , error: nil)
            
            
        }
        
        public func callDidReceiveQualityWarnings(call: Call, currentWarnings: Set<NSNumber>, previousWarnings: Set<NSNumber>) {
            
            NSLog(TAG, "\("onCallQualityWarningsChanged") \(String(describing: call.from))")
            NSLog(TAG, "\("onCallQualityWarningsChanged") \(String(describing: call.to))")
            NSLog(TAG, "\("onCallQualityWarningsChanged") \(call.callQualityWarnings)")
            NSLog(TAG, "\("onCallQualityWarningsChanged") \( call.isOnHold)")
            NSLog(TAG ,"\("onCallQualityWarningsChanged") \(call.isMuted)")
            //            NSLog(TAG, "\("onCallQualityWarningsChanged") \(currentWarnings)")
            
            //        if (previousWarnings.count > 1)
            //           {
            //               let  intersection: MutableSet<Call.CallQualityWarning> = HashSet(currentWarnings)
            //               currentWarnings!.removeAll()
            //               intersection!.retainAll(previousWarnings)
            //               previousWarnings!.removeAll(intersection)
            //           }
            self.sendEventOutGoingCall("onCallQualityWarningsChanged",
                                       data: Mapper.callToDict(call),error: nil)
            
            
        }
        
        
        public func callIsReconnecting(call: Call, error: Error) {
            
            NSLog(TAG, "\("onReconnecting")\(String(describing: call.from))")
            NSLog(TAG, "\("onReconnecting")\(String(describing: call.to))")
            NSLog(TAG, "\("onReconnecting") \(call.callQualityWarnings)")
            NSLog(TAG, "\("onReconnecting") \(call.isOnHold)")
            NSLog(TAG, "\("onReconnecting") \(call.isMuted)")
            NSLog(TAG, "\("onReconnecting") \(error.localizedDescription)")
            
            self.sendEventOutGoingCall("onReconnecting", data:  Mapper.callToDict(call),error:error)
            
        }
        
        
        public func cancelledCallInviteReceived(cancelledCallInvite :   CancelledCallInvite,error:Error) {
            
            
        }
        
        
        public func callDidConnect(call: Call) {
            NSLog(TAG, "\("onConnected") \(String(describing: call.from))")
            NSLog(TAG, "\("onConnected") \(String(describing: call.to))")
            NSLog(TAG, "\("onConnected") \(call.callQualityWarnings)")
            NSLog(TAG, "\("onConnected") \(call.isOnHold)")
            NSLog(TAG, "\("onConnected") \(call.isMuted)")
            activeCall = call
            self.sendEventOutGoingCall("onConnected", data: Mapper.callToDict(call),error: nil)
        }
        
        
        
        public func callDidFailToConnect(call: Call, error: Error) {
            
            NSLog(TAG, "\("onConnectFailure") \(error)")
            sendEventOutGoingCall("onConnectFailure",data : Mapper.callToDict(call),error: error)
        }
        
        
        public func callDidDisconnect(call: Call, error: Error?) {
            NSLog(TAG, "\("onDisconnected")\(String(describing: call.from))")
            NSLog(TAG, "\("onDisconnected")\(String(describing: call.to))")
            NSLog(TAG, "\("onDisconnected") \(call.callQualityWarnings)")
            NSLog(TAG, "\("onDisconnected") \(call.isOnHold)")
            NSLog(TAG, "\("onDisconnected") \(call.isMuted)")
            NSLog(TAG, "\("onDisconnected") \(String(describing: error))")
            self.sendEventOutGoingCall("onDisconnected", data:Mapper.callToDict(call),error: error)
        }
        
        
        //outgoing event-------------------------------------------------------------------------------
        
        func sendEventOutGoingCall(_ name: String, data: [String: Any]? = nil, error: Error? = nil) {
            let eventData = ["name": name, "data": data, "error": Mapper.errorToDict(error)] as [String: Any?]
            
            if let outgoingCallEventSink = SwiftTwilioVoice.callOutGoingSink {
                outgoingCallEventSink(eventData)
            }
            
            
        }
        
        
    }
    
    
    
    class IncomingCallDelegate:NSObject,CallDelegate{
        
        func callDidReconnect(call: Call) {
            NSLog(TAG, "\("onReconnected") \(String(describing: call.from))")
            NSLog(TAG, "\("onReconnected") \(String(describing: call.to))")
            NSLog(TAG, "\("onReconnected") \(call.callQualityWarnings)")
            NSLog(TAG, "\("onReconnected") \(call.isOnHold)")
            NSLog(TAG, "\("onReconnected") \(call.isMuted)")
            self.sendEventIncomingCall("onReconnected", data:Mapper.callToDict(call),error:nil)
        }
        
        // Call
        public func callInviteReceived(callInvite: CallInvite) {
            
            
        }
        
        public func callDidStartRinging(call: Call) {
            
            NSLog(TAG, "\("onRinging") \(String(describing: call.from))")
            NSLog(TAG, "\("onRinging") \(String(describing: call.to))")
            NSLog(TAG, "\("onRinging") \(call.callQualityWarnings)")
            NSLog(TAG, "\("onRinging") \( call.isOnHold)")
            NSLog(TAG,"\("onRinging") \(call.isMuted)")
            self.sendEventIncomingCall("onRinging", data:Mapper.callToDict(call) , error: nil)
            
        }
        
        
        public func callDidReceiveQualityWarnings(call: Call, currentWarnings: Set<NSNumber>, previousWarnings: Set<NSNumber>) {
            
            NSLog(TAG, "\("onCallQualityWarningsChanged") \(String(describing: call.from))")
            NSLog(TAG, "\("onCallQualityWarningsChanged") \(String(describing: call.to))")
            NSLog(TAG, "\("onCallQualityWarningsChanged") \(call.callQualityWarnings)")
            NSLog(TAG, "\("onCallQualityWarningsChanged") \( call.isOnHold)")
            NSLog(TAG ,"\("onCallQualityWarningsChanged") \(call.isMuted)")
            
            
            //        if (previousWarnings.count > 1)
            //           {
            //               let  intersection: MutableSet<Call.CallQualityWarning> = HashSet(currentWarnings)
            //               currentWarnings!.removeAll()
            //               intersection!.retainAll(previousWarnings)
            //               previousWarnings!.removeAll(intersection)
            //           }
            self.sendEventIncomingCall("onCallQualityWarningsChanged",
                                       data: Mapper.callToDict(call),error: nil)
            
            
        }
        
        
        public func callIsReconnecting(call: Call, error: Error) {
            
            NSLog(TAG, "\("onReconnecting") \(String(describing: call.from))")
            NSLog(TAG, "\("onReconnecting") \(String(describing: call.to))")
            NSLog(TAG, "\("onReconnecting") \(call.callQualityWarnings)")
            NSLog(TAG, "\("onReconnecting") \(call.isOnHold)")
            NSLog(TAG, "\("onReconnecting") \(call.isMuted)")
            NSLog(TAG, "\("onReconnecting") \(error.localizedDescription)")
            
            self.sendEventIncomingCall("onReconnecting", data:  Mapper.callToDict(call),error:error)
            
        }
        
        
        public func cancelledCallInviteReceived(cancelledCallInvite :   CancelledCallInvite,error:Error) {
            
            
        }
        
        
        public func callDidConnect(call: Call) {
            NSLog(TAG, "\("onConnected")\(String(describing: call.from))")
            NSLog(TAG, "\("onConnected") \(String(describing: call.to))")
            NSLog(TAG, "\("onConnected") \(call.callQualityWarnings)")
            NSLog(TAG, "\("onConnected") \(call.isOnHold)")
            NSLog(TAG, "\("onConnected") \(call.isMuted)")
            
            activeCall = call
            self.sendEventIncomingCall("onConnected", data: Mapper.callToDict(call),error: nil)
        }
        
        
        
        public func callDidFailToConnect(call: Call, error: Error) {
            
            NSLog(TAG, "\("onConnectFailure") \(error.localizedDescription)")
            sendEventIncomingCall("onConnectFailure",data : Mapper.callToDict(call),error: error)
        }
        
        
        public func callDidDisconnect(call: Call, error: Error?) {
            NSLog(TAG, "\("onDisconnected") \(String(describing: call.from))")
            NSLog(TAG, "\("onDisconnected") \(String(describing: call.to))")
            NSLog(TAG, "\("onDisconnected") \(call.callQualityWarnings)")
            NSLog(TAG, "\("onDisconnected") \(call.isOnHold)")
            NSLog(TAG, "\("onDisconnected") \(call.isMuted)")
            NSLog(TAG, "\("onDisconnected") \(String(describing: error?.localizedDescription))")
            
            self.sendEventIncomingCall("onDisconnected", data:Mapper.callToDict(call),error: error)
        }
        
        
        //outgoingevent-------------------------------------------------------------------------------
        
        func sendEventIncomingCall(_ name: String, data: [String: Any]? = nil, error: Error? = nil) {
            let eventData = ["name": name, "data": data, "error": Mapper.errorToDict(error)] as [String: Any?]
            
            if let outgoingCallEventSink = SwiftTwilioVoice.callOutGoingSink {
                outgoingCallEventSink(eventData)
            }
            
            
        }
    }
    
    class  HandleNotificationDelegate : NSObject,NotificationDelegate {
        
        func callInviteReceived(callInvite: CallInvite) {
            
            activeCallInvite = callInvite
            self.sendEventHandleMessage("onCallInvite",data:Mapper.callInviteToDict(callInvite),error:nil)
        }
        
        func cancelledCallInviteReceived(cancelledCallInvite: CancelledCallInvite, error: Error) {
            cancelledCallInvites = cancelledCallInvite
            self.sendEventHandleMessage("onCancelledCallInvite", data:Mapper.cancelledCallInviteToDict(cancelledCallInvite),error:error)
        }
        
        func sendEventHandleMessage(_ name: String, data: [String: Any]? = nil, error: Error? = nil) {
            let eventData = ["name": name, "data": data, "error": Mapper.errorToDict(error)] as [String: Any?]
            
            if let handleMessageSink = SwiftTwilioVoice.handleMessageSink {
                handleMessageSink(eventData)
            }
        }
        
    }
    
    
}



extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
