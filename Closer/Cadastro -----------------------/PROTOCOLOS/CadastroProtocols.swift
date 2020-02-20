//
//  CadastroProtocols.swift
//  Closer
//
//  Created by macbook-estagio on 20/09/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import Foundation
import UIKit

protocol CadastroPresenterProtocol : class {

    var interactor: CadastroInputInteractorProtocol? {get set}
    var wireframe: CadastroWireFrameProtocol? {get set}
    var view: CadastroViewProtocol? {get set}
    
    //VIEW -> PRESENTER
    func viewDidLoad()
    func acessCamera(viewController: UIViewController)
    func registerMarker(dictionary: [String : Any], descricao: String, telefone: String, site: String, view: UIViewController)
    
    func pushToCadastroCategoria(view: UIViewController)
}

protocol CadastroViewProtocol : class {
//    var view : CadastroViewProtocol? {get set}
//    var wireframe : CadastroWireFrameProtocol? {get set}
//    var presenter : CadastroPresenterProtocol? {get set}
    
    //PRESENTER  -> VIEW
    func loadViews()
    func showCamera(viewController: UIViewController)
}

protocol CadastroInputInteractorProtocol : class {
    //PRESENTER -> INTERECTOR
    var presenter:CadastroOutputInteractorProtocol? {get set}
    func registerMarkerToCoreData(dictionary: [String : Any], descricao: String, telefone: String, site: String, view: UIViewController)
//    func createCustomMarker()
//    func acessCamera(viewController: UIViewController)
}

protocol CadastroOutputInteractorProtocol : class {
    //INTERECTOR -> PRESENTER
    func getDataFromCoreData(view: UIViewController)
}

protocol CadastroWireFrameProtocol : class {
    //PRESENTER -> WIREFRAME
    //voltando ao mapa
    static func createCadastroModulo(viewRef: CadastroView)
    func pushToCloserView(view: UIViewController)
    
    //indo para tela de cadastro de categoria
    func pushToCadastroCategoria(view: UIViewController)
//    static func createCadastroCategoriaModule(closerViewRef: CadastroCategoriaView)
}
