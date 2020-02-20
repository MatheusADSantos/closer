//
//  CadastroView.swift
//  Closer
//
//  Created by macbook-estagio on 20/09/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import CoreLocation

struct Locais2 {
    let descricao: String
    let telefone: Int
    let site: String
    let foto: UIImage
    let id: String
}

class CadastroView : UIViewController, CadastroViewProtocol {
    
    //MARK: - VARIAVEIS
    var presenter : CadastroPresenterProtocol?
    fileprivate let cellId = "cellId"
    let imagePicker = ImagePicker()
    var descricao:String? = ""
    var telefone:String? = ""
    var site:String? = ""
    var idCategoria: String?
    
    var locais = [Locais2]()
    
    var botoes = [CollectionViewCategorysInCadastro]()
    
    var arrayDeCategorias : [Categorias] = []
    
    
//    static var arrayDePins: [Pino] = []
//    var informacaoDosLocais: [Locais] = []
    
    struct Constants {
        static let screen = UIScreen.main.bounds
        static let screenHeight = screen.height
        static let screenWidth = screen.width
        static let sizeImagePhoto = (screenHeight*1/3)*3/4
    }
    //MARK: - VIEWDIDLOAD()
    override func viewDidLoad() {
        view.backgroundColor = UIColor.backgroundColorGray5
//       let local =  Locais2(descricao: "sdasd", telefone: 3333, site: "dasds", foto: UIImage(cgImage: <#T##CGImage#>), id: "dsadsa")
//        locais.append(local)
        super.viewDidLoad()
        self.arrayDeCategorias = CategoriasDAO().retrieveCategorys()
        print("\nINFORMAÇÕES DO BANCO DE CATEGORIAS: \nNúmero de cadastros:\(arrayDeCategorias.count) e\n descrições: \(arrayDeCategorias.description)")
        
        navigationItem.title = "Cadastro"
        hideKeyboardTapped()
        presenter?.viewDidLoad()
        observeKeyboardNotification()
        
        //------------right  swipe gestures in collectionView--------------//
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRight(sender:)))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        self.collectionViewCategory.addGestureRecognizer(swipeRight)
        
        //-----------left swipe gestures in collectionView--------------//
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft(sender:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.collectionViewCategory.addGestureRecognizer(swipeLeft)
    }
    
    @objc func swipeRight(sender: UISwipeGestureRecognizer) {
        print("direita")
    }
    @objc func swipeLeft(sender: UISwipeGestureRecognizer) {
        print("esquerda")
    }
    
    //MARK: - VIEWDIDAPPEAR()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.arrayDeCategorias = CategoriasDAO().retrieveCategorys()
        print("\nINFORMAÇÕES DO BANCO DE CATEGORIAS: \nNúmero de cadastros:\(arrayDeCategorias.count) e\n descrições: \(arrayDeCategorias.description)")
        collectionViewCategory.reloadData()
    }
    //MARK: - LOADVIEW()
    override func loadView() {
        super.loadView()
        imagePicker.delegate = self
        textFieldDesc.delegate = self
        textFieldPhone.delegate = self
        textFieldSite.delegate = self
        
        collectionViewCategory.delegate = self
        collectionViewCategory.dataSource = self
        collectionViewCategory.register(CollectionViewCategorysInCadastro.self, forCellWithReuseIdentifier: cellId)
    }
    //MARK: - COMPONENTES
    let viewToPhoto : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.backgroundColorGray2
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        return view
    }()
    let imageViewPhoto : UIImageView = {
        let view = UIImageView()
        view.layer.cornerRadius = Constants.sizeImagePhoto/2
        view.layer.masksToBounds = true
        view.backgroundColor = .white
        return view
    }()
    let textFieldDesc : UITextField = {
        let textField = UITextField()
        let raio = CGFloat.heigthComponent/2
        textField.setTextField(raio, raio, .white, "Nome do lugar", .black, 25, 0)
        return textField
    }()
    let textFieldPhone : UITextField = {
        let textField = UITextField()
        let raio = CGFloat.heigthComponent/2
        textField.setTextField(raio, raio, .white, "Telefone do lugar", .black, 25, 1)
        return textField
    }()
    let textFieldSite : UITextField = {
        let textField = UITextField()
        let raio = CGFloat.heigthComponent/2
        textField.setTextField(raio, raio, .white, "Site do lugar", .black, 25, 2)
        return textField
    }()
    var collectionViewCategory : UICollectionView = {
        let raio = CGFloat.heigthComponent/2
        let widthCollectionView = (UIScreen.main.bounds.width-(2*CGFloat.margin))
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
//        layout.itemSize = CGSize(width: CGFloat.heigthComponent, height: CGFloat.heigthComponent)
        layout.itemSize = CGSize(width: widthCollectionView + 170, height: CGFloat.heigthComponent*1.5)
        layout.sectionInset = UIEdgeInsets(top: CGFloat.margin+10, left: -CGFloat.margin, bottom: 10, right: widthCollectionView/1.25)
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 90
        
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: layout)
        collection.layer.cornerRadius = raio
        collection.backgroundColor = .white
        
        return collection
    }()
    
    //MARK: - BUTTON TO BACK HOME(MAP)
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
        print("Chamando o presenter para transição de tela para tela Home(Mapa)")
        presenter?.wireframe?.pushToCloserView(view: self)
    }
    
    //MARK: - BUTTON TO TURN ON CAMERA
    lazy var buttonPhoto : UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(named: "camera"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.backgroundColor = .white
        button.layer.cornerRadius = .heigthComponent/2
        button.setShadow(alpha: 1, offSetX: -1, offSetY: 1, shadowOpacity: 0.95, shadowRadius: 2 , boolean: true)
        button.addTarget(self, action: #selector(callPresenterToShowCamera(sender:)), for: .touchUpInside)
        return button
    }()
    @objc func callPresenterToShowCamera(sender:UIButton) {
        print("Clicou no Botão")
        presenter?.acessCamera(viewController: self)
    }
    
    //MARK: - BUTTON TO REGISTER IN BANK
    lazy var buttonRegister : UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setImage(UIImage.init(named: "save"), for: .normal)
        button.layer.cornerRadius = CGFloat.heigthComponent/2
        let setEdgeInsets = (UIScreen.main.bounds.width/2-((CGFloat.margin)+17))
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: setEdgeInsets, bottom: 8, right: setEdgeInsets)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(registeringCustomMarker(sender:)), for: .touchUpInside)
        return button
    }()
    @objc func registeringCustomMarker(sender:UIButton) {
        self.textFieldDesc.endEditing(true)
        self.textFieldPhone.endEditing(true)
        self.textFieldSite.endEditing(true)
        guard let descricao = textFieldDesc.text else {return}
        CloserView.buscarNoBanco = descricao
        
        presenter?.registerMarker(dictionary:getDictionary(), descricao:self.descricao!, telefone: self.telefone!, site: self.site!, view: self)
    }
    
    //MARK: - BUTTON TO ADD ANOTHER CATEGORIE
    let buttonToAddANewCategory : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.backgroundColorGray
        button.layer.cornerRadius = .heigthComponent/2
        button.setImage(UIImage.init(named: "plus"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        button.setShadow(alpha: 1, offSetX: -1, offSetY: 1, shadowOpacity: 0.95, shadowRadius: 2 , boolean: true)
        button.addTarget(self, action: #selector(goToRegisterNewCategory), for: .touchUpInside)
        return button
    }()
    @objc func goToRegisterNewCategory() {
        print("Chamando o presenter para transição de tela para tela de Cadastro Categoria")
        presenter?.wireframe?.pushToCadastroCategoria(view : self)
    }
    
    
    //MARK: - FUNÇÕES
    
    //MARK: - keyboard Did Show Notification
    fileprivate func observeKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    @objc func keyboardShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            print("keyboardHeight",keyboardHeight)
        }
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: -self.viewToPhoto.bounds.height, width: self.view.frame.width, height: self.view.frame.height)
//            self.textFieldDesc.frame = CGRect(x: 0, y: -50, width: self.textFieldDesc.frame.width, height: self.textFieldDesc.frame.height)
//            self.textFieldPhone.frame = CGRect(x: 0, y: -self.viewToPhoto.bounds.height-10, width: self.textFieldPhone.frame.width, height: self.textFieldPhone.frame.height)
//            self.textFieldSite.frame = CGRect(x: 0, y: -self.viewToPhoto.bounds.height-10, width: self.textFieldSite.frame.width, height: self.textFieldSite.frame.height)
//            self.buttonRegister.frame = CGRect(x: 0, y: -self.viewToPhoto.bounds.height-10, width: self.buttonRegister.frame.width, height: self.buttonRegister.frame.height)
        }, completion: nil)
    }
    @objc func keyboardHide() {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
//            self.textFieldDesc.frame = CGRect(x: 0, y: 0, width: self.textFieldDesc.frame.width, height: self.textFieldDesc.frame.height)
//            self.textFieldPhone.frame = CGRect(x: 0, y: 0, width: self.textFieldPhone.frame.width, height: self.textFieldPhone.frame.height)
//            self.textFieldSite.frame = CGRect(x: 0, y: 0, width: self.textFieldSite.frame.width, height: self.textFieldSite.frame.height)
//            self.buttonRegister.frame = CGRect(x: 0, y: 0, width: self.buttonRegister.frame.width, height: self.buttonRegister.frame.height)
        }, completion: nil)
    }
    
    
    //APRESENTANDO A CAMERA ...
    func showCamera(viewController: UIViewController) {
        print("Apresentando a camera...")
        
        let menu = imagePicker.menuDeOpcoes { (opcao) in
            let multimidia = UIImagePickerController()
            multimidia.delegate = self.imagePicker
            
            if opcao == .camera && UIImagePickerController.isSourceTypeAvailable(.camera) {
                multimidia.sourceType = .camera
            } else {
                multimidia.sourceType = .photoLibrary
            }
            viewController.present(multimidia, animated: true, completion: nil)
        }
        present(menu, animated: true, completion: nil)
    }
    
    //CRIANDO O DICIONARIO PARA USAR NA HORA DE SALVAR NO BANCO
    func getDictionary() -> [String:Any]{
        //pegando os dados a serem salvos
        guard let descricao = self.descricao else {return[:]}
        guard let telefone = self.telefone else {return[:]}
        guard let site = self.site else {return[:]}
        guard let foto = self.imageViewPhoto.image else {return[:]}
        guard let id = self.idCategoria else {return[:]}
        
        //populando o array (parametro para salvar)
        let dicionario = ["descricao": descricao, "telefone": telefone, "site": site, "foto": foto, "id": id,
                          "localLat": CloserView.localSelecionadoLat!, "localLong": CloserView.localSelecionadoLong!] as [String : Any]
        
        return dicionario
    }
    
    //REMOVENDO UM ITEM DA COLLETION
    func removeItemFromColletion(index: Int) {
        
        //Feed para o user que foi deletado um item da collection------------------------------
        print("\nFoi removido uma categoria da colletionView")
        let item = arrayDeCategorias[index]
        guard let categoriaExcluida = item.descricao else {return}
        if let alerta = Notificacoes().alertaDeItemRemovidoDaCollection(nomeDaCategoria: categoriaExcluida) {
            self.present(alerta, animated: true, completion: nil)
        }
        //Feed para o user que foi deletado um item da collection------------------------------
        
        CategoriasDAO().deleteCategoria(categoria: self.arrayDeCategorias[index])
        arrayDeCategorias.remove(at: index)
        
        let indexPath = IndexPath(row: index, section: 0)
        collectionViewCategory.performBatchUpdates({
            collectionViewCategory.deleteItems(at: [indexPath])
            
        }, completion: {
            (finished: Bool) in
            self.collectionViewCategory.reloadItems(at: self.collectionViewCategory.indexPathsForVisibleItems)
        })
    }
    
    //MOVENDO UM ITEM DA COLLECTION
    func moveItemAtTo(indexAt: Int, indexTo: Int = 0) {
        let indexPathAt = IndexPath(row: indexAt, section: 0)
        let indexPathTo = IndexPath(row: indexTo, section: 0)
        collectionViewCategory.moveItem(at: indexPathAt, to: indexPathTo)
    }
    
    //MARK: - CARREGANDO AS VIEWS (VIPER)
    func loadViews() {
        print("Carregando as views")
        view.addSubviews(viewsToAdd: viewToPhoto, imageViewPhoto, /*buttonToPopView, */buttonPhoto, textFieldDesc, textFieldPhone, textFieldPhone, textFieldSite, buttonRegister, collectionViewCategory, buttonToAddANewCategory)
        
//        guard let heightNavBar = (navigationController?.navigationBar.frame.height) else {return}
//        print("manga", heightNavBar)
        
        
        viewToPhoto.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(66)//heightNavBar+20)
            make.left.right.equalToSuperview()
            make.height.equalTo(Constants.screenHeight*1/3)
        }
        imageViewPhoto.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(viewToPhoto)
            make.height.width.equalTo(Constants.sizeImagePhoto)
        }
