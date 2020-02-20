//
//  Notificacoes.swift
//  Closer
//
//  Created by macbook-estagio on 11/10/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import Foundation
import UIKit
import SafariServices

final class Notificacoes : NSObject {
    
    
    
    func alertaDeLoginErrado() -> UIAlertController? {
        let alerta = UIAlertController(title: "ATENÇÃO!!!", message: "Email e/ou Senha Incorreta, Tente novamente! ", preferredStyle: .alert)
        let botaoOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alerta.addAction(botaoOk)
        return alerta
    }
    
    
    
    
    func alertaDeCategoriaJaCadastrada(data: String? = "Imagem") -> UIAlertController? {
        
        if data != "Imagem"{
            let alerta = UIAlertController(title: "ATENÇÃO!!!", message: "Categoria \(data!.uppercased()) já está Cadastrada\nEscolha outra!", preferredStyle: .alert)
            let botaoOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alerta.addAction(botaoOk)
            return alerta
        } else {
            let alerta = UIAlertController(title: "ATENÇÃO!!!", message: "\(data!) Já Cadastrada\nEscolha outra.", preferredStyle: .alert)
            let botaoOk = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alerta.addAction(botaoOk)
            return alerta
        }
        
        
        
    }
    
    func makeAPhoneCall()  {
        let url: NSURL = URL(string: "TEL://14998619461")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }
    
    func dialNumber(number : String) {
     if let url = URL(string: "tel://\(number)"),
       UIApplication.shared.canOpenURL(url) {
          if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:], completionHandler:nil)
           } else {
               UIApplication.shared.openURL(url)
           }
       } else {
        print("erro")
       }
    }
    
    func mostraMenuDeOpcoes(telefone: String, site: String) -> UIAlertController? {
        let menu = UIAlertController(title: "ATENÇÃO!", message: """
                                    Entre em Contato!!!
                                    """, preferredStyle: .actionSheet)
        let botaoTelefone = UIAlertAction(title: "Telefone", style: .default) { (make) in
            
            
            print("consegui o telefone: \(telefone)")
//            "phone:+55(14)998619461!".makeACall()
//            "phone:+1(14)99861-9461!".makeACall()
            "phone:+1(617)111-22-33!".makeACall()
            self.dialNumber(number: "14998619461")
            self.makeAPhoneCall()
        }
        print("consegui o telefone:",telefone)
        //IMPLEMENTAÇÃO DE  LIGAR PARA O CELULAR DO LUGAR/PESSOA....
        
        menu.addAction(botaoTelefone)
        let botaoSite = UIAlertAction(title: "Site", style: .default) { (make) in
            print("consegui o site:", site)
            Safari().abrePaginaWeb(site: site)
        }
        menu.addAction(botaoSite)
        let botaoSair = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        menu.addAction(botaoSair)
        return menu
    }


    func alertaDeItemRemovidoDaCollection(nomeDaCategoria: String) -> UIAlertController? {
        let alerta = UIAlertController(title: "ATENÇÃO!!!", message: "Você Acabou de Remover a Categoria:\n \(nomeDaCategoria.uppercased())", preferredStyle: .alert)
        let botaoOk = UIAlertAction(title: "OK", style: .default) { (action) in
            if action.isEnabled == true {
                print("Só testando a condição...")
            }
        }
        alerta.addAction(botaoOk)
        return alerta
    }
    
    func alertaDeModoExclusaoDeCategoria() -> UIAlertController? {
        let alerta = UIAlertController(title: "ATENÇÃO!!!", message: "Você Acaba de ativar o modo de Exclusão de Categoria", preferredStyle: .alert)
        let botaoOk = UIAlertAction(title: "OK", style: .default) { (action) in
            if action.isEnabled == true {
                print("Só testando a condição...")
            }
        }
        alerta.addAction(botaoOk)
        return alerta
    }
    
    func alertaDeCampoNaoPreenchido(/*foto: UIImage, descricao: String, telefone: String, site: String, categoria: String*/) -> UIAlertController? {
        let alerta = UIAlertController(title: "ATENÇÃO!!!", message: "Você Precisa Preencher todos os Campos", preferredStyle: .alert)
        let botaoOk = UIAlertAction(title: "OK", style: .default) { (action) in
            if action.isEnabled == true {
                print("Só testando a condição...")
            }
        }
        alerta.addAction(botaoOk)
        return alerta
    }
    
    
}
