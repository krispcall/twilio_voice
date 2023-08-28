import Flutter
import TwilioVoice

// swiftlint:disable file_length type_body_length
public class Mapper {
    
    public static func checkStringNil(data: Any?) -> String{
        if(data == nil){
            return ""
        }else {
            return data as! String
        }
    }
    
    public static func checkBoolNil(data: Any?) -> Bool{
        if(data == nil){
            return false
        }else {
            return data as! Bool
        }
    }
    
    public static func checkDicNil(data: Any?) -> [String: Any]{
        if(data == nil){
            return ["":""]
        }else {
            return data as! [String: Any]
        }
    }
    
    public static func callToDict(_ message: Call?) -> [String: Any] {
        let emptyData =  ["data" :[
            "callSid": "",
            "isOnHold" :false,
            "to" :"",
            "from" :"",
            "isMuted" :false] as [String : Any]]
        if(message != nil){
            return [
                "data" :[
                    "callSid": checkStringNil(data: message?.sid),
                    "from" :checkStringNil(data: message?.from),
                    "to" : checkStringNil(data: message?.to),
                    "isOnHold" : checkBoolNil(data: message?.isOnHold),
                    "isMuted" :checkBoolNil(data: message?.isMuted)] as [String : Any]
            ]
        }
        return emptyData
    }
    
    public static func callInviteToDict(_ call: CallInvite?) -> [String: Any] {
        let emptyData =  ["data" :[
            "twi_call_sid" :"",
            "twi_to" :"",
            "twi_from" :"",
            "customParameters" :["":""]] as [String : Any]]
        if(call != nil){
            return [
                "data" :[
                    "twi_call_sid" : checkStringNil(data: call?.callSid),
                    "twi_from" :checkStringNil(data: call?.from),
                    "twi_to" : checkStringNil(data: call?.to),
                    "customParameters" : checkDicNil(data: call?.customParameters)
                ] as [String : Any]
            ]
        }
        return emptyData;
    }
    
    public static func cancelledCallInviteToDict(_ call: CancelledCallInvite?) -> [String: Any] {
        let emptyData =  ["data" :[
            "twi_call_sid" :"",
            "twi_to" :"",
            "twi_from" :"",
            "customParameters" :["":""],
        ] as [String : Any]]
        if(call != nil){
            return [
                "data" :[
                    "twi_call_sid" : checkStringNil(data: call?.callSid),
                    "twi_from" :checkStringNil(data: call?.from),
                    "twi_to" : checkStringNil(data: call?.to),
                    "customParameters" : checkDicNil(data: call?.customParameters)
                ] as [String : Any]
            ]
        }
        return emptyData;
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
