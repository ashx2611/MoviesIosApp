//
//  SignInController.swift
//  Assignment4
//
//  Created by Ashwini Shekhar Phadke on 4/10/18.
//  Copyright © 2018 Ashwini Shekhar Phadke. All rights reserved.
//

import UIKit
import Firebase
class SignInController: UIViewController {
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .random()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?   
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .random()
        button.setTitle("Go!", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
         button.addTarget(self, action: #selector(go), for: .touchUpInside)
        
        
              return button
    }()
    
    
    @objc func go()
    {
        //if signin is succesful then display the movies
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!){(user,error) in
            if error != nil {
                print(error)
            }
            else{
                print("log in successful")
               // UserDefaults.standard.set(true, forKey: "isloggedin")
               // UserDefaults.standard.synchronize()
                
                let viewincontroller = ViewController()
               // let viewincontroller = TabMenuViewController()
                self.navigationController?.pushViewController(viewincontroller, animated: true)
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        
        let  backgroundimg = UIImageView(frame:CGRect(x: 0, y: 0, width: 400, height: 250))       //UIImageView(frame:CGRect(x:0,y:100,width:317,height:40))
        backgroundimg.image = #imageLiteral(resourceName: "img")
        
        let inputview = UIView()
        inputview.backgroundColor = .random()
        inputview.translatesAutoresizingMaskIntoConstraints = false
        
        
        view.addSubview(backgroundimg)
        view.addSubview(inputview)
         view.addSubview(loginButton)
        inputview.addSubview(emailTextField)
        inputview.addSubview(emailSeparatorView)
        inputview.addSubview(passwordTextField)
        
        
        
        ///Adding constraints for container 
        inputview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputview.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70).isActive = true
        inputview.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputview.heightAnchor.constraint(equalToConstant: 100).isActive = true
        inputview.layer.cornerRadius = 5
        inputview.layer.masksToBounds = true
        
        emailTextField.leftAnchor.constraint(equalTo:  inputview.leftAnchor, constant: 12).isActive = true
       emailTextField.topAnchor.constraint(equalTo:  inputview.topAnchor).isActive = true
        
       emailTextField.widthAnchor.constraint(equalTo:  inputview.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo:  inputview.heightAnchor, multiplier: 1/2)
       emailTextFieldHeightAnchor?.isActive = true
        
        //need x, y, width, height constraints
       emailSeparatorView.leftAnchor.constraint(equalTo:  inputview.leftAnchor).isActive = true
       emailSeparatorView.topAnchor.constraint(equalTo:  emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo:  inputview.widthAnchor).isActive = true
      emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordTextField.leftAnchor.constraint(equalTo:  inputview.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        
        passwordTextField.widthAnchor.constraint(equalTo:  inputview.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo:  inputview.heightAnchor, multiplier: 1/2)
        passwordTextFieldHeightAnchor?.isActive = true
       
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: inputview.bottomAnchor, constant: 30).isActive = true
        loginButton.widthAnchor.constraint(equalTo: inputview.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        tabBarController?.tabBar.isHidden = true
    }

   

}
