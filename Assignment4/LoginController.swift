//
//  LoginController.swift
//  Assignment4
//
//  Created by Ashwini Shekhar Phadke on 4/9/18.
//  Copyright © 2018 Ashwini Shekhar Phadke. All rights reserved.
//

import UIKit
import Firebase

/*extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
extension UIColor {
    static func random() -> UIColor {
        return UIColor(red:   .random(),
                       green: .random(),
                       blue:  .random(),
                       alpha: 0.8)
    }
}
*/

class LoginController: UIViewController , UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
   
    
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .random()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    let locationTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Location"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let locationSeparatorView: UIView = {
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
    
    
    
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        print("going to handler")
        picker.delegate = self
        picker.allowsEditing = true
        // show Image Picker!!!! (Modally)
        present(picker, animated: true, completion: nil)
    }
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named : "avatar-1577909_960_720")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        //  imageView.isUserInteractionEnabled = true
        // imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
       
        return imageView
    }()
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var locationTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .random()
        button.setTitle("SignIn", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
       // button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
       button.addTarget(self, action: #selector(handlesignin), for: .touchUpInside)
        return button
    }()
    
     @objc func handlesignin()
     {
        let signincontroller = SignInController()
        navigationController?.pushViewController(signincontroller, animated: true)
        
    }
   
    lazy var SignupButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .random()
        button.setTitle("SignUp", for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        // button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    
    @objc func handleRegister()
    {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text ,let location = locationTextField.text else {
            print("Must enter name, ")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            guard let uid = user?.uid else {
                return
            }
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("\(imageName).png")
            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!)
            {
                storageRef.putData(uploadData,metadata : nil,completion : {(metadata,error)in
                    if error != nil {
                        print(error)
                        return
                    }
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString
                    {
                        let values = ["name" : name, "email" : email,"profileImageUrl" : profileImageUrl,"location" :location]
                        self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                    }
                    
                    
                    
                })
            }
      
            let viewincontroller1 = ViewController()
            self.navigationController?.pushViewController(viewincontroller1, animated: true)
                
            })
        
    }
            
            
            
            
            
            
    
        
    
    
    
    private func registerUserIntoDatabaseWithUID(uid : String,values :[String : AnyObject])
    {
        let ref = Database.database().reference(fromURL: "https://assignment4-b137e.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
   
        usersReference.updateChildValues(values,withCompletionBlock : {(err,red) in
            if err != nil {
                print(err)
                return
            }
            self.dismiss(animated: true, completion: nil)
            
        })

    }
    
    
    fileprivate func isLoggedIn()->Bool {
        return UserDefaults.standard.bool(forKey: "isLoggedIn")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.hidesBackButton = true
          tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      self.navigationItem.hidesBackButton = true
       view.backgroundColor = UIColor.white
       
        
      //  var  backgroundimg = UIImageView(frame:CGRect(x: 0, y: 0, width: 400, height: 250))       //UIImageView(frame:CGRect(x:0,y:100,width:317,height:40))
     //   backgroundimg.image = #imageLiteral(resourceName: "img")
        
        let inputview = UIView()
        inputview.backgroundColor = .random()
        inputview.translatesAutoresizingMaskIntoConstraints = false
        
      
        
        view.addSubview(inputview)
        view.addSubview(profileImageView)
        view.addSubview(loginButton)
        view.addSubview(SignupButton)
        
        //constraints for image
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: inputview.topAnchor, constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
       profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        //constraints for login container
        inputview.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputview.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70).isActive = true
        inputview.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputview.heightAnchor.constraint(equalToConstant: 150).isActive = true
        inputview.layer.cornerRadius = 5
        inputview.layer.masksToBounds = true
        inputview.addSubview(nameTextField)
        inputview.addSubview(nameSeparatorView)
        inputview.addSubview(locationTextField)
        inputview.addSubview(locationSeparatorView)
        inputview.addSubview(emailTextField)
        inputview.addSubview(emailSeparatorView)
        
        inputview.addSubview(passwordTextField)
        
        
        
        //constraints for login button
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.topAnchor.constraint(equalTo: inputview.bottomAnchor, constant: 30).isActive = true
        loginButton.widthAnchor.constraint(equalTo: inputview.widthAnchor).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        nameTextField.leftAnchor.constraint(equalTo:  inputview.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo:  inputview.topAnchor).isActive = true
        
        nameTextField.widthAnchor.constraint(equalTo:  inputview.widthAnchor).isActive = true
       nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo:  inputview.heightAnchor, multiplier: 1/4)
     nameTextFieldHeightAnchor?.isActive = true
        
        //need x, y, width, height constraints
        nameSeparatorView.leftAnchor.constraint(equalTo:  inputview.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo:  inputview.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        locationTextField.leftAnchor.constraint(equalTo:  inputview.leftAnchor, constant: 12).isActive = true
      locationTextField.topAnchor.constraint(equalTo: nameSeparatorView.bottomAnchor).isActive = true
        
        locationTextField.widthAnchor.constraint(equalTo:  inputview.widthAnchor).isActive = true
        
     locationTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo:  inputview.heightAnchor, multiplier: 1/4)
        
       locationTextFieldHeightAnchor?.isActive = true
        
        locationSeparatorView.leftAnchor.constraint(equalTo:  inputview.leftAnchor).isActive = true
         locationSeparatorView.topAnchor.constraint(equalTo:  locationTextField.bottomAnchor).isActive = true
         locationSeparatorView.widthAnchor.constraint(equalTo: inputview.widthAnchor).isActive = true
       locationSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //need x, y, width, height constraints
        emailTextField.leftAnchor.constraint(equalTo:  inputview.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: locationSeparatorView.bottomAnchor).isActive = true
        
        emailTextField.widthAnchor.constraint(equalTo:  inputview.widthAnchor).isActive = true
        
      emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo:  inputview.heightAnchor, multiplier: 1/4)
        
       emailTextFieldHeightAnchor?.isActive = true
        
        //need x, y, width, height constraints
        emailSeparatorView.leftAnchor.constraint(equalTo:  inputview.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputview.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //need x, y, width, height constraints
        passwordTextField.leftAnchor.constraint(equalTo:  inputview.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        
        passwordTextField.widthAnchor.constraint(equalTo:  inputview.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo:  inputview.heightAnchor, multiplier: 1/4)
       passwordTextFieldHeightAnchor?.isActive = true
        //constraints for signup button
       SignupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        SignupButton.topAnchor.constraint(equalTo:  loginButton.bottomAnchor, constant: 30).isActive = true
        SignupButton.widthAnchor.constraint(equalTo:  loginButton.widthAnchor).isActive = true
        SignupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
       profileImageView.isUserInteractionEnabled = true
       tabBarController?.tabBar.isHidden = true
    }
    
   

   
  
}
