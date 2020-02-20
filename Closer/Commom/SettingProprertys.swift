//
//  SettingProprertys.swift
//  Closer
//
//  Created by macbook-estagio on 19/09/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import UIKit

extension UIColor {
    func hexaToColor (hex:String) -> UIColor {
        var hexString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (hexString.hasPrefix("#")) {
            hexString.remove(at: hexString.startIndex)
        }
        
        if ((hexString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: hexString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    convenience init(red: Int, green: Int, blue: Int, a: CGFloat = 1.0) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: a
        )
    }
    
    convenience init(rgb: Int, a: CGFloat = 1.0) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF,
            a: a
        )
    }
}


extension UILabel {
    
    func setBasicLabel(text:String? = nil, textColor:UIColor? = .black, font:CGFloat?, backgroundColor:UIColor? = .white, textAlignment:NSTextAlignment? = .center) {
        
        if let text = text {
            let localizedText = NSLocalizedString(text, comment: "")
            self.text = localizedText
        }
        if let textColor = textColor{
            self.textColor = textColor
        }
        if let font = font{
            self.font = UIFont.systemFont(ofSize: font)
        } else {
            self.font = UIFont.systemFont(ofSize: 15)
        }
        if let backgroundColor = backgroundColor{
            self.backgroundColor = backgroundColor
        }
        if let textAlignment = textAlignment{
            self.textAlignment = textAlignment
        }
        self.sizeToFit()
    }
    
}


extension UIButton {
    
    func setBasicButton(title:String?, font:CGFloat?, backgroundColor:UIColor?, tintColor:UIColor?, cornerRadius:CGFloat? = 0) -> Void {
        if let title = title {
            let localizedTitle = NSLocalizedString(title, comment: "")
            setTitle(localizedTitle, for: .normal)
        }
        if let font = font {
            self.titleLabel?.font = UIFont.systemFont(ofSize: font)
        } else {
            self.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        }
        if let backgroundColor = backgroundColor {
            self.backgroundColor = backgroundColor
        } else {
            self.backgroundColor = .clear
        }
        if let tintColor = tintColor {
            self.tintColor = tintColor
        } else {
            self.tintColor = .white
        }
        if let cornerRadius = cornerRadius{
            layer.cornerRadius = cornerRadius
        }
    }
    
    func setButtonWithImage(named name:String, radius:CGFloat){
        layer.cornerRadius = radius
        setImage(UIImage(named: name), for: .normal)
    }
    
    
}


extension UIImageView {
    
    func setImage(name: String?,x: Int, y: Int, width: Int, height: Int) {
        if let name = name {
            self.image = UIImage(named: name)
        }
        self.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
}

extension UIImage {
    
    func imageWithInsets(insetDimen: CGFloat) -> UIImage {
        return imageWithInset(insets: UIEdgeInsets(top: insetDimen, left: insetDimen, bottom: insetDimen, right: insetDimen))
    }
    
    func imageWithInset(insets: UIEdgeInsets) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()?.withRenderingMode(self.renderingMode)
        UIGraphicsEndImageContext()
        return imageWithInsets!
    }
}


extension String {
    
    func replace(target: String, withString: String) -> String {
        return self.replacingOccurrences(of: target, with: withString, options: NSString.CompareOptions.literal, range: nil)
    }
    
    //Neste caso o self é o mesmo de quem chama o método, ou seja, quem for chamar o método se for uma string e por ser um método que extende de String então, self é a própria instancia do método ...
    mutating func replaceName() -> String {
        let arraySpecialCaracter : [String] = ["Á","É","Í","Ó","Ú","á","é","í","ó","ú","Â","Ê","Ô","â","ê","ô","À","à","Ü","ü","Ç","ç","Ñ","ñ","Ã","Õ","ã","õ"," "]
        var arrayRight : [String] =           ["A","É","I","O","U","a","e","i","o","u","A","E","O","a","e","o","A","a","U","u","C","c","N","n","A","O","a","o","%20"]
        var count:Int = 0
        arraySpecialCaracter.forEach { (char) in
            self = self.replace(target: char, withString: arrayRight[count])
            count+=1
        }
        return self
    }
    
    
    

    enum RegularExpressions: String {
        case phone = "^\\s*(?:\\+?(\\d{1,3}))?([-. (]*(\\d{3})[-. )]*)?((\\d{3})[-. ]*(\\d{2,4})(?:[-.x ]*(\\d+))?)\\s*$"
    }

    func isValid(regex: RegularExpressions) -> Bool { return isValid(regex: regex.rawValue) }
    func isValid(regex: String) -> Bool { return range(of: regex, options: .regularExpression) != nil }

    func onlyDigits() -> String {
        let filtredUnicodeScalars = unicodeScalars.filter { CharacterSet.decimalDigits.contains($0) }
        return String(String.UnicodeScalarView(filtredUnicodeScalars))
    }

