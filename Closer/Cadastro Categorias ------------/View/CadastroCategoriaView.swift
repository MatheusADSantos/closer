//
//  CadastroCategoriaView.swift
//  Closer
//
//  Created by macbook-estagio on 14/10/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

struct CATEGORIA {
    var descricao: String
    var image: Data
    
    func criaCategoria() -> CATEGORIA {
        let categoria = CATEGORIA(descricao: descricao, image: image)
        print("CRIOU CATEGORIA", categoria)
        return categoria
    }
}

class CadastroCategoriaView : UIViewController, CadastroCategoriaViewProtocol {
    
    //MARK: - ATRIBUTOS
    var presenter : CadastroCategoriaPresenterProtocol?
    fileprivate let cellId = "cellIdCadastroCategoria"
    var descricao: String?
    var imagem: UIImage?
    
    let arrayCategorys : [String] = ["books","burger","bus","camara","carinho","fast-food","film-roll","film","hamburger","landscape","music-player","oftalmology","open-book","portfolio","shopping-cart","teeth","tickets","water"]
    lazy var categorysImages : [UIImage] = {
        var categorys = [UIImage]()
        for cat in self.arrayCategorys {
            categorys.append(UIImage(named: cat)!)
        }
        return categorys
    }()
    
    //MARK: - CONSTANTES
    struct Constants {
        static let screen = UIScreen.main.bounds
        static let screenHeight = screen.height
        static let screenWidth = screen.width
        static let sizeImagePhoto = (screenHeight*1/3)*3/4
    }
    
    
    
    //MARK: - VIEWDIDLOAD E LOADVIEW
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.title = "Cadastro Categoria"
        hideKeyboardTapped()
        
        presenter?.viewDidLoad()
        view.backgroundColor = UIColor.backgroundColorGray5
    }
    override func loadView() {
        super.loadView()
        print("Tamanhdo da tela: \(UIScreen.main.bounds.width)")
        
        collectionViewCategory.delegate = self
        collectionViewCategory.dataSource = self
        textFieldDescricao.delegate = self
        
        collectionViewCategory.register(CollectionViewCategorysInCadastroCategoria.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    //MARK: - COMPONENTES
//    let imageViewCategory : UIImageView = {
//        let image = UIImageView()
//        image.image = UIImage(named: "?")
//        image.layer.cornerRadius = Constants.sizeImagePhoto/2
//        image.layer.masksToBounds = true
//        image.backgroundColor = .white
//        return image
//    }()
    let imageViewCategory : UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.borderColor = UIColor.green.cgColor
        image.layer.borderWidth = 4.0
        image.layer.cornerRadius = Constants.sizeImagePhoto/2
        image.layer.masksToBounds = true
        let imageInset: CGFloat = 33
//        image.image = UIImage(named: "?")?.resizableImage(withCapInsets: UIEdgeInsets(top: imageInset, left: imageInset, bottom: imageInset, right: imageInset), resizingMode: .stretch) //?.withAlignmentRectInsets(UIEdgeInsets(top: -40, left: -10, bottom: -10, right: -10))
//        image.image = UIImage(named: "?")?.resizableImage(withCapInsets: UIEdgeInsets(top: imageInset, left: imageInset, bottom: imageInset, right: imageInset))
        image.image = UIImage(named: "?")?.imageWithInsets(insetDimen: 40)
        image.backgroundColor = .white
        return image
        }()
    let textFieldDescricao : UITextField = {
        let text = UITextField()
        let raio = CGFloat.heigthComponent/2
        text.setTextField(raio, raio, .white, "Descrição da categoria", UIColor().hexaToColor(hex: "000000"), 20, 0)
        return text
    }()
    lazy var collectionViewCategory : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
//        layout.estimatedItemSize = CGSize(width: CGFloat.heigthComponent, height: CGFloat.heigthComponent)
        layout.itemSize = CGSize(width: CGFloat.heigthComponent, height: CGFloat.heigthComponent)
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        layout.minimumLineSpacing = 25
        layout.minimumInteritemSpacing = 25
        
//        let collectionViewInsets = UIEdgeInsets(top: 50.0, left: 0.0, bottom: 30.0, right: 0.0);
//        self.collectionView.contentInset = collectionViewInsets;
//        self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(collectionViewInsets.top, 0, collectionViewInsets.bottom, 0);
        
        let collection = UICollectionView(frame: CGRect(x: 10, y: 10, width: 100, height: 100), collectionViewLayout: layout)
        collection.layer.cornerRadius = CGFloat.heigthComponent/2
        collection.setCollectionViewLayout(layout, animated: true)
        collection.backgroundColor = .white
//        collection.isPagingEnabled = true
        
        return collection
    }()
    let buttonRegister : UIButton = {
        let button = UIButton()
        let raio = CGFloat.heigthComponent/2
        let setEdgeInsets = (UIScreen.main.bounds.width/2-((CGFloat.margin)+17))
        button.setImage(UIImage(named: "save"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: setEdgeInsets, bottom: 8, right: setEdgeInsets)
        button.backgroundColor = .white
        button.layer.cornerRadius = raio
        button.addTarget(self, action: #selector(registeringCategoryInBank), for: .touchUpInside)
        return button
    }()
    
    //MARK: - BUTTON TO BACK CADASTRO
    let buttonToPopView : UIButton = {
        let button = UIButton()
        button.backgroundColor = .backgroundColorGray
        button.layer.cornerRadius = .heigthComponent/2
        button.setImage(UIImage.init(named: "backToLeft"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.setShadow(alpha: 1, offSetX: -1, offSetY: 1, shadowOpacity: 0.95, shadowRadius: 2 , boolean: true)
        button.addTarget(self, action: #selector(popToHomeViewController), for: .touchUpInside)
        return button
    }()
    @objc func popToHomeViewController() {
        print("Chamando o presenter para transição de tela para tela de Cadastro(Pins)")
        presenter?.wireframe?.backToCadastroView(view: self)
    }
    
    //MARK: - CADASTRANDO NO BANCO ...
    //Vou Cadastrar a categoria e sua descricao no banco e ao mesmo tempo vou voltar para tela de cadatro de pin
    @objc func registeringCategoryInBank() {
        textFieldDescricao.endEditing(true)
        
        guard let descricao = descricao else {return}
        guard let imagem = imagem else {return}
        let categoria = CATEGORIA(descricao: descricao, image: imagem.PNGData!)
        presenter?.registerCategory(categoria: categoria.criaCategoria(), viewRef: self)
    }
    
//    func criaObjetoCategoria(descricao: String, imagem: UIImage) -> CATEGORIA{
//        let categoria = CATEGORIA(descricao: descricao, image: imagem.pngData()!)
//        print("CRIOU CATEGORIA", categoria)
//        return categoria
//    }
    
    
    func loadViews() {
        view.addSubviews(viewsToAdd: imageViewCategory, textFieldDescricao, buttonRegister, collectionViewCategory)
        
        imageViewCategory.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(Constants.sizeImagePhoto)
        }
//        buttonToPopView.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(CGFloat.margin)
//            make.top.equalTo(imageViewCategory.snp.top)
//            make.height.width.equalTo(CGFloat.heigthComponent)
//        }
        textFieldDescricao.snp.makeConstraints { (make) in
            make.top.equalTo(imageViewCategory.snp.bottom).offset(CGFloat.margin)
            make.height.equalTo(CGFloat.heigthComponent)
            make.left.equalToSuperview().offset(CGFloat.margin)
            make.right.equalToSuperview().offset(-CGFloat.margin)
        }
        buttonRegister.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(CGFloat.margin)
            make.right.equalToSuperview().offset(-CGFloat.margin)
            make.bottom.equalToSuperview().offset(-CGFloat.margin*2)
            make.height.equalTo(CGFloat.heigthComponent)
        }
        collectionViewCategory.snp.makeConstraints { (make) in
            make.top.equalTo(textFieldDescricao.snp.bottom).offset(CGFloat.margin)
            make.left.equalToSuperview().offset(CGFloat.margin)
            make.right.equalToSuperview().offset(-CGFloat.margin)
            make.bottom.equalTo(buttonRegister.snp.top).offset(-CGFloat.margin)
        }
        
    }

}

// DELEGATE UITEXTFIELD
extension CadastroCategoriaView : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let data = textField.text else {return}
        print("Acabou de Digitar!!! ---> \(data)")
        //mandando à var descricao para salvar no banco
        descricao = data
    }
}

