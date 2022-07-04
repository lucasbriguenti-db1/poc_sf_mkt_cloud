import Flutter
import UIKit 
import MarketingCloudSDK
import SFMCSDK

public class SwiftSfmcFlutterPlugin: NSObject, FlutterPlugin, MarketingCloudSDKURLHandlingDelegate, MarketingCloudSDKEventDelegate {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "sfmc_flutter", binaryMessenger: registrar.messenger())
        let instance = SwiftSfmcFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        
        if call.method == "setupSFMC" {
            guard let args = call.arguments as? [String : Any] else {return}
            
            let appId = args["appId"] as? String
            let accessToken = args["accessToken"] as? String
            let mid = args["mid"] as? String
            let sfmcURL = args["sfmcURL"] as? String
            let locationEnabled = args["locationEnabled"] as? Bool
            let inboxEnabled = args["inboxEnabled"] as? Bool
            let analyticsEnabled = args["analyticsEnabled"] as? Bool
            let delayRegistration = args["delayRegistration"] as? Bool
            
            if appId == nil || accessToken == nil || mid == nil || sfmcURL == nil {
                result(false)
                return
            }
            
            setupSFMC(appId: appId!, accessToken: accessToken!, mid: mid!, sfmcURL: sfmcURL!, locationEnabled: locationEnabled, inboxEnabled: inboxEnabled, analyticsEnabled: analyticsEnabled, delayRegistration: delayRegistration)
            result(true)
        } else if call.method == "setDeviceToken" {
            guard let args = call.arguments as? [String : Any] else {return}
            let deviceKey = args["deviceId"] as! String?
            if deviceKey == nil {
                result(false)
                return
            }
            result(setDeviceKey(deviceKey: deviceKey!))
        } else if call.method == "getDeviceToken" {
            result(getDeviceToken())
        } else if call.method == "getDeviceIdentifier" {
            result(getDeviceIdentifier())
        } else if call.method == "setContactKey" {
            guard let args = call.arguments as? [String : Any] else {return}
            let cKey = args["cId"] as! String?
            if cKey == nil {
                result(false)
                return
            }
            
            result(setContactKey(contactKey: cKey!))
        } else if call.method == "setTag" {
            
            guard let args = call.arguments as? [String : Any] else {return}
            let tag = args["tag"] as! String?
            if tag == nil {
                result(false)
                return
            }
            
            result(setTag(tag: tag!))
        } else if call.method == "removeTag" {
            guard let args = call.arguments as? [String : Any] else {return}
            let tag = args["tag"] as! String?
            if tag == nil {
                result(false)
                return
            }
            result(removeTag(tag:tag!))
        } else if call.method == "setAttribute" {
            guard let args = call.arguments as? [String : Any] else {return}
            let attrName = args["name"] as! String?
            let attrValue = args["value"] as! String?
            if attrName == nil || attrValue == nil {
                result(false)
                return
            }
            result(setAttribute(attr: attrName!, value: attrValue!));
        } else if call.method == "clearAttribute" {
            guard let args = call.arguments as? [String : Any] else {return}
            let attrName = args["name"] as! String?
            
            if attrName == nil
            {
                result(false)
                return
            }
            result(clearAttribute(name: attrName!));
            
        }else if call.method == "pushEnabled" {
            result(pushEnabled());
        }else if call.method == "enablePush" {
            result(setPushEnabled(status: true));
        } else if call.method == "disablePush" {
            result(setPushEnabled(status: false));
        } else if call.method == "sdkState" {
            result(getSDKState())
        } else if call.method == "enableVerbose" {
            result(setupVerbose(status: true))
        } else if call.method == "disableVerbose" {
            result(setupVerbose(status: false))
        } else if call.method == "enableWatchingLocation" {
            result(enableLocationWatching())
        } else if call.method == "disableWatchingLocation" {
            result(disableLocationWatching())
        } else {
            result(FlutterError(code: "METHOD_NOT_AVAILABLE",
                                message: "METHOD_NOT_ALLOWED",
                                details: nil))
        }
    }
    
    public func setupSFMC(appId: String, accessToken: String, mid: String, sfmcURL: String, locationEnabled: Bool?, inboxEnabled: Bool?, analyticsEnabled: Bool?, delayRegistration: Bool?) -> Bool {
        #if DEBUG
        SFMCSdk.setLogger(logLevel: .debug)
        #endif

        let mobilePushConfiguration = PushConfigBuilder(appId: appId)
            .setAccessToken(accessToken)
            .setMarketingCloudServerUrl(URL(string: sfmcURL)!)
            .setMid(mid)
            .setInboxEnabled(inboxEnabled ?? false)
            .setLocationEnabled(locationEnabled ?? false)
            .setAnalyticsEnabled(analyticsEnabled ?? false)
            .setDelayRegistrationUntilContactKeyIsSet(delayRegistration ?? false)
            .build()

        let completionHandler: (OperationResult) -> () = { result in
            if result == .success {

            }
        }           
        SFMCSdk.initializeSdk(ConfigBuilder().setPush(config: mobilePushConfiguration, onCompletion: completionHandler).build())
        return true       
    }

   
    public func setDeviceKey(deviceKey: String) -> Bool {
        let data = deviceKey.data(using: .utf8)
        if (data == nil) {
            return true
        }
        return true
    }
    public func getDeviceToken() -> String? {
        return SFMCSdk.mp.deviceToken();
        
    }
    public func getDeviceIdentifier() -> String? {
        return SFMCSdk.mp.deviceIdentifier();
    }
    
    
   
    public func setContactKey(contactKey: String) -> Bool {
        SFMCSdk.identity.setProfileId(contactKey)
        return true
    }
    
    public func setAttribute(attr: String, value: String) -> Bool {
        SFMCSdk.identity.setProfileAttributes([attr : value])
        //SFMCSdk.identity.setProfileAttributes([["FavoriteTeamName": "favoriteTeamName"]])
        return true
    }

    public func clearAttribute(name: String) -> Bool {
        SFMCSdk.identity.setProfileAttributes([name : ""])
        return true
    }
    public func attributes() -> [String: String] { 
        return SFMCSdk.mp.attributes() as! [String : String]
    }

    public func setTag(tag: String) -> Bool {
        SFMCSdk.mp.addTag(tag)
        return true
    }
    public func removeTag(tag: String) -> Bool {
        SFMCSdk.mp.removeTag(tag)
        return true
    }

    public func tags() -> [String] {
        return SFMCSdk.mp.tags() as! [String]
    }

    public func setupVerbose(status: Bool) -> Bool {
        return true
    }
    
   
    public func pushEnabled() -> Bool {
        return SFMCSdk.mp.pushEnabled()
    }
    public func setPushEnabled(status: Bool) -> Bool {
        SFMCSdk.mp.setPushEnabled(status)
        return true
    }
    
   
    public func getSDKState() -> String {
        return SFMCSdk.state()
    }
    
    public func enableLocationWatching() -> Bool {        
        return true;
    }

    public func disableLocationWatching() -> Bool {        
        return true;
    }

    public func sfmc_handle(_ url: URL, type: String) {
        if UIApplication.shared.canOpenURL(url) == true {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: { success in
                    if success {
                        print("url \(url) opened successfully")
                    } else {
                        print("url \(url) could not be opened")
                    }
                })
            } else {
                if UIApplication.shared.openURL(url) == true {
                    print("url \(url) opened successfully")
                } else {
                    print("url \(url) could not be opened")
                }
            }
        }
    }

    public func sfmc_didShow(inAppMessage message: [AnyHashable : Any]) {
        
    }

    public func sfmc_didClose(inAppMessage message: [AnyHashable : Any]) {
        
    }
    
}
