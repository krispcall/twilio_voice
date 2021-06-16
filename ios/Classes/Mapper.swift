import Flutter
import TwilioVoice

// swiftlint:disable file_length type_body_length
public class Mapper {
    
    
    public static func callToDict(_ message: Call?) -> [String: Any] {
        return [
            "data" :[
                "from" :message!.from!,
                "to" :message!.to!,
                "isOnHold" :message!.isOnHold,
                "isMuted" :message!.isMuted]
        ]
    }
    
    
    public static func callInviteToDict(_ call: CallInvite?) -> [String: Any] {
        return [
            "data" :[
                "callSid" :call!.callSid as String,
                "to" :call!.to as String,
                "from" :call!.from! as String,
                "customParameters" : call!.customParameters! as Dictionary<String,String>
         ]
        ]
    }
    
    
    public static func cancelledCallInviteToDict(_ call: CancelledCallInvite?) -> [String: Any] {
        return [
            "data" :[
                "callSid" :call!.callSid as String,
                "to" :call!.to as String,
                "from" :call!.from! as String,
                "customParameters" : call!.customParameters! as Dictionary<String,String>
         ]
        ]
    }
    
    
    public static func errorToDict(_ error: Error?) -> [String: Any?]? {
        if let error = error as NSError? {
            return [
                "code": error.code,
                "message": error.description
            ]
        }
        return nil
    }

}
