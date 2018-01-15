import UIKit
import StoreKit
import Firebase
import UserNotifications
import FirebaseMessaging
import FirebaseInstanceID
import OneSignal

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UITabBar.appearance().tintColor = .white
        
        //onesignal
        
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "6d48dbf8-19c6-40bb-abcd-fdc6a67ab094",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        
        
        //
        
        
        
		UIApplication.shared.statusBarStyle = .lightContent
		FirebaseApp.configure()
	//	GADMobileAds.configure(withApplicationID: "ca-app-pub-1322409251712247~2275914440")
		return true
	}
	
	func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
		guard url.scheme == "coincase-market" else {
			return false
		}
		DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
			self.requestReview()
		})
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
	}

	func applicationWillTerminate(_ application: UIApplication) {
	}

	@objc func requestReview() {
		let shortestTime: UInt32 = 5
		let longestTime: UInt32 = 10
		if let _ = TimeInterval(exactly: arc4random_uniform(longestTime - shortestTime) + shortestTime) {
			SKStoreReviewController.requestReview()
		}
	}
}
