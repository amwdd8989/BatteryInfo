import Foundation
import UIKit

class MainUITabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            // Fallback on earlier versions
            view.backgroundColor = .white
        }
        
        // 首页的ViewController
        let homeViewController = HomeViewController()
        if #available(iOS 13.0, *) {
            homeViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Home", comment: ""), image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        } else {
            // Fallback on earlier versions
        }
        
        // 历史记录的ViewController
        let historyRecordViewController = HistoryRecordViewController()
        if #available(iOS 13.0, *) {
            historyRecordViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("History", comment: ""), image: UIImage(systemName: "list.dash"), selectedImage: UIImage(systemName: "list.bullet"))
        } else {
            // Fallback on earlier versions
        }
        
        
        // 设置页面的ViewController
        let settingsViewController = SettingsViewController()
        if #available(iOS 13.0, *) {
            settingsViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Settings", comment: ""), image: UIImage(systemName: "gear"), selectedImage: UIImage(systemName: "gear.fill"))
        } else {
            // Fallback on earlier versions
        }
        
        if SettingsUtils.instance.getShowHistoryRecordViewInHomeView() {
            self.viewControllers = [UINavigationController(rootViewController: homeViewController),
                                    UINavigationController(rootViewController: historyRecordViewController),
                                    UINavigationController(rootViewController: settingsViewController)]
        } else {
            self.viewControllers = [UINavigationController(rootViewController: homeViewController),
                                    UINavigationController(rootViewController: settingsViewController)]
        }
        
          
    }
}
