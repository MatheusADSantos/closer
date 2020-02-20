//
//  MainNavigationController.swift
//  Closer
//
//  Created by macbook-estagio on 03/01/20.
//  Copyright © 2020 macbook-estagio. All rights reserved.
//

import UIKit

class MainNavigationController : UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.backgroundColorGray
        self.navigationController?.isNavigationBarHidden = true
        
        if isLoggedIn() {
            //Assumindo que esteje logado
            let homeController = CloserView()
            viewControllers = [homeController]
        } else {
            perform(#selector(showLoginController), with: nil, afterDelay: 0.5)
        }
    }
    
    fileprivate func isLoggedIn() -> Bool {
        return UserDefaults.standard.isLoggedIn()
    }
    
    @objc func showLoginController() {
        let loginController = LoginController()
        pushViewController(loginController, animated: true)
//        present(loginController, animated: true) {
//            //implementar depois
//        }
    }
    
    
}
