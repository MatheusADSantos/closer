//
//  LoginCell.swift
//  Closer
//
//  Created by macbook-estagio on 02/01/20.
//  Copyright © 2020 macbook-estagio. All rights reserved.
//

import Foundation
import UIKit

class LoginCell : UICollectionViewCell {
    
    var email: String? = ""
    var password: String? = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        loadViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let logoimagemView : UIImageView = {
        let image = UIImage(named: "man-user")
        let imageView = UIImageView(image: image)
        return imageView
    }()
    let emailTextField : UITextField = {
        let textField = UITextField()
        textField.setTextField(5, 5, .white, "Enter Email", .black, 20, 0)
        textField.layer.borderColor = UIColor.backgroundColorGray.cgColor
        textField.layer.borderWidth = 1
        textField.keyboardType = .emailAddress
        textField.keyboardAppearance = .alert
        return textField
    }()
    let passwordTextField : UITextField = {
        let textField = UITextField()
        textField.setTextField(5, 5, .white, "Enter Password", .black, 20, 1)
        textField.layer.borderColor = UIColor.backgroundColorGray.cgColor
        textField.layer.borderWidth = 1
        textField.isSecureTextEntry = true
        textField.keyboardType = .emailAddress
        textField.keyboardAppearance = .dark
        return textField
    }()
    lazy var loginButton : UIButton = {
        let button = UIButton()
        button.setTitle("Log in", for: .normal)
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    weak var delegate: LoginControllerDelegate?
    @objc func handleLogin() {
        guard let email = email else { return }
        guard let senha = password else { return }
        print("Email: ",email,"Senha: ", senha)
        delegate?.finishLoggingIn(email: email, senha: senha)
    }
    
    
    func loadViews() {
        addSubviews(viewsToAdd: logoimagemView, emailTextField, passwordTextField, loginButton)
        _ = logoimagemView.anchor(top: centerYAnchor, left: nil, bottom: nil, right: nil, topConstant: -200, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 160, heightConstant: 160)
        logoimagemView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        _ = emailTextField.anchor(top: logoimagemView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 50)
        _ = passwordTextField.anchor(top: emailTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 50)
        _ = loginButton.anchor(top: passwordTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 32, leftConstant: 32, bottomConstant: 0, rightConstant: 32, widthConstant: 0, heightConstant: 50)
    }
    
    
}

class LeftPaddedTextField : UITextField, UITextFieldDelegate {
    //Dando um espaço do inicio do texto
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x+10, y: bounds.origin.y, width: bounds.width+10, height: bounds.height)
    }
    //Dando um espaço do inicio do texto editado
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        CGRect(x: bounds.origin.x+10, y: bounds.origin.y, width: bounds.width+10, height: bounds.height)
    }
    
}

extension LoginCell : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dealWithLoginText(textField: textField)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        dealWithLoginText(textField: textField)
    }
    //MARK: - Tratando LOGIN
    func dealWithLoginText(textField: UITextField) {
        switch textField.tag {
        case 0:
            email = textField.text
        case 1:
            password = textField.text
        default:
            return
        }
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        delegate?.finishLoggingIn(email: email!, senha: password!)
    }
    
    
    
    
}