//        buttonToPopView.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().offset(CGFloat.margin)
//            make.top.equalTo(imageViewPhoto.snp.top)
//            make.height.width.equalTo(CGFloat.heigthComponent)
//        }
        buttonPhoto.snp.makeConstraints { (make) in
//            make.right.equalTo(viewToPhoto.snp.right).offset(-CGFloat.margin)
            make.right.equalTo(buttonToAddANewCategory.snp.right)
            make.top.equalTo(viewToPhoto.snp.bottom).offset(-CGFloat.heigthComponent/2)
            make.height.width.equalTo(CGFloat.heigthComponent)
        }
        textFieldDesc.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(CGFloat.margin)
            make.right.equalToSuperview().offset(-CGFloat.margin)
            make.top.equalTo(viewToPhoto.snp.bottom).offset(CGFloat.margin*3)
            make.height.equalTo(CGFloat.heigthComponent)
        }
        textFieldPhone.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(CGFloat.margin)
            make.right.equalToSuperview().offset(-CGFloat.margin)
            make.top.equalTo(textFieldDesc.snp.bottom).offset(CGFloat.margin)
            make.height.equalTo(CGFloat.heigthComponent)
        }
        textFieldSite.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(CGFloat.margin)
            make.right.equalToSuperview().offset(-CGFloat.margin)
            make.top.equalTo(textFieldPhone.snp.bottom).offset(CGFloat.margin)
            make.height.equalTo(CGFloat.heigthComponent)
        }
        buttonRegister.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(CGFloat.margin)
            make.right.equalToSuperview().offset(-CGFloat.margin)
            make.bottom.equalToSuperview().offset(-CGFloat.margin*2)
            make.height.equalTo(CGFloat.heigthComponent)
        }
        collectionViewCategory.snp.makeConstraints { (make) in
            make.top.equalTo(textFieldSite.snp.bottom).offset(CGFloat.margin)
            make.left.equalToSuperview().offset(CGFloat.margin)
            make.right.equalToSuperview().offset(-CGFloat.margin)
            make.bottom.equalTo(buttonRegister.snp.top).offset(-10)
        }
        buttonToAddANewCategory.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-(CGFloat.margin*2+10))
            make.top.equalTo(textFieldSite.snp.bottom).offset(CGFloat.margin*2+10)
            make.height.width.equalTo(CGFloat.heigthComponent)
        }
        
    }
    
    
}


