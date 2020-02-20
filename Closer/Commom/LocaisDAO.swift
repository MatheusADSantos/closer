//
//  LocaisDAO.swift
//  Closer
//
//  Created by macbook-estagio on 27/09/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//


import UIKit
import CoreData

//struct Pessoa {
//    var nome: String
//    var sobrenome: String
//    var idade: Int
//    var aniversario: String
//    var cargo: String
//    
//}
//
//func salvaPessoa() {
//   nome =  textFieldNome.text
//    sobrenome = textfieldSobremone.text
//    ....
//    
//    let pessoa = Pessoa(nome: nome, sobrenome: sobrew, idade: idade, aniversario: aniversario, cargo: cargo)
//    
//    PessoaDAO.save(pessoa)
//}
//var pessoas = [Pessoa]()


class LocaisDAO: NSObject  {
    //CONTEXTO e GERENCIADOR DE RESULTADOS
    var contexto:NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    var gerenciadorDeResultados:NSFetchedResultsController<Locais>?
    
    //SALVA  - CREATE
    func salvaLocais(dicionarioDeLocais:Dictionary<String,Any>, descricao: String, telefone: String, site: String, view: UIViewController) -> Bool {
        var local:NSManagedObject?
        let locais = retrievePlaces().first {$0.descricao == descricao}
        
        //VALIDANDO ...
        if (locais?.descricao != descricao) && (descricao != "") && (telefone != "") && (site != "") && dicionarioDeLocais.count == 7 {
            //criando a entidade
            print("Salvando dados")
            let entidade = NSEntityDescription.entity(forEntityName: "Locais", in: contexto)
            local = NSManagedObject(entity: entidade!, insertInto: contexto)
            
            local?.setValue(dicionarioDeLocais["descricao"], forKey: "descricao")
            local?.setValue(dicionarioDeLocais["telefone"], forKey: "telefone")
            local?.setValue(dicionarioDeLocais["site"], forKey: "site")
            local?.setValue(dicionarioDeLocais["localLat"], forKey: "localLat")
            local?.setValue(dicionarioDeLocais["localLong"], forKey: "localLong")
            local?.setValue(dicionarioDeLocais["foto"], forKey: "foto")
            local?.setValue(dicionarioDeLocais["id"], forKey: "idCategoria")
            
            updateContext()
            return true
        } else {
            print("Já existe esta descrição cadastrada")
            
            if let alerta = Notificacoes().alertaDeCampoNaoPreenchido() {
                view.present(alerta, animated: true, completion: nil)
            }
            return false
        }
    }
    
    //SALVA  - CREATE
    func salvaPino(pin : Pino) -> Bool {
        print("Salvando PIN")
        var Pin:NSManagedObject?
        let entidade = NSEntityDescription.entity(forEntityName: "Locais", in: contexto)
        Pin = NSManagedObject(entity: entidade!, insertInto: contexto)
        
        Pin?.setValue(pin.title, forKey: "descricao")
        Pin?.setValue(pin.telefone, forKey: "telefone")
        Pin?.setValue(pin.site, forKey: "site")
        Pin?.setValue(pin.coordinate.latitude, forKey: "localLat")
        Pin?.setValue(pin.coordinate.longitude, forKey: "localLong")
        Pin?.setValue(pin.image?.PNGData, forKey: "foto")
        Pin?.setValue(pin.idCategoria, forKey: "idCategoria")
        
        updateContext()
        return true
    }
    
    //READ - RECUPERA
    func retrievePlaces() -> Array<Locais> {
        let pesquisaLugar:NSFetchRequest<Locais> = Locais.fetchRequest()
        let ordenaPorNome = NSSortDescriptor(key: "descricao", ascending: true)
        pesquisaLugar.sortDescriptors = [ordenaPorNome]
        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: pesquisaLugar, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try gerenciadorDeResultados?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        guard let listaDeLugares = gerenciadorDeResultados?.fetchedObjects else {return []}
        return listaDeLugares
    }
    
    //READ - RECUPERA EM CIMA DO SEARCHBAR
    func retrievePlaces(local : [Locais], searchText: String) -> Array<Locais> {
        var predicate : NSPredicate = NSPredicate()
        predicate = NSPredicate(format: "descricao contains[c] '\(searchText)'")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Locais")
        fetchRequest.predicate = predicate
        let ordenaPorNome = NSSortDescriptor(key: "descricao", ascending: true)
        fetchRequest.sortDescriptors = [ordenaPorNome]
        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Locais>
        do {
            try gerenciadorDeResultados?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        guard let listaDelugares = gerenciadorDeResultados?.fetchedObjects else {return []}
        return listaDelugares
    }
    
    //READ - RECUPERA EM CIMA DO IDPIN
    func retrievePlacesByIdPin(local : [Locais], idPin: String) -> Array<Locais> {
        var predicate : NSPredicate = NSPredicate()
        predicate = NSPredicate(format: "idCategoria contains[c] '\(idPin)'")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Locais")
        fetchRequest.predicate = predicate
        let ordenaPorNome = NSSortDescriptor(key: "descricao", ascending: true)
        fetchRequest.sortDescriptors = [ordenaPorNome]
        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Locais>
        do {
            try gerenciadorDeResultados?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        guard let listaDelugares = gerenciadorDeResultados?.fetchedObjects else {return []}
        return listaDelugares
    }
    
    
    
    //UPDATE - ATUALIZA
    func updateContext() {
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //DELETE - DELETA
    func deletePlace(local: Locais) {
        contexto.delete(local)
        updateContext()
    }
    
    
}
