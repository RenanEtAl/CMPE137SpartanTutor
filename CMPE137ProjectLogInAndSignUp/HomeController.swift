//
//  HomeController.swift
//  CMPE137ProjectLogInAndSignUp
//
//  Created by Renanie Tanola on 3/5/19.
//  Copyright © 2019 cmpe137. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {
    class HomeController: UIViewController {
        
        // MARK: - Properties
        
        var welcomeLabel: UILabel = {
            let label = UILabel()
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 28)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.alpha = 0
            return label
        }()
        
        // MARK: - Init
        
        override func viewDidLoad() {
            super.viewDidLoad()
            authenticateUserAndConfigureView()
        }
        
        // MARK: - Selectors
        
        @objc func handleSignOut() {
            let alertController = UIAlertController(title: nil, message: "Are you sure you want to sign out?", preferredStyle: .actionSheet)
            alertController.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { (_) in
                self.signOut()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
        
        // MARK: - API
        
        func loadUserData() {
            // get current user id
            // find the user id in database
            guard let uid = Auth.auth().currentUser?.uid else { return }
            Database.database().reference().child("users").child(uid).child("username").observeSingleEvent(of: .value) { (snapshot) in
                guard let username = snapshot.value as? String else { return }
                self.welcomeLabel.text = "Welcome, \(username)"
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.welcomeLabel.alpha = 1
                })
            }
        }
        
        func signOut() {
            do {
                try Auth.auth().signOut()
                let navController = UINavigationController(rootViewController: LoginController())
                navController.navigationBar.barStyle = .black
                self.present(navController, animated: true, completion: nil)
            } catch let error {
                print("Failed to sign out with error..", error)
            }
        }
        
        // so users do not have to log in every time they access app, have to log in if they signed out
        
        func authenticateUserAndConfigureView() {
            if Auth.auth().currentUser == nil {
                DispatchQueue.main.async {
                    // show logincontroller
                    let navController = UINavigationController(rootViewController: LoginController())
                    navController.navigationBar.barStyle = .black
                    self.present(navController, animated: true, completion: nil)
                }
            } else {
                // if user is back
                configureViewComponents()
                loadUserData()
            }
        }
        
        // MARK: - Helper Functions
        
        func configureViewComponents() {
            view.backgroundColor = UIColor.mainBlue()
            
            navigationItem.title = "Spartan Tutor"
            
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "baseline_arrow_back_white_24dp"), style: .plain, target: self, action: #selector(handleSignOut))
            navigationItem.leftBarButtonItem?.tintColor = .white
            navigationController?.navigationBar.barTintColor = UIColor.mainBlue()
            
            view.addSubview(welcomeLabel)
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            welcomeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
        
    }

    /*
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    */
    
    
}
