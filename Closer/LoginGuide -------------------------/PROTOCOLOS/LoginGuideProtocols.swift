//
//  LoginGuideProtocols.swift
//  Closer
//
//  Created by macbook-estagio on 27/12/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import Foundation
import MapKit
import UIKit

protocol LoginGuideViewProtocol : class {
    //PRESENTER -> VIEW
}

protocol LoginGuideInputInteractorProtocol: class {
    var presenter: LoginGuideOutputInteractorProtocol? {get set}
    //PRESENTER -> INTERACTOR
}

protocol LoginGuideOutputInteractorProtocol: class {
    //INTERACTOR -> PRESENTER
}

protocol LoginGuidePresenterProtocol: class {
    //VIEW -> PRESENTER
    
    //O que vou carregar sem interação com o usuário ...
}

protocol LoginGuideWireFrameProtocol: class {
    //PRESENTE -> WIREFRAME
}




