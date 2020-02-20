//
//  CloserView.swift
//  Closer
//
//  Created by macbook-estagio on 18/09/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import UIKit
import SnapKit
import MapKit
import CoreLocation
import Lottie
import SafariServices

protocol atualizaArrayPinsProtocol {
    func populaArrayPins(arrayPins:[Pino])
}
protocol pegaDistanciaEPosicaoProtocol {
    func pegaDistanciaEPosicao(distancia:CLLocationDistance, posicao:CLLocationCoordinate2D)
}

class CloserView: UIViewController, CloserViewProtocol {
    
    var validando = false
    
    //MARK: Atributos
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 2000
    
    
    var arrayDePins: [Pino] = []
    var arrayDePinsDoBanco: [Locais] = []
    var arrayDeCategorias = [Categorias]()
    
    
//    let bancoDeCategorias: Categorias?
    fileprivate let cellId = "cellId"
    var categoriaSelecionada : Bool? = false
    var idCategoriaSelecionada: String?
    
    //para calcular a distancia entre os pins
    var currentPositionCLLocation: CLLocation?
    //para setar o pin da posicao atual
    var currentPositionCLLocationCoordinate2D: CLLocationCoordinate2D?
    
    static var localSelecionado:CLLocationCoordinate2D? // só para verifica se busca no banco todo ou nao
    static var distanciaDaPosicaoAtual:CLLocationDistance?
    
    var presenter:CloserPresenterProtocol?
    var delegateAtualizaArrayPins : atualizaArrayPinsProtocol?
    var delegatePegaPosicaoEDistanciaDePin : pegaDistanciaEPosicaoProtocol?
    
    static var buscarNoBanco : String?
    static var localSelecionadoLat : Double?
    static var localSelecionadoLong : Double?
    static var image: UIImage?
    var fileViewOrigin: CGPoint!
    var frameAtualValidoDaCategoria: Double!
    var highlightIndexPathItem: Int?
    
    //MARK: - LOADVIEW()
    //TUDO QUANTO FOR INFORMAÇÃO DO TIPO CHAMAR OS DELEGATES E REGISTRAR CÉLULAS POR EX ... FAZ-SE AQUI.
    override func loadView() {
        super.loadView()
        
        collectionViewCategoryInMap.reloadData()
        mapView.reloadInputViews()
        
        mapView.delegate = self
        mapView.register(CustomMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        collectionViewCategoryInMap.delegate = self
        collectionViewCategoryInMap.dataSource = self
        collectionViewCategoryInMap.register(CollectionViewCategorysInMap.self, forCellWithReuseIdentifier: cellId)
    }
    
    //MARK: - Cycles Life
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardTapped()
        
        let navBarHeight = UIApplication.shared.statusBarFrame.size.height + (navigationController?.navigationBar.frame.height ?? 0.0)
        print("Height NavBar: ", navBarHeight)
        
        CloserWireFrame.createCloserModule(closerViewRef: self)
        presenter?.viewDidLoad()
        
//        loadData()
        loadCategorysDefault()
        loadPins()
        
        self.navigationController?.isNavigationBarHidden = false
        navigationItem.title = "Mapa"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(handleSignOut))
    }
    
    @objc func handleSignOut() {
        UserDefaults.standard.setIsLoggedIn(value: false)
        let loginController = LoginController()
//        presenter(loginController, animated: true, completion: nil)
        navigationController?.pushViewController(loginController, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
//        loadData()
        loadCategorysDefault()
        loadPins()
    }
    
    //MARK: - Componente MAPA
    lazy var mapView : MKMapView = {
        let view = MKMapView()
        view.isZoomEnabled = true // default true
        view.isRotateEnabled = false // default true
        view.isScrollEnabled = true // default true
        view.showsCompass = true // default true
        view.showsPointsOfInterest = true  //default true
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(goToRegisterMarker(sender:)))
        longPress.minimumPressDuration = 1
        view.addGestureRecognizer(longPress)
        return view
    }()
    let animationLongPress : AnimationView = {
        let animation = AnimationView()
        animation.animation = Animation.named("480-micro-interaction-touch-app-animation")
        animation.loopMode = .loop
        animation.animationSpeed = 0.7
        animation.play()
        animation.clipsToBounds = false
        return animation
    }()