extension CadastroView : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayDeCategorias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.backgroundColor = .white
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CollectionViewCategorysInCadastro
        cell.sizeToFit()
        cell.backgroundColor = .clear
        cell.layer.cornerRadius = CGFloat.heigthComponent/2
        cell.setShadow(alpha: 1, offSetX: -1, offSetY: 1, shadowOpacity: 0.95, shadowRadius: 2 , boolean: true)
        
        //Crio arrays de imagens e descricoes e no for populo elas e entao seto as celulas na posicao ...
        var arrayImage : [UIImage] = []
        var arrayDescricao : [String] = []
        for cat in arrayDeCategorias {
            let pngImage = UIImage(data: cat.categoria!)
            arrayImage.append(pngImage!)
            arrayDescricao.append(cat.descricao!)
        }
        cell.imageView.image = arrayImage[indexPath.item]
        cell.label.text = arrayDescricao[indexPath.item]
//        cell.viewToTouch.backgroundColor = .red
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CollectionViewCategorysInCadastro
        print(cell)
        cell.imageView.setShadow(alpha: 1, offSetX: -1, offSetY: 1, shadowOpacity: 0.95, shadowRadius: 5 , boolean: true)
        cell.label.font = UIFont.systemFont(ofSize: 30)
        cell.alpha = 0.5
        cell.backgroundColor = .red
        
        
