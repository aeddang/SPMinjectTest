//
//  SPMInjectTestApp.swift
//  SPMInjectTest
//
//  Created by JeongCheol Kim on 2022/06/25.
//

import SwiftUI
import MyTV
@main
struct SPMInjectTestApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(MyTvLauncherObservable())
        }
    }
}


class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var orientationLock = UIInterfaceOrientationMask.portrait

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
//        setUNUserNotificationDelegate()
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions){ _ , error in
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                
            }
        }
        
        Mytv.shared.userInfo = MytvAdotUserInfoProvider()
        Mytv.shared.logable = MytvAdotLoggable()
        Mytv.shared.config = MytvAdotConfigProvider()
        Mytv.shared.initBackgroundDownLoadTask()
       
        return true
    }
    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("didReceiveRemoteNotification")
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("didReceiveRemoteNotification fetchCompletionHandler")
        completionHandler(UIBackgroundFetchResult.newData)
    }
    // [END receive_message]
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNs token retrieved: \(deviceToken.base64EncodedString())")
    }
    // [START receive_message]
}

class MytvAdotConfigProvider: MytvConfigProvidable {
    var serverType: MyTvServerType {
        return .stage
    }
    var logLevel: MyTvAppLogLv {
        return .all
    }
}

class MytvAdotLoggable: MytvLoggable {
    func sendMytvLog(data: [String: Any]) {
        print("[MytvLogSender] sendScreenLog:\(data)")
    }

    func sendScreenLog(pageCode: String, additionalDimension: [[String: Any]]?) {
        print("[MytvLogSender] sendScreenLog:\(pageCode), \(additionalDimension ?? [])")
    }

    func sendClickLog(pageCode: String, clickCode: String, clickActionCode: String, additionalDimension: [[String: Any]]?) {
        print("[MytvLogSender] sendClickLog:\(pageCode),\(clickCode), \(additionalDimension ?? [])")
    }
}


class MytvAdotUserInfoProvider: MytvUserInfoProvidable {
    var birth:String = "1980-08-24"
    var userAdultCertification:Bool = false
    
    var userId: String {
        return "APL00000BO9AEFUJQ0HS"
    }

    var accessToken: String {
        return "eyJraWQiOiJlbmMiLCJhbGciOiJIUzI1NiJ9.eyJleHQiOnsidXNyIjoiQVBMMDAwMDBCTzlBRUZVSlEwSFMiLCJkdmMiOiJBUEwwMDAwMEJPOUFFRldSTVJLMCIsInRrbiI6IkUwNjlFNzRFNDg1MzQwOTlCREM3OTE0MTYzRDFGNDJGIiwicG9jIjoiYXBwLmFwb2xsby5hZ2VudCIsInNybCI6IkExODAzNTAzMUFEMjQ0OEU5RUNEMTBEQUUxQTZDREExMjAyMjA0MDExMTM0NTciLCJzdmMiOiJhcG9sbG8ifSwic3ViIjoiQVBMMDAwMDBCTzlBRUZVSlEwSFMiLCJhdWQiOiJhcHAuYXBvbGxvLmFnZW50IiwibmJmIjoxNjU4NDAwNjgyLCJ1c2VyX25hbWUiOiJBUEwwMDAwMEJPOUFFRlVKUTBIUyIsImlzcyI6Imh0dHBzOlwvXC9zdGctYWNjb3VudC5za3RhcG9sbG8uY29tIiwiZXhwIjoxNjYwMDQyMjgyLCJpYXQiOjE2NTg0MDA2ODIsImp0aSI6ImUwNjllNzRlLTQ4NTMtNDA5OS1iZGM3LTkxNDE2M2QxZjQyZiIsImNsaWVudF9pZCI6ImFwcC5hcG9sbG8uYWdlbnQifQ.FMGzsk6gUqBN2fUs_AcMWqnn3KIp-CCPeSczq8INoTA"
         
    }

    var gender: String {
        return "femail"
    }

    var birthdate: String {
        return birth
    }
    var isCiVerified: Bool {
        return self.userAdultCertification
    }

    var userData: String {
        return ""
    }

    var characterImages: [String: String] {
        return [
            "greeting": "https://stg-cdn.sktapollo.com/apollo/character/preset/greeting6_512x512.png",
            "bust": "https://stg-cdn.sktapollo.com/apollo/character/preset/bust6_256x256.png",
            "full": "https://stg-cdn.sktapollo.com/apollo/character/preset/full6_256x256.png"
        ]
    }
}


extension AppDelegate : UNUserNotificationCenterDelegate {

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            
            completionHandler([.list,.sound,.banner])
            
        }
}