//    lazy var labelOrigem : UILabel = {
//        let label = UILabel()
//        label.layer.cornerRadius = 25
//        label.layer.borderWidth = 1
//        label.layer.borderColor = UIColor.black.cgColor
//        label.layer.masksToBounds = true
//        //            let posicaoAtual = "\(self.mapView.userLocation.isUpdating)"
//        let numeroDePins = "\(arrayDePinsDoBanco.count)"
//        label.textColor = .white
//        label.setBasicLabel(text: " Pins Cadastrados: \(numeroDePins)", textColor: .white, font: 30, backgroundColor: UIColor().hexaToColor(hex: "dbc9ac"), textAlignment: .left)
//        return label
//    }()
    var collectionViewCategoryInMap : UICollectionView = {
        let widthScreen = UIScreen.main.bounds.width
        let heigthComponent = CGFloat.heigthComponent
        let left = (widthScreen - (9*heigthComponent))/2
        print("widthScreen", widthScreen, "heigthComponent", heigthComponent, "left", left)
        
        let raio = CGFloat.heigthComponent/2
        let widthCollectionView = (UIScreen.main.bounds.width-(2*CGFloat.margin))
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: heigthComponent, height: heigthComponent)
        layout.minimumLineSpacing = heigthComponent
        layout.sectionInset = UIEdgeInsets(top: 0, left: left, bottom: 0, right: 0)
        
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: layout)
        collection.layer.cornerRadius = raio
        collection.backgroundColor = .clear
        
        return collection
    }()
