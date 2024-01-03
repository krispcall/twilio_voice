import Flutter
import Foundation

public class PluginHandler {
   
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        SwiftTwilioVoice.debug("PluginHandler.handle => received \(call.method)")
        switch call.method {
        case "debug":
            debug(call, result: result)
            
        case "create":
            create(call, result: result)
            
        case "trackLog":
            SwiftTwilioVoice.instance?.trackLog(call, result: result)
            
        case "registerForNotification":
            SwiftTwilioVoice.instance?.registerForNotification(call, result: result)
            
        case "unregisterForNotification":
            SwiftTwilioVoice.instance?.unregisterForNotification(call, result: result)
            
        case "makeCall":
            SwiftTwilioVoice.instance?.makeCall(call,result:result)
            
        case "makeCallWithSid":
            SwiftTwilioVoice.instance?.makeCallWithSid(call,result:result)
            
        case "rejectCall" :
            SwiftTwilioVoice.instance?.rejectCall()
            
        case "disConnect":
            SwiftTwilioVoice.instance?.disConnect()
            
        case "mute":
            SwiftTwilioVoice.instance?.mute()
            
        case "hold":
            SwiftTwilioVoice.instance?.hold()
            
        case "acceptCall":
            SwiftTwilioVoice.instance?.acceptCall()
            
        case "sendDigit":
            SwiftTwilioVoice.instance?.sendDigit(call, result:result)
            
        case "handleMessage":
            SwiftTwilioVoice.instance?.handleMessage(call,result:result)
            
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    private func debug(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any?] else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }
        
        guard let enableNative = arguments["native"] as? Bool else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'native' parameter", details: nil))
        }
        
        guard let enableSdk = arguments["sdk"] as? Bool else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'sdk' parameter", details: nil))
        }
        
                SwiftTwilioVoice.nativeDebug = enableNative
                if enableSdk {
//                    SwiftTwilioVoice?.setLogLevel(TCHLogLevel?.debug)
                }
        
        result(enableNative)
    }
    
    private func create(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        SwiftTwilioVoice.debug("SwiftVoicePluggin.create => called")
        
        guard let arguments = call.arguments as? [String: Any?] else {
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing parameters", details: nil))
        }
        
        let token = arguments["token"]
        
        if( token != nil){
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'token' parameter", details: nil))
        }
        
        let propertiesObj = arguments["properties"]
        
        if(propertiesObj != nil){
            return result(FlutterError(code: "MISSING_PARAMS", message: "Missing 'token' parameter", details: nil))
        }
        
    }
}
