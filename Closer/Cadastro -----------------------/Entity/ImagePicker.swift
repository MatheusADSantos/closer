//
//  ImagePicker.swift
//  Closer
//
//  Created by macbook-estagio on 25/09/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import UIKit

enum menuOpcoes {
    case camera
    case biblioteca
}

protocol ImagePickerFotoSelecionadaProtocol {
    func imagePickerFotoSelecionada(foto : UIImage)
}

class ImagePicker : NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    var delegate : ImagePickerFotoSelecionadaProtocol?
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let foto = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        delegate?.imagePickerFotoSelecionada(foto: foto)
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    func menuDeOpcoes(completion: @escaping(_ opcao:menuOpcoes) -> Void) -> UIAlertController {
        let menu = UIAlertController(title: "ATENÇÃO", message: "Escolha uma das opções", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Tirar foto", style: .default) { (acao) in
            completion(.camera)
        }
        menu.addAction(camera)
        let biblioteca = UIAlertAction(title: "Biblioteca", style: .default) { (acao) in
            completion(.biblioteca)
        }
        menu.addAction(biblioteca)
        let cancelar = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
        menu.addAction(cancelar)
        
        return menu
    }
    
}