//    lazy var buttonCloser : UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(named: "mira"), for: .normal)
//        button.layer.cornerRadius = CGFloat.heigthComponent/2
//        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
//        button.backgroundColor = .white
//        button.setShadow(alpha: 1, offSetX: 1, offSetY: 1, shadowOpacity: 1, shadowRadius: 2, boolean: true)
//        button.addTarget(self, action: #selector(closer), for: .touchUpInside)
//        return button
//    }()
//    @objc func closer() {
//        print("CLOSERRRRR")
//        guard let highlightIndexPathItem = self.highlightIndexPathItem else {return}
//        buscaMaisProximo(highlightIndexPathItem: highlightIndexPathItem)
//    }
    
    
    lazy var buttonCloser : AnimatedButton = {
        let animation = AnimatedButton()
        animation.animation = Animation.named("navegar")
        animation.layer.cornerRadius = CGFloat.heigthComponent/2
//        animation.animationSpeed = 1.2
//        animation.play()
//        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        animation.backgroundColor = .white
//        animation.setShadow(alpha: 1, offSetX: 1, offSetY: 1, shadowOpacity: 1, shadowRadius: 2, boolean: true)
//        animation.setShadow(alpha: 0.7, offSetX: 2, offSetY: 2, shadowOpacity: 0.8, shadowRadius: 4, boolean: true)
//        animation.clipsToBounds = false
        animation.alpha = 0.5
        animation.isEnabled = false
        animation.addTarget(self, action: #selector(closer), for: .touchUpInside)
        return animation
    }()
    @objc func closer() {
        print("CLOSERRRRR")
        buttonCloser.setShadow(alpha: 1, offSetX: 1, offSetY: 1, shadowOpacity: 1, shadowRadius: 2, boolean: true)
        mapView.reloadInputViews()
        mapView.clearsContextBeforeDrawing = true
        guard let highlightIndexPathItem = self.highlightIndexPathItem else {return}
        buscaMaisProximo(highlightIndexPathItem: highlightIndexPathItem)
    }
    
    
    lazy var buttonToZoomToCurrentLocation : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "mira"), for: .normal)
        button.layer.cornerRadius = CGFloat.heigthComponent/2
        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        button.backgroundColor = .white
        button.setShadow(alpha: 1, offSetX: 1, offSetY: 1, shadowOpacity: 1, shadowRadius: 2, boolean: true)
        button.addTarget(self, action: #selector(focusesOnCurrentLocation), for: .touchUpInside)
        return button
    }()
    @objc func focusesOnCurrentLocation() {
        print("Foca na posição atual!!! ")
        locationManager.startUpdatingLocation()
    }
    lazy var viewToPin : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        
        return view
    }()
    lazy var labelInfoPin : UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 10
        return label
    }()
    lazy var imageViewPin : UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 75
        image.layer.masksToBounds = true
        return image
    }()
    lazy var buttonTrash: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "trash"), for: .normal)
        button.layer.cornerRadius = (CGFloat.heigthComponent*1.3)/2
        button.setShadow(alpha: 1, offSetX: 3, offSetY: 3, shadowOpacity: 1, shadowRadius: 3, boolean: true)
        button.backgroundColor = .clear
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        return button
    }()
    
    //MARK: - FUNÇÕES
    
    func loadPins() {
        arrayDeCategorias = CategoriasDAO().retrieveCategorys()
        arrayDePinsDoBanco = LocaisDAO().retrievePlaces()
        populandoArrayPins(arrayDePinsDoBanco: arrayDePinsDoBanco, IDCategoria: "")
        
        print("\nQUANTIDADE DE PINS CADASTRADOS NO BANCO: \(arrayDePinsDoBanco.count)")
        print("QUANTIDADE DE CATEGORIA CADASTRADAS NO BANCO: \(arrayDeCategorias.count)")
        print("DESCRICAO DAS CATEGORIAS CADASTRADAS NO BANCO: \(arrayDeCategorias.description)")
        print("QUANTIDADE DE PINS NO MAPA: \(arrayDePins.count)")
//        mapView.showAnnotations(arrayDePins, animated: true)
    }
    
    func loadCategorysDefault() {
        CategoriasDAO().salvaCategoriaDefault()
        arrayDeCategorias = CategoriasDAO().retrieveCategorys()
    }
    
    //REMOVENDO UM ITEM DA COLLETION
    func removeItemFromColletion(index: Int) {
        let categoriaSelecionada = arrayDeCategorias[index]
        guard let categoriaExcluida = categoriaSelecionada.descricao else {return}
        guard let idCategoria = categoriaSelecionada.id else {return}
        idCategoriaSelecionada = String(describing: idCategoria)
        print("idCategoriaSelecionada", idCategoriaSelecionada!)
        
        //Deletando do Banco e do Array de Categorias
        CategoriasDAO().deleteCategoria(categoria: categoriaSelecionada)
        arrayDeCategorias.remove(at: index)
        
        //Deletando da Collection
        let indexPath = IndexPath(row: index, section: 0)
        collectionViewCategoryInMap.performBatchUpdates({
            collectionViewCategoryInMap.deleteItems(at: [indexPath])
            
        }, completion: {
            (finished: Bool) in
            self.collectionViewCategoryInMap.reloadItems(at: self.collectionViewCategoryInMap.indexPathsForVisibleItems)
        })
        
        //Feed para o user que foi deletado um item da collection------------------------------
        print("\nFoi removido uma categoria da colletionView")
        if let alerta = Notificacoes().alertaDeItemRemovidoDaCollection(nomeDaCategoria: categoriaExcluida) {
            self.present(alerta, animated: true, completion: nil)
        }
        //Feed para o user que foi deletado um item da collection------------------------------
    }
    
    //MOVENDO UM ITEM DA COLLECTION
    func moveItemAtTo(indexAt: Int, indexTo: Int = 0) {
        let indexPathAt = IndexPath(row: indexAt, section: 0)
        let indexPathTo = IndexPath(row: indexTo, section: 0)
        collectionViewCategoryInMap.moveItem(at: indexPathAt, to: indexPathTo)
    }
    
    //ADD A PANGESTURE TO CATEGORY TO DELETE
    func addLongPressGesture(view: UIView) {
        let longPress = UILongPressGestureRecognizer(target: self, action:#selector(handleLongPress(sender:)))
        view.addGestureRecognizer(longPress)
    }
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            delayWithSeconds(0.7) {
                print("Frame da cell selecionada",sender.view!.frame.origin)
                self.fileViewOrigin = sender.view!.frame.origin
                self.addPanGesture(view: sender.view!)
                
                if let alerta = Notificacoes().alertaDeModoExclusaoDeCategoria() {
                    self.present(alerta, animated: true)
                }
            }
        }
    }
    
    
    func addPanGesture(view: UIView) {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan(sender:)))
        view.addGestureRecognizer(pan)
    }
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let fileView = sender.view!
        let translation = sender.translation(in: view)
    
        switch sender.state {
        case .began, .changed:
            self.collectionViewCategoryInMap.backgroundColor = .red
            self.buttonTrash.alpha = 1
            
            fileView.center = CGPoint(x: fileView.center.x + translation.x, y: fileView.center.y + translation.y )
            sender.setTranslation(CGPoint.zero, in: view)
            //------------------------QUANDO SOLTA A CATEGORIA------------------------
        case .ended:
            self.collectionViewCategoryInMap.backgroundColor = .clear
            self.buttonTrash.alpha = 0
            
            print("frame do buttonTrash \(buttonToZoomToCurrentLocation.frame)")
            print("frame da origem da cat \(fileView.frame)")
            print("CRUZOU", (fileView.frame.intersects(buttonTrash.frame)))
            
            //Validando o cruzamento
            let intervalo = 322.0..<5_000_000.0
            let xFrameCategoryDouble = Double(fileView.frame.origin.x)
            if intervalo.contains(xFrameCategoryDouble) {
                self.frameAtualValidoDaCategoria = xFrameCategoryDouble
            }
            let ref = CGRect(x: self.frameAtualValidoDaCategoria ?? 0.0, y: 6.0, width: 40.0, height: 40.0)
            
            //MARK: - Excluindo a categoria
            if fileView.frame.intersects(ref) {
                print("CRUZOU", (fileView.frame.intersects(ref)))
                print("chegou \(buttonTrash.frame.origin)")
                UIView.animate(withDuration: 0.3) {
                    
                    guard let highlightIndexPathItem = self.highlightIndexPathItem else { return }
                    let idCatSel = self.pegaDadosDeExclusao(id: true)
                    print("Categoria Selecionada: ", idCatSel)
                    
                    self.removeItemFromColletion(index: highlightIndexPathItem)
                    
                    self.removePinFromBank(by: idCatSel)
                    
                    self.loadPins()
                }
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    fileView.frame.origin = self.fileViewOrigin
                }) { (_) in
                    self.removeGestureRecognizer(view: fileView, collectionView: self.collectionViewCategoryInMap)
                }
            }
            break
            //------------------------QUANDO SOLTA A CATEGORIA------------------------
        default:
            break
        }
    }
    
    func removePinFromBank(by idCatSel: String) {
        arrayDePinsDoBanco = LocaisDAO().retrievePlaces()
        for pinCadastrado in arrayDePinsDoBanco {
            guard let idPinCadastrado = pinCadastrado.idCategoria else {return}
            if idPinCadastrado == idCatSel {
                LocaisDAO().deletePlace(local: pinCadastrado)
            }
        }
    }
    
    //PEGANDO DADOS IDCATSEL DESCCATSEL INDICEDACOLLECTION
    func pegaDadosDeExclusao(id: Bool) -> String  {
        guard let highlightIndexPathItem = self.highlightIndexPathItem else { return ""}
        if id {
            let idCatSel = String(describing: self.arrayDeCategorias[highlightIndexPathItem].id!)
            print("ÏD Categoria Selecionada: ", idCatSel)
            return idCatSel
        } else {
            let descricaoCatSel = String(describing: self.arrayDeCategorias[highlightIndexPathItem].descricao!)
            print("DESCRIÇÃO Categoria Selecionada: ", descricaoCatSel)
            return descricaoCatSel
        }
    }
    
    //EXCLUINDO OS GESTOS DE UMA VIEW...
    func removeGestureRecognizer(view: UIView, collectionView: UICollectionView){
        print("Excluindo os GESTOS...")
        for gestureRecognizer in view.gestureRecognizers ?? [] {
            view.removeGestureRecognizer(gestureRecognizer)
            collectionView.reloadData()
        }
    }
    
    //SETTING IMAGE FROM BANK CATEGORYS IN COLLECTION CELL
    func populandoArrayDeImagensCategorias() -> [UIImage]{
        var arrayImagesCategorias = [UIImage]()
        
        for cat in arrayDeCategorias {
            let pngImage = UIImage(data: cat.categoria!)
            arrayImagesCategorias.append(pngImage ?? (UIImage(named: "?")!))
        }
        return arrayImagesCategorias
    }
    
    //SETTING DATA FROM MARKERS IN VIEW
    func setInfoPin(coordenada: CLLocationCoordinate2D?) {
        for pin in arrayDePinsDoBanco {
            guard let foto = pin.foto else {return}
            guard let descricao = pin.descricao else {return}
            
            CloserView.image = foto as? UIImage
            
            let localLat = pin.localLat
            let localLong = pin.localLong
            if (localLat == coordenada?.latitude) && (localLong == coordenada?.longitude) {
                labelInfoPin.text = descricao
                imageViewPin.image = foto as? UIImage
            }
        }
    }
    
    //MARK: - POPULANDO O ARRAY DE PINS
    func populandoArrayPins(arrayDePinsDoBanco:[Locais], IDCategoria:String? = "") {
        print("Informações do banco de Pins: --> \(arrayDePinsDoBanco)")
        self.mapView.removeAnnotations(arrayDePins)
        arrayDePins = []
        for pin in arrayDePinsDoBanco {
            guard let descricao = pin.descricao else {return}
            guard let telefone = pin.telefone else {return}
            guard let site = pin.site else {return}
            guard let image = pin.foto else {return}
            guard let IDPin = pin.idCategoria else {return}
            print(IDPin, "&***&")
            var iconeDaCategoria: UIImage?
            let lat = pin.localLat
            let long = pin.localLong
            let locationTouch : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: long)
            var pino: Pino
            
            if IDCategoria != "" {
                for cat in arrayDeCategorias {
                    guard let IDCategoriaGeral = cat.id else {return}
                    let IDCategoriaGeral2 = String(describing: IDCategoriaGeral)
                    guard let IDMarker = pin.idCategoria else {return}
                    if IDMarker == IDCategoriaGeral2 {
                        iconeDaCategoria = UIImage(data: cat.categoria!)
                        pino = Pino(title: """
                            \(descricao)
                            \(telefone)
                            \(site)
                            """, telefone: telefone, site: site, coordinate: locationTouch, color: nil, icon: iconeDaCategoria, image: image as? UIImage, idCategoria: IDPin)
                        arrayDePins.append(pino)
                    }
                }
                //Apresento na tela somente os selecionados
                delegateAtualizaArrayPins?.populaArrayPins(arrayPins: arrayDePins)
                mapView.addAnnotations(arrayDePins)
                print("ANOTACOES ----> \(arrayDePins.count)")
                self.mapView.showAnnotations(arrayDePins, animated: true)
            } else {
                for cat in arrayDeCategorias {
                    guard let IDCategoriaGeral = cat.id else {return}
                    let IDCategoriaGeral2 = String(describing: IDCategoriaGeral)
                    if IDPin == IDCategoriaGeral2 {
                        iconeDaCategoria = UIImage(data: cat.categoria!)
                        pino = Pino(title: """
                            \(descricao)
                            \(telefone)
                            \(site)
                            """, telefone: telefone, site: site, coordinate: locationTouch, color: nil, icon: iconeDaCategoria, image: image as? UIImage, idCategoria: IDPin)
                        arrayDePins.append(pino)
                        delegateAtualizaArrayPins?.populaArrayPins(arrayPins: arrayDePins)
                        self.mapView.addAnnotation(pino)
                    }
                }
            }
        }
        //CHAMA O METODO DE ATUALIZAÇÃO DE LOCALIZAÇÃO ATUAL DO USUARIO
        locationManager.startUpdatingLocation()
        delayWithSeconds(1) {
            if let x = self.currentPositionCLLocationCoordinate2D {
                self.setCurrentPin(localizacaoAtual: x)
            }
            self.mapView.showAnnotations(self.arrayDePins, animated: true)
        }
        
    }
    
    //MARK: - LONGPRESS
    @objc func goToRegisterMarker(sender: UILongPressGestureRecognizer) {
//        print("\nTapped with Long Press!")
//        print("Number of longpress: \(sender.numberOfTouchesRequired)")
        if sender.state != (UIGestureRecognizer.State.began) {return}
        let touchLocation = sender.location(in: mapView)
        print("Cordinates of a Specific Point in the Map: \(touchLocation)")
        //pegando o localSelecionado para avisar qual retrieveData usar, se busca toda a lista que é o caso de quando se inicia a tela pela primeira vez(viewDidLoad) ou somente a que acabou de cadastrar quando o app já foi carregado ...
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        print("Tapped at coordinate: \(locationCoordinate) \nlat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
        CloserView.localSelecionado = locationCoordinate
        //Pegando a lat/long para setar no banco ...
        CloserView.localSelecionadoLat = locationCoordinate.latitude
        CloserView.localSelecionadoLong = locationCoordinate.longitude
        
        //pegando a distanciaDaOrigem
        let newPosition : CLLocation = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        guard let distancia = currentPositionCLLocation?.distance(from: newPosition) else {return}
        CloserView.distanciaDaPosicaoAtual = distancia
        
        delegatePegaPosicaoEDistanciaDePin?.pegaDistanciaEPosicao(distancia: distancia , posicao: locationCoordinate)
        presenter?.callViewController(viewRef: self)
    }
    

    
    
    func buscaMaisProximo(highlightIndexPathItem: Int) -> String {
        var menorDistancia: Double = 1000000000000000.0
        var descricaoMenorDistancia: String?

        let idCatSel = String(describing: self.arrayDeCategorias[highlightIndexPathItem].id!)
        print("ÏD Categoria Selecionada: ", idCatSel)

        for i in arrayDePinsDoBanco {
            if i.idCategoria == idCatSel {
                
                let newPosition : CLLocation = CLLocation(latitude: i.localLat, longitude: i.localLong)
                guard let distancia = currentPositionCLLocation?.distance(from: newPosition) else {return ""}
                guard let descricao = i.descricao else {return ""}
                let dist = (distancia/1000).truncate(places: 2)
                print("\nDescrição: \(String(describing: descricao))", "\nDistancia: ", dist, "Km")
                
                if dist < menorDistancia {
                    menorDistancia = dist
                    descricaoMenorDistancia = descricao
                }
            }
        }
        
        guard let pin = descricaoMenorDistancia else {return ""}
        print("\n\nO pin mais próximo é: ", pin, "<<<<<<<<<<<<")
        
        tracaRota(ate: pin, distancia: menorDistancia)
        
        return pin
    }
    
    func tracaRota(ate pinMaisProximo: String, distancia: Double) {
        
        for i in arrayDePinsDoBanco {
            guard let descricao = i.descricao else {return}
            if descricao == pinMaisProximo {
                
                guard let mePlaceMark2D = currentPositionCLLocationCoordinate2D else {return}
                let destinationPlaceMark2D = CLLocationCoordinate2D(latitude: i.localLat as CLLocationDegrees, longitude: i.localLong as CLLocationDegrees)
                
                let sourcePlaceMark = MKPlacemark(coordinate: mePlaceMark2D)
                let destinationPlaceMark = MKPlacemark(coordinate: destinationPlaceMark2D)
                
                let directionRequest = MKDirections.Request()
                directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
                directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
                directionRequest.transportType = .automobile
                
                let directions = MKDirections(request: directionRequest)
                directions.calculate { (response, error) in
                    guard let directionResponse = response else {
                        if let error = error {
                            print("Não estamos conseguindo gerar a rota\nERRO==\(error.localizedDescription)")
                        }
                        return
                    }
                    let route  =  directionResponse.routes[0]
                    self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                    let rect = route.polyline.boundingMapRect
                    self.mapView.setRegion(MKCoordinateRegion.init(rect), animated: true)
                }
            }
        }
    }
    
    func setCurrentPin(localizacaoAtual: CLLocationCoordinate2D) {
        let currentPino = Pino(title: "Eu", telefone: "981015281", site: "www.youtube.com", coordinate: self.currentPositionCLLocationCoordinate2D!, color: .black, icon: UIImage(named: "man-user"), image: nil, idCategoria: nil)
        self.mapView.addAnnotation(currentPino)
        arrayDePins.append(currentPino)
    }
    
    //MARK: - COMPONENTES CARREGANDO
    func loadViews() {
        print("Carregou as views")
        view.addSubviews(viewsToAdd: mapView, animationLongPress, collectionViewCategoryInMap, buttonToZoomToCurrentLocation, buttonTrash, buttonCloser)
        
        mapView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
//            make.left.right.bottom.equalToSuperview()
            guard let heightNavBar = (navigationController?.navigationBar.frame.height) else {return}
            make.top.equalToSuperview().offset(heightNavBar*2)
        }
        animationLongPress.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-CGFloat.margin)
            make.top.equalToSuperview().offset(CGFloat.margin*3)
            make.height.width.equalTo(CGFloat.heigthComponent*4)
        }
        collectionViewCategoryInMap.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-2*CGFloat.margin)
            make.height.equalTo(CGFloat.heigthComponent*1.3)
        }
        buttonToZoomToCurrentLocation.snp.makeConstraints { (make) in
            make.height.width.equalTo(CGFloat.heigthComponent)
            make.right.equalToSuperview().offset(-CGFloat.margin)
            make.bottom.equalTo(collectionViewCategoryInMap.snp.top).offset(-CGFloat.margin)
        }
        buttonTrash.snp.makeConstraints { (make) in
            make.right.top.equalTo(collectionViewCategoryInMap)
            make.height.width.equalTo(CGFloat.heigthComponent*1.3)
        }
        buttonCloser.snp.makeConstraints { (make) in
            make.bottom.equalTo(buttonToZoomToCurrentLocation.snp.top).offset(-20)
            make.right.equalTo(buttonToZoomToCurrentLocation)
            make.width.height.equalTo(CGFloat.heigthComponent)
        }
    }
    
    //MARK: - Mostrando minha localização Atual
    func showMyLocation() {
        print("Mostrando minha localização")
        checkLocationServices()
    }
    
    //MARK: - Configurações Adicionais
    func additionalConfiguration() {
        let navigation = navigationController
        navigation?.isNavigationBarHidden = true
        buttonTrash.alpha = 0
        buttonCloser.alpha = 0.5
        buttonCloser.isEnabled = false
    }
    
    //MARK: - Configurações do CHECKLOCATIONSERVICES()
    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            //setup our locationManager
            setupLocationManager()
            checkLocationAutorization()
        } else {
            //Show Alert letting the user know they have turn this on
        }
    }
    
    func checkLocationAutorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            //Do map stuff
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            locationManager.stopUpdatingLocation()
            break
        case .denied:
            //Show Alert instructing them how to turn on permissions
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //Show an alert letting them know what`s up
            break
        case .authorizedAlways:
            break
        default:
            break
        }
    }
}