//        MetodosColletion().removeItemFromColletion(index: indexPath.item, collectionView: collectionViewCategory, view: self, arrayCategorias: informacaoDasCategorias)
//        MetodosColletion().moveItemAtTo(indexAt: indexPath.item, collectionView: collectionViewCategory)
        
    
        let uuid = arrayDeCategorias[indexPath.item].id
        let uuidString = String(describing: uuid!.uuidString)
        print("\nID da Categoria: \(uuidString)")
        idCategoria = uuidString
        
        
//        removeItemFromColletion(index: indexPath.item)
//        moveItemAtTo(indexAt: indexPath.item)
//        self.swipeRight(sender: UISwipeGestureRecognizer())
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CollectionViewCategorysInCadastro
        print(cell)
        cell.imageView.setShadow(alpha: 1, offSetX: -1, offSetY: 1, shadowOpacity: 0.95, shadowRadius: 2 , boolean: true)
        cell.backgroundColor = .clear
    }
    
}

extension CadastroView: ImagePickerFotoSelecionadaProtocol {
    func imagePickerFotoSelecionada(foto: UIImage) {
        imageViewPhoto.image = foto
    }
}

//MARK: - Delegate dos textFields
extension CadastroView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let data = textField.text else {return}
        switch textField.tag {
        case 0:
            self.descricao = data
            print(self.descricao!)
        case 1:
            self.telefone = data
            print(self.telefone!)
        case 2:
            self.site = data
            print(self.site!)
        default:
            break
        }
        
    }
}