    func makeACall() {
        guard isValid(regex: .phone),
            let url = URL(string: "tel://\(self.onlyDigits())"),
                UIApplication.shared.canOpenURL(url) else { return }
        if #available(iOS 10, *) {
            UIApplication.shared.open(url)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    
    
}


extension UITextField {
    
    func recuo(_ parametro: Int) {
        let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: CGFloat(integerLiteral: parametro), height: self.frame.height))
        let rightView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: CGFloat(integerLiteral: parametro), height: self.frame.height))
        self.leftView = leftView
        self.rightView = rightView
        self.leftViewMode = UITextField.ViewMode.always
    }
    
    func setTextField(_ cornerRadious:CGFloat? = 10, _ recuo:CGFloat? = 10, _ backGroundColor:UIColor? = .white, _ placeHolder:String? = "", _ textColor:UIColor? = .black, _ fontSize: CGFloat? = 15, _ tag:Int?) {
//        textField.backgroundColor = .white
//        textField.font = UIFont(name: "Helvenica", size: 0)
//        textField.font = UIFont.systemFont(ofSize: 25)
//        textField.recuo(20)
//        textField.placeholder = "Nome do lugar"
//        textField.layer.cornerRadius = CGFloat.heigthComponent/2
        if let cornerRadious = cornerRadious {
            self.layer.cornerRadius = cornerRadious
        }
        if let recuo = recuo {
            self.recuo(Int(recuo))
        }
        if let backGroundColor = backGroundColor {
            self.backgroundColor = backGroundColor
        }
        if let placeHolder = placeHolder {
            self.placeholder = placeHolder
        }
        if let textColor = textColor {
            self.textColor = textColor
        }
        if let fontSize  = fontSize {
            self.font = UIFont.systemFont(ofSize: fontSize)
        }
        if let tag = tag {
            self.tag = tag
        }
    }
    
    
    
}


extension UIViewController {
    
    func hideKeyboardTapped() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
}



extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil, bottom: NSLayoutYAxisAnchor? = nil, right: NSLayoutXAxisAnchor? = nil, topConstant: CGFloat = 0, leftConstant: CGFloat = 0, bottomConstant: CGFloat = 0, rightConstant: CGFloat = 0, widthConstant: CGFloat = 0, heightConstant: CGFloat = 0) -> [NSLayoutConstraint] {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: topConstant))
        }
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: leftConstant))
        }
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -bottomConstant))
        }
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -rightConstant))
        }
        
        if widthConstant > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: widthConstant))
        }
        if heightConstant > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: heightConstant))
        }
        
        anchors.forEach({$0.isActive = true})
        
        return anchors
    }
    
    
//    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
//
//        self.translatesAutoresizingMaskIntoConstraints = false
//
//        if let top = top {
//            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
//        }
//        if let leading = leading {
//            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
//        }
//        if let bottom = bottom {
//            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
//        }
//        if let trailing = trailing {
//            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
//        }
//
//        if size.width != 0 {
//            widthAnchor.constraint(equalToConstant: size.width).isActive = true
//        }
//        if size.height != 0 {
//            heightAnchor.constraint(equalToConstant: size.height).isActive = true
//        }
//
//    }
//
//    func anchroSize(to view: UIView) {
//        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
//    }
//
//    func fillSuperview() {
//        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
//    }
    
    
    func setShadow( alpha:CGFloat, offSetX: Float, offSetY: Float, shadowOpacity: Float, shadowRadius: CGFloat, boolean: Bool) {
        self.alpha = alpha
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.shadowOffset = CGSize(width: Int(offSetX), height: Int(offSetY))
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRadius
        self.isUserInteractionEnabled = boolean
        
    }
    
    func setShadow(view: UIView, alpha:CGFloat, offSetX: Float, offSetY: Float, shadowOpacity: Float, shadowRadius: CGFloat, boolean: Bool, color: CGColor) -> UIView {
        view.alpha = alpha
//        view.layer.shadowColor = (
//            UIColor(red: color[0]/255,
//                    green: color[1]/255,
//                    blue: color[2]/255,
//                    alpha: color[3]) as! CGColor)
//        view.layer.shadowColor = (UIColor(red: color[0], green: color[1], blue: color[2]) as! CGColor)
        view.layer.shadowColor = UIColor(cgColor: color).cgColor//(UIColor().hexaToColor(hex: color) as! CGColor)
        view.layer.shadowOffset = CGSize(width: Int(offSetX), height: Int(offSetY))
        view.layer.shadowOpacity = shadowOpacity
        view.layer.shadowRadius = shadowRadius
        view.isUserInteractionEnabled = boolean
        
        return view
    }
    
    
    func addSubviews(viewsToAdd: UIView...) {
        for view in viewsToAdd {
            self.addSubview(view)
        }
    }
    
}

extension Double {
    
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
    
}