//MARK: - DELEGATES DA COLLECTION
extension CloserView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        print("highlight IndexPath.item --->>>",indexPath.item)
        highlightIndexPathItem = indexPath.item
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.arrayDeCategorias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as!  CollectionViewCategorysInMap
        //        cell.buttonCategorias.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        cell.backgroundColor = .white
        cell.layer.cornerRadius = CGFloat.heigthComponent/2
        cell.setShadow(alpha: 1, offSetX: -2, offSetY: 2, shadowOpacity: 1, shadowRadius: 1, boolean: true)
        
        //Se for usar um button------------------------------------
//        cell.buttonCategorias.setImage(arrayImagesCategorias[indexPath.item], for: .normal)
        
        //Se for usar uma UIImageView------------------------------
        let arrayImagesCategorias = populandoArrayDeImagensCategorias()
        let image = arrayImagesCategorias[indexPath.item]
        cell.buttonCategorias.image = image.imageWithInsets(insetDimen: 25)
        
        collectionView.backgroundColor = .clear
        
        addLongPressGesture(view: cell)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        buttonCloser.alpha = 1
        buttonCloser.isEnabled = true
        
        //REMOVENDO OS MARKER DO MAPA E PEGANDO O IDCAT, BUSCANDO NO BANCO COM ESSE IDESPECIFICO E POPULANDOARRAYPINS COM ESSES DADOS
        self.mapView.removeAnnotations(arrayDePins)
        let IDCategoria: String = String(describing: arrayDeCategorias[indexPath.item].id!)
        let info = LocaisDAO().retrievePlacesByIdPin(local: arrayDePinsDoBanco, idPin: IDCategoria)
        populandoArrayPins(arrayDePinsDoBanco: info, IDCategoria: IDCategoria)
    }
    
}