//MARK: - DELEGATE COLLETION
extension CadastroCategoriaView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Implementar de acordo com um Set(["":"","":""])
        return self.arrayCategorys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CollectionViewCategorysInCadastroCategoria
        let image = categorysImages[indexPath.item]
        cell.imageView.image = image.imageWithInsets(insetDimen: 35)
//        cell.imageView.layer.masksToBounds = true
//        cell.backgroundColor = .red
        cell.layer.cornerRadius = CGFloat.heigthComponent/2
//        cell.imageView.image?.resizableImage(withCapInsets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
//        cell.safeAreaInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    
        cell.setShadow(alpha: 1, offSetX: -1, offSetY: 1, shadowOpacity: 0.95, shadowRadius: 2 , boolean: true)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CollectionViewCategorysInCadastroCategoria
        print("\nCliclou na célula -> \(indexPath.item)")
        
        //Instanciando a imagem de acordo com a que selecionou (E) mandando-a imagem para ser salva no banco...
        imagem = categorysImages[indexPath.item]
        
        print("Imagem Instanciada: \(imagem!)")
        imageViewCategory.image = imagem?.imageWithInsets(insetDimen: 80)
//        imageViewCategory.reloadInputViews()
        
        cell.setShadow(alpha: 1, offSetX: -1.2, offSetY: 1.2, shadowOpacity: 1, shadowRadius: 4 , boolean: true)
        cell.backgroundColor = .lightGray
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell!.setShadow(alpha: 1, offSetX: -1.8, offSetY: 1.8, shadowOpacity: 1, shadowRadius: 2 , boolean: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        print("mama", indexPath.item)
        return true
    }
    
    
}

extension UIImage {
    // UIImage to Data (PNG Representation)
    var PNGData: Data? {
        return self.pngData()
    }
}
