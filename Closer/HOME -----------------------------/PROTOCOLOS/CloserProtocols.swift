//
//  CloserProtocols.swift
//  Closer
//
//  Created by macbook-estagio on 18/09/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import Foundation
import MapKit

protocol CloserViewProtocol : class {
    //PRESENTER -> VIEW
    func loadViews()
    func showMyLocation()
    func additionalConfiguration()
    
}

protocol CloserInputInteractorProtocol: class {
    var presenter: CloserOutputInteractorProtocol? {get set}
    //PRESENTER -> INTERACTOR
//    func getMyLocation()
}

protocol CloserOutputInteractorProtocol: class {
    //INTERACTOR -> PRESENTER
//    func fetchMyLocation()
}

protocol CloserPresenterProtocol: class {
    //VIEW -> PRESENTER
    var interactor: CloserInputInteractorProtocol? {get set}
    var view: CloserViewProtocol? {get set}
    var wireframe: CloserWireFrameProtocol? {get set}
    
    //O que vou carregar sem interação com o usuário ...
    func viewDidLoad()
    func callViewController(viewRef: UIViewController)
}

protocol CloserWireFrameProtocol: class {
    //PRESENTE -> WIREFRAME
    func pushToCadastroView(viewRef: UIViewController)
    static func createCloserModule(closerViewRef: CloserView)
}







