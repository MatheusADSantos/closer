//
//  CadastroCategoriaProtocols.swift
//  Closer
//
//  Created by macbook-estagio on 14/10/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import Foundation
import UIKit


protocol CadastroCategoriaPresenterProtocol : class {
    var interactor: CadastroCategoriaInputInteractorProtocol? {get set}
    var wireframe: CadastroCategoriaWireFrameProtocol? {get set}
    var view: CadastroCategoriaViewProtocol? {get set}
    
    //VIEW -> PRESENTER
    func viewDidLoad()
    func registerCategory(categoria: CATEGORIA, viewRef: UIViewController)
}



protocol CadastroCategoriaViewProtocol : class {
    //PRESENTER  -> VIEW
    func loadViews()
}


protocol CadastroCategoriaWireFrameProtocol : class {
    //PRESENTER -> WIREFRAME
    static func createCadastroCategoriaModulo(viewRef: CadastroCategoriaView)
    func backToCadastroView(view: UIViewController)
}

protocol CadastroCategoriaInputInteractorProtocol : class {
    //PRESENTER -> INTERACTOR
    var presenter : CadastroCategoriaOutputInteractorProtocol? {get set}
    func registerCategoryInBank(categoria: CATEGORIA, viewRef: UIViewController)
}

protocol CadastroCategoriaOutputInteractorProtocol : class {
    //INTERECTOR -> PRESENTER
    func backToCadastroPin(viewRef: UIViewController)
}