extension CloserView: CLLocationManagerDelegate {
    
    //CRIANDO O DICIONARIO PARA USAR NA HORA DE SALVAR NO BANCO
    func getDictionary() -> [String:Any]{
        //pegando os dados a serem salvos
        let descricao = "EU"
        let telefone = "981015201"
        let site = "www.youtube.com.br"
        let foto = UIImage(named: "?")
        let id = ""
        
        //populando o array (parametro para salvar)
        let dicionario = ["descricao": descricao, "telefone": telefone, "site": site, "foto": foto!, "id": id,
                          "localLat": CloserView.localSelecionadoLat!, "localLong": CloserView.localSelecionadoLong!] as [String : Any]
        return dicionario
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        print("\nCurrent Location: \(location.coordinate)\n Latitude: \(location.coordinate.latitude) e Longitude: \(location.coordinate.longitude)")
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        //        mapView.setRegion(region, animated: true)
        
        self.currentPositionCLLocation = CLLocation(latitude: center.latitude, longitude: center.longitude)
        self.currentPositionCLLocationCoordinate2D = center
        
        locationManager.stopUpdatingLocation()
        setCurrentPin(localizacaoAtual: center)
        mapView.setRegion(region, animated: true)
//        locationManager.stopUpdatingLocation()
        mapView.showAnnotations(arrayDePins, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAutorization()
    }
}

extension CloserView: MKMapViewDelegate {
    //MARK: - Selecionando um ponto no Mapa ....
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Annotation: \(String(describing:view.annotation?.title))")
        self.setInfoPin(coordenada: view.annotation?.coordinate)
        reloadInputViews()
        mapView.reloadInputViews()
        print("Cliquei no Pin ...")
    }
    //MARK: - Renderizando Rota ....
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 4.0
        return renderer
    }
    
    
    
}

extension CloserView : atualizaArrayPinsProtocol, pegaDistanciaEPosicaoProtocol {
    func populaArrayPins(arrayPins: [Pino]) {
        arrayDePins = arrayPins
    }
    func pegaDistanciaEPosicao(distancia: CLLocationDistance, posicao: CLLocationCoordinate2D) {
        CloserView.localSelecionado = posicao
        CloserView.distanciaDaPosicaoAtual = distancia
    }
}
