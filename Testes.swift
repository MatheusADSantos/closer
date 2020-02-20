//
//  Testes.swift
//  Closer
//
//  Created by macbook-estagio on 30/10/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import Foundation

//
//  CloserView.swift
//  Closer
//
//  Created by macbook-estagio on 18/09/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//
//
//import UIKit
//import SnapKit
//import MapKit
//import CoreLocation
//import Lottie
//
//protocol atualizaArrayPinsProtocol {
//    func populaArrayPins(arrayPins:[Pino])
//}
//protocol pegaDistanciaEPosicaoProtocol {
//    func pegaDistanciaEPosicao(distancia:CLLocationDistance, posicao:CLLocationCoordinate2D)
//}
//
//class CloserView: UIViewController, CloserViewProtocol {
//    
//    //MARK: Atributos
//    let locationManager = CLLocationManager()
//    let regionInMeters: Double = 2000
//    static var arrayDePins: [Pino] = []
//    var informacaoDosLocais: [Locais] = []
//    var arrayDeCategorias = [Categorias]()
//    fileprivate let cellId = "cellId"
//    var categoriaSelecionada : Bool? = false
//    
//    //para calcular a distancia entre os pins
//    var currentPositionCLLocation: CLLocation?
//    //para setar o pin da posicao atual
//    var currentPositionCLLocationCoordinate2D: CLLocationCoordinate2D?
//    
//    static var localSelecionado:CLLocationCoordinate2D? // só para verifica se busca no banco todo ou nao
//    static var distanciaDaPosicaoAtual:CLLocationDistance?
//    
//    var presenter:CloserPresenterProtocol?
//    var delegateAtualizaArrayPins : atualizaArrayPinsProtocol?
//    var delegatePegaPosicaoEDistanciaDePin : pegaDistanciaEPosicaoProtocol?
//    
//    static var buscarNoBanco : String?
//    static var localSelecionadoLat : Double?
//    static var localSelecionadoLong : Double?
//    static var image: UIImage?
//    var fileViewOrigin: CGPoint!
//    var frameAtualValidoDaCategoria: Double!
//    
//    //MARK: - LOADVIEW()
//    //TUDO QUANTO FOR INFORMAÇÃO DO TIPO CHAMAR OS DELEGATES E REGISTRAR CÉLULAS POR EX ... FAZ-SE AQUI.
//    override func loadView() {
//        super.loadView()
//        collectionViewCategoryInMap.reloadData()
//        mapView.reloadInputViews()
//        
//        mapView.delegate = self
//        mapView.register(CustomMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
//        
//        collectionViewCategoryInMap.delegate = self
//        collectionViewCategoryInMap.dataSource = self
//        collectionViewCategoryInMap.register(CollectionViewCategorysInMap.self, forCellWithReuseIdentifier: cellId)
//    }
//    
//    //MARK: - Cycles Life
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.buttonTrash.alpha = 0
//        
//        CloserWireFrame.createCloserModule(closerViewRef: self)
//        presenter?.viewDidLoad()
//        
//        informacaoDosLocais = LocaisDAO().retrievePlaces()
//        populandoArrayPins(informacaoDosLocais: informacaoDosLocais, IDCategoria: "")
//        //        setPins()
//        print("\n\n QUANTIDADE DE PINS CADASTRADOS: \(informacaoDosLocais.count)")
//        arrayDeCategorias = CategoriasDAO().retrieveCategorys()
//        
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        
//        informacaoDosLocais = LocaisDAO().retrievePlaces()
//        populandoArrayPins(informacaoDosLocais: informacaoDosLocais, IDCategoria: "")
//        //        setPins(idCategoria: "")
//        print("\n\n QUANTIDADE DE PINS CADASTRADOS: \(informacaoDosLocais.count)")
//        arrayDeCategorias = CategoriasDAO().retrieveCategorys()
//        collectionViewCategoryInMap.reloadData()
//        mapView.reloadInputViews()
//    }
//    
//    //MARK: - Componente MAPA
//    lazy var mapView : MKMapView = {
//        let view = MKMapView()
//        view.isZoomEnabled = true // default true
//        view.isRotateEnabled = false // default true
//        view.isScrollEnabled = true // default true
//        view.showsCompass = true // default true
//        view.showsPointsOfInterest = true  //default true
//        
//        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(goToRegisterMarker(sender:)))
//        longPress.minimumPressDuration = 1
//        view.addGestureRecognizer(longPress)
//        return view
//    }()
//    lazy var labelOrigem : UILabel = {
//        let label = UILabel()
//        label.layer.cornerRadius = 25
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.black.cgColor
//        label.layer.masksToBounds = true
//        //            let posicaoAtual = "\(self.mapView.userLocation.isUpdating)"
//        let numeroDePins = "\(informacaoDosLocais.count)"
//        label.textColor = .white
//        label.setBasicLabel(text: " Pins Cadastrados: \(numeroDePins)", textColor: .white, font: 30, backgroundColor: UIColor().hexaToColor(hex: "dbc9ac"), textAlignment: .left)
//        return label
//    }()
//    
//    var collectionViewCategoryInMap : UICollectionView = {
//        let raio = CGFloat.heigthComponent/2
//        let widthCollectionView = (UIScreen.main.bounds.width-(2*CGFloat.margin))
//        
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.itemSize = CGSize(width: CGFloat.heigthComponent, height: CGFloat.heigthComponent)
//        //        layout.minimumInteritemSpacing = 35
//        layout.minimumLineSpacing = 50
//        
//        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: layout)
//        collection.layer.cornerRadius = raio
//        collection.backgroundColor = .clear
//        
//        return collection
//    }()
//    
//    
//    lazy var buttonToZoomToCurrentLocation : UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "mira"), for: .normal)
//        button.layer.cornerRadius = CGFloat.heigthComponent/2
//        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
//        button.backgroundColor = .white
//        button.setShadow(alpha: 1, offSetX: 1, offSetY: 1, shadowOpacity: 1, shadowRadius: 2, boolean: true)
//        button.addTarget(self, action: #selector(focusesOnCurrentLocation), for: .touchUpInside)
//        return button
//    }()
//    @objc func focusesOnCurrentLocation() {
//        print("foi")
//    }
//    lazy var viewToPin : UIView = {
//        let view = UIView()
//        view.backgroundColor = .black
//        view.layer.cornerRadius = 10
//        view.layer.masksToBounds = true
//        
//        return view
//    }()
//    lazy var labelInfoPin : UILabel = {
//        let label = UILabel()
//        label.backgroundColor = .white
//        label.layer.masksToBounds = true
//        label.layer.cornerRadius = 10
//        return label
//    }()
//    lazy var imageViewPin : UIImageView = {
//        let image = UIImageView()
//        image.layer.cornerRadius = 75
//        image.layer.masksToBounds = true
//        return image
//    }()
//    
//    lazy var buttonTrash: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "trash"), for: .normal)
//        button.layer.cornerRadius = (CGFloat.heigthComponent*1.3)/2
//        button.setShadow(alpha: 1, offSetX: 3, offSetY: 3, shadowOpacity: 1, shadowRadius: 3, boolean: true)
//        button.backgroundColor = .clear
//        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
//        return button
//    }()
//    
//    //MARK: - FUNÇÕES
//    
//    //ADD A PANGESTURE TO CATEGORY TO DELETE
//    func addLongPressGesture(view: UIView) {
//        //        fileViewOrigin = view.frame.origin
//        //        print("fileOrigin----->>>>>", fileViewOrigin!)
//        let longPress = UILongPressGestureRecognizer(target: self, action:#selector(handleLongPress(sender:)))
//        view.addGestureRecognizer(longPress)
//    }
//    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
//        //        self.collectionViewCategoryInMap.reloadData()
//        if sender.state == .began {
//            delayWithSeconds(1) {
//                print("Frame da cell selecionada",sender.view!.frame.origin)
//                self.fileViewOrigin = sender.view!.frame.origin
//                self.addPanGesture(view: sender.view!)
//            }
//        }
//        
//    }
//    
//    
//    //    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
//    //        print("Deletar uma categoria!)")
//    ////        print("Frame da cell selecionada",sender.view!.frame.origin)
//    ////        self.fileViewOrigin = sender.view!.frame.origin
//    //
//    //
//    ////        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//    ////            self.addPanGesture(view: sender.view!)
//    //////            if sender.state != .ended {
//    //////                self.addPanGesture(view: sender.view!)
//    //////            }
//    ////
//    ////        }
//    //
//    //
//    //        if sender.state == .began {
//    //            delayWithSeconds(2) {
//    //                print("KKKKAKKAKKKAKKAKAK((()(**")
//    //                print("Frame da cell selecionada",sender.view!.frame.origin)
//    //                self.fileViewOrigin = sender.view!.frame.origin
//    //                self.addPanGesture(view: sender.view!)
//    //            }
//    ////            print("Frame da cell selecionada",sender.view!.frame.origin)
//    ////            fileViewOrigin = sender.view!.frame.origin
//    ////            addPanGesture(view: sender.view!)
//    ////            if sender.minimumPressDuration == 0.5 {
//    ////                addPanGesture(view: sender.view!)
//    ////            }
//    //        }
//    //        //SE O ESTADO NAO TERMINOU ...
//    ////        if sender.state != .ended {
//    //////            print("ˆˆˆˆˆˆˆˆ&&&&&&&ˆˆˆ",sender.view!.frame.origin)
//    ////            return
//    ////        }
//    ////        let pointFromCollection = sender.location(in: self.collectionViewCategoryInMap)
//    ////        if let indexPath = self.collectionViewCategoryInMap.indexPathForItem(at: pointFromCollection) {
//    ////            // get the cell at indexPath (the one you long pressed)
//    ////            let cell = self.collectionViewCategoryInMap.cellForItem(at: indexPath)
//    ////
//    ////            // do stuff with the cell
//    ////            print("cell \(String(describing: cell)) \n\(indexPath)")
//    //////            cell?.contentView.backgroundColor = .red
//    //////            cell?.contentView.alpha = 0
//    ////        }
//    //////            let index = sender.indexPa
//    ////        else {
//    ////            print("couldn't find index path")
//    ////        }
//    //
//    //
//    ////        //REMOVENDO UM ITEM DA COLLETION
//    ////        func removeItemFromColletion(index: Int) {
//    ////
//    ////            //Feed para o user que foi deletado um item da collection------------------------------
//    ////            print("\nFoi removido uma categoria da colletionView")
//    ////            let item = arrayDeCategorias[index]
//    ////            guard let categoriaExcluida = item.descricao else {return}
//    ////            if let alerta = Notificacoes().alertaDeItemRemovidoDaCollection(nomeDaCategoria: categoriaExcluida) {
//    ////                self.present(alerta, animated: true, completion: nil)
//    ////            }
//    ////            //Feed para o user que foi deletado um item da collection------------------------------
//    ////
//    ////            CategoriasDAO().deleteCategoria(categoria: self.arrayDeCategorias[index])
//    ////            arrayDeCategorias.remove(at: index)
//    ////
//    ////            let indexPath = IndexPath(row: index, section: 0)
//    ////            collectionViewCategoryInMap.performBatchUpdates({
//    ////                collectionViewCategoryInMap.deleteItems(at: [indexPath])
//    ////
//    ////            }, completion: {
//    ////                (finished: Bool) in
//    ////                self.collectionViewCategoryInMap.reloadItems(at: self.collectionViewCategoryInMap.indexPathsForVisibleItems)
//    ////            })
//    ////        }
//    ////
//    ////        //MOVENDO UM ITEM DA COLLECTION
//    ////        func moveItemAtTo(indexAt: Int, indexTo: Int = 0) {
//    ////            let indexPathAt = IndexPath(row: indexAt, section: 0)
//    ////            let indexPathTo = IndexPath(row: indexTo, section: 0)
//    ////            collectionViewCategoryInMap.moveItem(at: indexPathAt, to: indexPathTo)
//    ////        }
//    //
//    //
//    //
//    //
//    //
//    //
//    ////        callAlertToDeleteCategory()
//    //
//    ////        if let alerta = Notificacoes().alertaDeCampoNaoPreenchido() {
//    ////            self.present(alerta, animated: true, completion: nil)
//    ////        }
//    //
//    ////        if sender.isEnabled == true {
//    ////            print("boa \(sender.isEnabled)")
//    ////            addPanGesture(view: self.collectionViewCategoryInMap.cellForItem(at: <#T##IndexPath#>))
//    ////            self.fileViewOrigin = view.frame.origin
//    ////        }
//    //    }
//    
//    //    func callAlertToDeleteCategory() {
//    //        if let alerta = Notificacoes().alertaDeItemRemovidoDaCollection(nomeDaCategoria: <#T##String#>) {
//    //            self.present(alerta, animated: true, completion: nil)
//    //        }
//    //    }
//    
//    
//    func addPanGesture(view: UIView) {
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
//        view.addGestureRecognizer(pan)
//    }
//    @objc func handlePan(sender: UIPanGestureRecognizer) {
//        //        print("PANPANPAN \(sender.velocity(in: view))")
//        
//        let fileView = sender.view!
//        let translation = sender.translation(in: view)
//        
//        switch sender.state {
//        case .began, .changed:
//            //            self.collectionViewCategoryInMap.backgroundColor = .red
//            self.buttonTrash.alpha = 1
//            
//            fileView.center = CGPoint(x: fileView.center.x + translation.x, y: fileView.center.y + translation.y )
//            sender.setTranslation(CGPoint.zero, in: view)
//        //------------------------QUANDO SOLTA A CATEGORIA------------------------
//        case .ended:
//            self.collectionViewCategoryInMap.backgroundColor = .clear
//            self.buttonTrash.alpha = 0
//            
//            print("frame do buttonTrash \(buttonToZoomToCurrentLocation.frame)")
//            print("frame da origem da cat \(fileView.frame)")
//            print("CRUZOU", (fileView.frame.intersects(buttonTrash.frame)))
//            
//            let intervalo = 322.0..<500000000.0
//            let xFrameCategoryDouble = Double(fileView.frame.origin.x)
//            
//            if intervalo.contains(xFrameCategoryDouble) {
//                //                let ref = CGRect(x: xFrameCategoryDouble, y: 6.0, width: 40.0, height: 40.0)
//                //                if fileView.frame.intersects(ref) {
//                //                    print("CRUZOU", (fileView.frame.intersects(ref)))
//                //                    print("chegou \(buttonTrash.frame.origin)")
//                //                    UIView.animate(withDuration: 0.3) {
//                //                        fileView.alpha = 0.0
//                //                    }
//                //                }
//                //                else {
//                //                    UIView.animate(withDuration: 0.3) {
//                //                        fileView.frame.origin = self.fileViewOrigin
//                //                        for gesture in fileView.gestureRecognizers ?? [] {
//                //                            fileView.removeGestureRecognizer(gesture)
//                //                            self.collectionViewCategoryInMap.reloadData()
//                //                        }
//                //                    }
//                //                }
//                self.frameAtualValidoDaCategoria = xFrameCategoryDouble
//            }
//            let ref = CGRect(x: self.frameAtualValidoDaCategoria ?? 0.0, y: 6.0, width: 40.0, height: 40.0)
//            if fileView.frame.intersects(ref) {
//                print("CRUZOU", (fileView.frame.intersects(ref)))
//                print("chegou \(buttonTrash.frame.origin)")
//                UIView.animate(withDuration: 0.3) {
//                    fileView.alpha = 0.0
//                }
//            }
//            else {
//                
//                UIView.animate(withDuration: 0.3, animations: {
//                    fileView.frame.origin = self.fileViewOrigin
//                }) { (_) in
//                    for gesture in fileView.gestureRecognizers ?? [] {
//                        fileView.removeGestureRecognizer(gesture)
//                        self.collectionViewCategoryInMap.reloadData()
//                    }
//                }
//                
//                //                UIView.animate(withDuration: 0.3) {
//                //
//                //
//                //
//                //
//                //
//                //                }
//            }
//            break
//        //------------------------QUANDO SOLTA A CATEGORIA------------------------
//        default:
//            break
//        }
//    }
//    
//    func removeGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer){
//        print("")
//    }
//    
//    //SETTING IMAGE FROM BANK CATEGORYS IN COLLECTION CELL
//    func populandoArrayDeImagensCategorias() -> [UIImage]{
//        var arrayImagesCategorias = [UIImage]()
//        
//        for cat in arrayDeCategorias {
//            let pngImage = UIImage(data: cat.categoria!)
//            arrayImagesCategorias.append(pngImage!)
//        }
//        return arrayImagesCategorias
//    }
//    
//    //SETTING DATA FROM MARKERS IN VIEW
//    func setInfoPin(coordenada: CLLocationCoordinate2D?) {
//        for pin in informacaoDosLocais {
//            guard let foto = pin.foto else {return}
//            guard let descricao = pin.descricao else {return}
//            
//            CloserView.image = foto as? UIImage
//            
//            let localLat = pin.localLat
//            let localLong = pin.localLong
//            if (localLat == coordenada?.latitude) && (localLong == coordenada?.longitude) {
//                labelInfoPin.text = descricao
//                imageViewPin.image = foto as? UIImage
//            }
//        }
//    }
//    
//    //MARK: - POPULANDO O ARRAY DE PINS
//    func populandoArrayPins(informacaoDosLocais:[Locais], IDCategoria:String? = "") {
//        print("Informações do banco de Pins: --> \(informacaoDosLocais)")
//        self.mapView.removeAnnotations(CloserView.arrayDePins)
//        CloserView.arrayDePins = []
//        for pin in informacaoDosLocais {
//            guard let descricao = pin.descricao else {return}
//            guard let telefone = pin.telefone else {return}
//            guard let site = pin.site else {return}
//            guard let image = pin.foto else {return}
//            guard let IDPin = pin.idCategoria else {return}
//            var iconeDaCategoria: UIImage?
//            let lat = pin.localLat
//            let long = pin.localLong
//            let locationTouch : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: long)
//            var pino: Pino
//            
//            if IDCategoria != "" {
//                for cat in arrayDeCategorias {
//                    guard let IDCategoriaGeral = cat.id else {return}
//                    let IDCategoriaGeral2 = String(describing: IDCategoriaGeral)
//                    guard let IDMarker = pin.idCategoria else {return}
//                    if IDMarker == IDCategoriaGeral2 {
//                        iconeDaCategoria = UIImage(data: cat.categoria!)
//                        pino = Pino(title: """
//                            \(descricao)
//                            \(telefone)
//                            \(site)
//                            """, telefone: telefone, site: site, coordinate: locationTouch, color: nil, icon: iconeDaCategoria, image: image as? UIImage, idCategoria: IDCategoria)
//                        CloserView.arrayDePins.append(pino)
//                    }
//                }
//                //Apresento na tela somente os selecionados
//                delegateAtualizaArrayPins?.populaArrayPins(arrayPins: CloserView.arrayDePins)
//                mapView.addAnnotations(CloserView.arrayDePins)
//                print("ANOTACOES ----> \(CloserView.arrayDePins.count)")
//                self.mapView.showAnnotations(CloserView.arrayDePins, animated: true)
//            } else {
//                for cat in arrayDeCategorias {
//                    guard let IDCategoriaGeral = cat.id else {return}
//                    let IDCategoriaGeral2 = String(describing: IDCategoriaGeral)
//                    if IDPin == IDCategoriaGeral2 {
//                        iconeDaCategoria = UIImage(data: cat.categoria!)
//                        pino = Pino(title: """
//                            \(descricao)
//                            \(telefone)
//                            \(site)
//                            """, telefone: telefone, site: site, coordinate: locationTouch, color: nil, icon: iconeDaCategoria, image: image as? UIImage, idCategoria: IDCategoria)
//                        CloserView.arrayDePins.append(pino)
//                        delegateAtualizaArrayPins?.populaArrayPins(arrayPins: CloserView.arrayDePins)
//                        self.mapView.addAnnotation(pino)
//                    }
//                }
//            }
//        }
//        //        print("ANOTACOES ----> \(CloserView.arrayDePins.description)")
//        self.mapView.showAnnotations(CloserView.arrayDePins, animated: true)
//    }
//    
//    //MARK: - LONGPRESS
//    @objc func goToRegisterMarker(sender: UILongPressGestureRecognizer) {
//        print("\nTapped with Long Press!")
//        print("Number of longpress: \(sender.numberOfTouchesRequired)")
//        if sender.state != (UIGestureRecognizer.State.began) {return}
//        let touchLocation = sender.location(in: mapView)
//        print("Cordinates of a Specific Point in the Map: \(touchLocation)")
//        //pegando o localSelecionado para avisar qual retrieveData usar, se busca toda a lista que é o caso de quando se inicia a tela pela primeira vez(viewDidLoad) ou somente a que acabou de cadastrar quando o app já foi carregado ...
//        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
//        print("Tapped at coordinate: \(locationCoordinate) \nlat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
//        CloserView.localSelecionado = locationCoordinate
//        //Pegando a lat/long para setar no banco ...
//        CloserView.localSelecionadoLat = locationCoordinate.latitude
//        CloserView.localSelecionadoLong = locationCoordinate.longitude
//        
//        //pegando a distanciaDaOrigem
//        let newPosition : CLLocation = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
//        guard let distancia = currentPositionCLLocation?.distance(from: newPosition) else {return}
//        CloserView.distanciaDaPosicaoAtual = distancia
//        
//        delegatePegaPosicaoEDistanciaDePin?.pegaDistanciaEPosicao(distancia: distancia , posicao: locationCoordinate)
//        presenter?.callViewController(viewRef: self)
//        
//    }
//    
//    func setCurrentPin(localizacaoAtual: CLLocationCoordinate2D) {
//        //        let currentPino = self.configuraPino(titulo: "", localizacao: self.currentPositionCLLocationCoordinate2D!, cor: .black, icone: UIImage(named: "man-user"))
//        
//        let currentPino = Pino(title: "Eu", telefone: "981015281", site: "-", coordinate: self.currentPositionCLLocationCoordinate2D!, color: .black, icon: UIImage(named: "man-user"), image: nil, idCategoria: nil)
//        self.mapView.addAnnotation(currentPino)
//        CloserView.arrayDePins.append(currentPino)
//    }
//    
//    //MARK: - Carregamento dos componentes
//    func loadViews() {
//        print("Carregou as views")
//        //MAPA
//        view.addSubview(mapView)
//        mapView.snp.makeConstraints { (make) in
//            make.left.right.bottom.equalToSuperview()
//            //            make.top.equalTo(labelOrigem.snp.bottom).offset(0)
//            make.top.equalToSuperview()
//        }
//        //LABEL ORIGEM
//        view.addSubview(labelOrigem)
//        labelOrigem.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().offset(40)
//            make.left.right.equalToSuperview()
//            make.height.equalTo(50)
//        }
//        //ANIMAÇÃO
//        let animationLongPress : AnimationView = {
//            let animation = AnimationView()
//            animation.animation = Animation.named("480-micro-interaction-touch-app-animation")
//            animation.loopMode = .loop
//            animation.animationSpeed = 0.6
//            animation.play()
//            animation.clipsToBounds = false
//            //                    animation.setPlayRange(fromProgress: 0, toProgress: 0.7, event: .touchUpInside)
//            //            animation.addTarget(self, action: #selector(buttonClickedToBookMark(_ :)), for: .touchUpInside)
//            return animation
//        }()
//        view.addSubview(animationLongPress)
//        animationLongPress.snp.makeConstraints { (make) in
//            make.right.equalToSuperview().offset(15)
//            make.top.equalTo(labelOrigem.snp.bottom).offset(-10)
//            make.height.width.equalTo(100)
//        }
//        view.addSubview(collectionViewCategoryInMap)
//        collectionViewCategoryInMap.snp.makeConstraints { (make) in
//            make.left.right.equalToSuperview()
//            make.bottom.equalToSuperview().offset(-2*CGFloat.margin)
//            make.height.equalTo(CGFloat.heigthComponent*1.3)
//        }
//        view.addSubview(buttonToZoomToCurrentLocation)
//        buttonToZoomToCurrentLocation.snp.makeConstraints { (make) in
//            make.height.width.equalTo(CGFloat.heigthComponent)
//            make.right.equalToSuperview().offset(-CGFloat.margin)
//            make.bottom.equalTo(collectionViewCategoryInMap.snp.top).offset(-CGFloat.margin)
//        }
//        view.addSubview(buttonTrash)
//        buttonTrash.snp.makeConstraints { (make) in
//            make.right.top.equalTo(collectionViewCategoryInMap)
//            make.height.width.equalTo(CGFloat.heigthComponent*1.3)
//        }
//    }
//    //MARK: - Mostrando minha localização Atual
//    func showMyLocation() {
//        print("Mostrando minha localização")
//        checkLocationServices()
//    }
//    //MARK: - Configurações Adicionais
//    func additionalConfiguration() {
//        let navigation = navigationController
//        navigation?.isNavigationBarHidden = true
//    }
//    //MARK: - Configurações do CHECKLOCATIONSERVICES()
//    func centerViewOnUserLocation() {
//        if let location = locationManager.location?.coordinate {
//            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
//            mapView.setRegion(region, animated: true)
//        }
//    }
//    func setupLocationManager() {
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//    }
//    func checkLocationServices() {
//        if CLLocationManager.locationServicesEnabled() {
//            //setup our locationManager
//            setupLocationManager()
//            checkLocationAutorization()
//        } else {
//            //Show Alert letting the user know they have turn this on
//        }
//    }
//    func checkLocationAutorization() {
//        switch CLLocationManager.authorizationStatus() {
//        case .authorizedWhenInUse:
//            //Do map stuff
//            mapView.showsUserLocation = true
//            centerViewOnUserLocation()
//            locationManager.startUpdatingLocation()
//            break
//        case .denied:
//            //Show Alert instructing them how to turn on permissions
//            break
//        case .notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//            break
//        case .restricted:
//            //Show an alert letting them know what`s up
//            break
//        case .authorizedAlways:
//            break
//        default:
//            break
//        }
//    }
//}
//
////MARK: - DELEGATES DA COLLECTION
//extension CloserView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
//    
//    //REMOVENDO UM ITEM DA COLLETION
//    func removeItemFromColletion(index: Int) {
//        
//        //Feed para o user que foi deletado um item da collection------------------------------
//        print("\nFoi removido uma categoria da colletionView")
//        let item = arrayDeCategorias[index]
//        guard let categoriaExcluida = item.descricao else {return}
//        if let alerta = Notificacoes().alertaDeItemRemovidoDaCollection(nomeDaCategoria: categoriaExcluida) {
//            self.present(alerta, animated: true, completion: nil)
//        }
//        //Feed para o user que foi deletado um item da collection------------------------------
//        
//        CategoriasDAO().deleteCategoria(categoria: self.arrayDeCategorias[index])
//        arrayDeCategorias.remove(at: index)
//        
//        let indexPath = IndexPath(row: index, section: 0)
//        collectionViewCategoryInMap.performBatchUpdates({
//            collectionViewCategoryInMap.deleteItems(at: [indexPath])
//            
//        }, completion: {
//            (finished: Bool) in
//            self.collectionViewCategoryInMap.reloadItems(at: self.collectionViewCategoryInMap.indexPathsForVisibleItems)
//        })
//    }
//    
//    //MOVENDO UM ITEM DA COLLECTION
//    func moveItemAtTo(indexAt: Int, indexTo: Int = 0) {
//        let indexPathAt = IndexPath(row: indexAt, section: 0)
//        let indexPathTo = IndexPath(row: indexTo, section: 0)
//        collectionViewCategoryInMap.moveItem(at: indexPathAt, to: indexPathTo)
//    }
//    
//    
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.arrayDeCategorias.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as!  CollectionViewCategorysInMap
//        
//        
//        
//        addLongPressGesture(view: cell)
//        //        fileViewOrigin = cell.frame.origin
//        
//        //        addPanGesture(view: cell)
//        //        fileViewOrigin = cell.frame.origin
//        
//        
//        
//        
//        
//        
//        //Se for usar um button------------------------------------
//        //        cell.buttonCategorias.setImage(arrayImagesCategorias[indexPath.item], for: .normal)
//        
//        //Se for usar uma UIImageView------------------------------
//        let arrayImagesCategorias = populandoArrayDeImagensCategorias()
//        let image = arrayImagesCategorias[indexPath.item]
//        cell.buttonCategorias.image = image
//        
//        
//        //        cell.buttonCategorias.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//        cell.layer.cornerRadius = CGFloat.heigthComponent/2
//        cell.setShadow(alpha: 1, offSetX: -2, offSetY: 2, shadowOpacity: 1, shadowRadius: 1, boolean: true)
//        
//        collectionView.backgroundColor = .clear
//        cell.backgroundColor = .white
//        
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        //        //INSTANCIO UMA CELULA PEGO O FRAME DELA E PASSO PARA FILEVIEWORIGIN, E ADD UM LONGPRESS
//        //        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CollectionViewCategorysInMap
//        //        addLongPressGesture(view: cell)
//        ////        addPanGesture(view: cell)
//        
//        
//        //REMOVENDO OS MARKER DO MAPA E PEGANDO O IDCAT, BUSCANDO NO BANCO COM ESSE IDESPECIFICO E POPULANDOARRAYPINS COM ESSES DADOS
//        self.mapView.removeAnnotations(CloserView.arrayDePins)
//        let IDCategoria: String = String(describing: arrayDeCategorias[indexPath.item].id!)
//        let info = LocaisDAO().retrievePlacesByIdPin(local: informacaoDosLocais, idPin: IDCategoria)
//        populandoArrayPins(informacaoDosLocais: info, IDCategoria: IDCategoria)
//    }
//    
//    
//    
//}
//
//
//extension CloserView: CLLocationManagerDelegate {
//    
//    //    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
//    //        if manager.activityType.rawValue == 10 {
//    //            self.setCurrentPin(localizacaoAtual: self.currentPositionCLLocationCoordinate2D!)
//    //            //            self.locationManager.activityType
//    //            self.locationManager.stopUpdatingLocation()
//    //        }
//    //
//    //    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.last else {return}
//        print("\nCurrent Location: \(location.coordinate)\n Latitude: \(location.coordinate.latitude) e Longitude: \(location.coordinate.longitude)")
//        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
//        //        mapView.setRegion(region, animated: true)
//        
//        self.currentPositionCLLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
//        self.currentPositionCLLocationCoordinate2D = center
//        
//        delayWithSeconds(0.5) {
//            self.mapView.setRegion(region, animated: true )
//            self.setCurrentPin(localizacaoAtual: center)
//            print("Velo: \(location.speed)")
//            //parando a atualização assim parando de instanciar varios pins a cada novo centro ....
//            self.locationManager.stopUpdatingLocation()
//        }
//    }
//    
//    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        checkLocationAutorization()
//    }
//    
//    //    @objc func goToRegisterMarker(sender: UILongPressGestureRecognizer) -> String {
//    //        if sender.state != UIGestureRecognizer.State.began {return""}
//    //        let touchLocation = sender.location(in: mapView)
//    //        print(touchLocation)
//    //        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
//    //        print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
//    //
//    //        return "\(locationCoordinate.latitude)+\(locationCoordinate.longitude)"
//    //    }
//    //}
//    
//    
//}
//
//
//extension CloserView: MKMapViewDelegate {
//    
//    //    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//    //        if annotation is Pino {
//    //            let annotationView = annotation as! Pino
//    //
//    //            var pinoView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationView.title!) as? MKMarkerAnnotationView
//    //            pinoView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotationView.title!)
//    //
//    //            pinoView?.annotation = annotationView
//    //            pinoView?.glyphImage = annotationView.icon
//    //            pinoView?.markerTintColor = annotationView.color
//    //
//    //            return pinoView
//    //        }
//    //        return nil
//    //    }
//    
//    
//    
//    //    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//    //        self.setInfoPin(coordenada: annotation.coordinate)
//    //
//    //
//    //        guard let annotation = annotation as? Pino else { return nil }
//    //
//    //        var markerView: MKMarkerAnnotationView
//    //
//    //        if let pinoView = mapView.dequeueReusableAnnotationView(withIdentifier: "marker") as? MarkerView {
//    //            pinoView.annotation = annotation
//    //            markerView = pinoView
//    //
//    //            //CONFIGURANDO O CALLOUTACESSORYVIEW
//    //            let imagem: UIImageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 100 , height: 100))
//    //
//    //            imagem.backgroundColor = .red
//    //            imagem.layer.cornerRadius = 50
//    //
//    //            let buttonToMenu: UIButton = UIButton(frame: CGRect(x: 5, y: 5, width: 50, height: 50))
//    //            buttonToMenu.setImage(UIImage(named: "save"), for: .normal)
//    //
//    //
//    //            //SETANDO O CALLOUTACESSORYVIEW DO MARKER
//    //            markerView.canShowCallout = true
//    //            markerView.calloutOffset = CGPoint(x: 5, y: 15)
//    //            markerView.rightCalloutAccessoryView = buttonToMenu
//    //            markerView.leftCalloutAccessoryView = imagem
//    //
//    //
//    //            //SETANDO O MARKER
//    //            markerView.glyphImage = annotation.icon
//    //            markerView.markerTintColor = annotation.color
//    //            markerView.glyphTintColor = .red
//    //
//    //            return markerView
//    //        }
//    //        return nil
//    //    }
//    
//    
//    
//    
//    
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        print("Annotation: \(String(describing:view.annotation?.title))")
//        
//        
//        //        view.addSubview(imageViewPin)
//        //        imageViewPin.snp.makeConstraints { (make) in
//        //            make.height.width.equalTo(150)
//        //            make.center.equalTo(view)
//        //        }
//        
//        //        view.addSubview(viewToPin)
//        //        viewToPin.snp.makeConstraints { (make) in
//        //            make.left.equalTo(view.snp.right).offset(0)
//        //            make.bottom.equalTo(view.snp.top).offset(0)
//        //            make.height.equalTo(100)
//        //            make.width.equalTo(200)
//        //        }
//        //
//        //        viewToPin.addSubview(labelInfoPin)
//        //        labelInfoPin.snp.makeConstraints { (make) in
//        //            make.height.equalTo(25)
//        //            make.left.top.equalToSuperview().offset(2)
//        //            make.right.equalToSuperview().offset(2)
//        //        }
//        //
//        //        viewToPin.addSubview(imageViewPin)
//        //        imageViewPin.snp.makeConstraints { (make) in
//        //            make.left.top.equalToSuperview().offset(2)
//        //            make.bottom.equalToSuperview().offset(-2)
//        //            make.width.equalTo(100)
//        //        }
//        
//        
//        self.setInfoPin(coordenada: view.annotation?.coordinate)
//        reloadInputViews()
//        mapView.reloadInputViews()
//        print("Cliquei no Pin ...")
//    }
//    
//    //    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
//    //        <#code#>
//    //    }
//    //    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
//    ////        mapView.annotations.removeAll()
//    //    }
//    
//    
//    
//    
//    
//    
//}
//
//extension CloserView : atualizaArrayPinsProtocol, pegaDistanciaEPosicaoProtocol {
//    
//    func populaArrayPins(arrayPins: [Pino]) {
//        CloserView.arrayDePins = arrayPins
//    }
//    
//    func pegaDistanciaEPosicao(distancia: CLLocationDistance, posicao: CLLocationCoordinate2D) {
//        CloserView.localSelecionado = posicao
//        CloserView.distanciaDaPosicaoAtual = distancia
//    }
//    
//}
//



