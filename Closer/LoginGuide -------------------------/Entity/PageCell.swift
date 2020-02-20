//
//  PageCell.swift
//  Closer
//
//  Created by macbook-estagio on 27/12/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell {
    
    var page : Page? {
        didSet {
            guard let page = page else {return}
            imageView.image = UIImage(named: page.imageName)
            
//            let atributedText = NSAttributedString(string: page.title)
            
            let font = UIFont.systemFont(ofSize: 24)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            paragraphStyle.firstLineHeadIndent = 0.0

            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.blue,
                .paragraphStyle: paragraphStyle
            ]
            
            let font2 = UIFont.systemFont(ofSize: 14)
            let paragraphStyle2 = NSMutableParagraphStyle()
            paragraphStyle2.alignment = .justified
            let attributes2: [NSAttributedString.Key: Any] = [
                .font: font2,
                .foregroundColor: UIColor.black,
                .paragraphStyle: paragraphStyle2
            ]
            
            let attributedTexts = NSMutableAttributedString(string: "\(page.title)", attributes: attributes)
            let attributedTexts2 = NSMutableAttributedString(string: "\n\n\n      \(page.message)", attributes: attributes2)
            
            attributedTexts.append(attributedTexts2)
            
            textView.attributedText = attributedTexts
            
            
            if page.title == "Menu" {
//                buttonToEnter.alpha = 1
//                UIApplication.shared.keyWindow?.rootViewController?.present(CloserView(), animated: true, completion: nil)
            }
            
            
//            let atributedText = NSMutableAttributedString(string: page.title, attributes: [NSAttributedString.Key.font : UIFont.systemFontSize(18)])
            
            
//            let atributedText = NSMutableAttributedString(string: page.title)
//            atributedText.append(NSAttributedString(string: page.message))
            
//            textView.text = page.title + "\n\n" + page.message
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Componentes
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
//        iv.backgroundColor = .yellow
        iv.image = UIImage(named: "pag1")
        iv.clipsToBounds = true
//        iv.layer.cornerRadius = 10
//        iv.layer.borderWidth = 10
//        iv.layer.borderColor = UIColor.black.cgColor
        return iv
    }()
    let view : UIView = {
        let v = UIView()
        v.backgroundColor = .white
        return v
    }()
    let textView : UITextView = {
        let tv = UITextView()
        tv.text = "Exemplo"
        tv.isEditable = false
        tv.textAlignment = .justified
        return tv
    }()
    
    func setupViews() {
        addSubviews(viewsToAdd: imageView, view/*, buttonToEnte*/)
        view.addSubview(textView)
        
        imageView.snp.makeConstraints { (make) in
//            make.top.left.right.equalToSuperview()
//            make.height.equalTo(UIScreen.main.bounds.height*0.7)
            
            make.top.equalToSuperview().offset(CGFloat.margin*6)
//            make.bottom.equalTo(view.snp.bottom).offset(CGFloat.margin)
            make.left.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height*0.7)
        }
        view.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        textView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(CGFloat.margin*2)
            make.right.equalToSuperview().offset(-CGFloat.margin*2)
//            make.height.equalTo(UIScreen.main.bounds.height*0.7)
        }
    }
    
}
