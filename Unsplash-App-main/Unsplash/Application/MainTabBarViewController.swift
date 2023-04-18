//
//  MainTabBarController.swift
//  Unsplash
//
//  Created by Аброрбек on 05.01.2023.
//

import UIKit

final class MainTabBarViewController: UITabBarController {
    
    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
    }
    
    //MARK: - Setup
    
    private func setupTabBar(){
        let networkingService = NetworkingServiceImplementation()
        
        let homeRouter = HomeRouterImplementation(networkingService: networkingService)
        
        let vc1 = UINavigationController(rootViewController: homeRouter.homeView)
        
        let favouriteRouter = FavouriteRouterImplementation(networkingService: networkingService)
        let vc2 = UINavigationController(rootViewController: favouriteRouter.favouriteView)
        
        vc1.tabBarItem.image = UIImage(systemName: "house")
        vc2.tabBarItem.image = UIImage(systemName: "suit.heart")
        
        vc1.title = "Home"
        vc2.title = "Favourite"
        
        tabBar.tintColor = .label
        
        let blur = UIBlurEffect(style: UIBlurEffect.Style.regular) //blur tabBar style
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = self.view.bounds
        tabBar.addSubview(blurView)

        
        setViewControllers([vc1, vc2], animated: true)
    }

}
