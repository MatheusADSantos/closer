//
//  CollectionViewCategoryInCadastroCategoria.swift
//  Closer
//
//  Created by macbook-estagio on 14/10/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//


import UIKit
import SnapKit

final class CollectionViewCategorysInCadastroCategoria: UICollectionViewCell {
    
//    var isSelected: Bool = false
    
//    let imageView : UIImageView = {
//        let image = UIImageView()
//        image.backgroundColor = .white
//        image.setaShadow(view: image, alpha: 1, offSetX: -5, offSetY: 5, shadowOpacity: 0.5, shadowRadius: 5, bolean: true)
//        image.layer.cornerRadius = CGFloat.heigthComponent/2
////        image.image?.capInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//        image.contentMode = .scaleAspectFill
//        return image
//    }()
    let imageView : UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .white
//        image.layer.borderWidth = 3
//        image.layer.borderColor = UIColor.white.cgColor
        
//        image.setShadow(view: image/*(image as? UIView)!*/, alpha: 0.5, offSetX: -15, offSetY: 15, shadowOpacity: 0.5, shadowRadius: 20, boolean: true)
        
        image.layer.cornerRadius = (CGFloat.heigthComponent)/2
//        image.contentMode = .scaleAspectFill
//        image.contentMode = .scaleToFill
//        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
//        let insets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//        image.alignmentRectInsets(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        
        
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.height.width.equalTo(CGFloat.heigthComponent)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

