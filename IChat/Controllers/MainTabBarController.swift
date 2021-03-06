//
//  MainTabBarController.swift
//  IChat
//
//  Created by Artyom Beldeiko on 19.05.22.
//

import UIKit


class MainTabBarController: UITabBarController {
    
    private let currentUser: MUSer
    
    init(currentUser: MUSer = MUSer(username: " ",
                                    email: " ",
                                    avatarStringURL: " ",
                                    description: " ",
                                    sex: " ",
                                    id: " ")) {
        
        self.currentUser = currentUser
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listViewController = ListViewController(currentUser: currentUser)
        let peopleViewController = PeopleViewController(currentUser: currentUser)
        
        tabBar.tintColor = UIColor(red: 142 / 255, green: 90 / 255, blue: 247 / 255, alpha: 1)
        
        let boldImageConfig = UIImage.SymbolConfiguration(weight: .medium)
        
        let conversationImage = UIImage(systemName: "bubble.left.and.bubble.right", withConfiguration: boldImageConfig)!
        let peopleImage = UIImage(systemName: "person.2", withConfiguration: boldImageConfig)!
        
        viewControllers = [
            generateViewController(rootViewController: peopleViewController, title: "People", image: peopleImage),
            generateViewController(rootViewController: listViewController, title: "Coversations", image: conversationImage)
            
        ]
        
    }
    
    private func generateViewController(rootViewController: UIViewController, title: String, image: UIImage) -> UIViewController {
        
        let navigationVC = UINavigationController(rootViewController: rootViewController)
        navigationVC.tabBarItem.title = title
        navigationVC.tabBarItem.image = image
        
        return navigationVC
        
    }
    
    
}
