//
//  CategoriasDAO.swift
//  Closer
//
//  Created by macbook-estagio on 16/10/19.
//  Copyright © 2019 macbook-estagio. All rights reserved.
//

import UIKit
import CoreData

class CategoriasDAO: NSObject  {
    //CONTEXTO e GERENCIADOR DE RESULTADOS
    var contexto:NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    var gerenciadorDeResultados:NSFetchedResultsController<Categorias>?
    
    //MARK: - CREATE
    //SALVA CATEGORIAS DEFAULT
    func salvaCategoriaDefault() {
        let descricao = ["Mercado","Dentista","Shopping","Rodoviária","Cinema"]
        let nomeDaImagem = ["carinho","teeth","shopping-cart","bus","film"]
        var i = 0
        print("Salvando Primeiras Categorias no Banco...")
        repeat {
            let desc = descricao[i]
            let ima = (UIImage(named: nomeDaImagem[i])?.PNGData)!
            self.salvaCategoria(descricao: desc, categoria: ima, viewRef: nil)
            i = i + 1
        } while(i < 5)
    }
    //SALVA AS PROXIMAS CATEGORIAS
    func salvaCategoria(descricao: String, categoria: Data, viewRef: UIViewController?) -> Bool {
        var Categoria:NSManagedObject?
        let categoriasDescricao = retrieveCategorys().first {$0.descricao == descricao}
        let categoriasImagem = retrieveCategorysByImage().first {$0.categoria == categoria}
        
        if (categoriasDescricao?.descricao != descricao && categoriasImagem?.categoria != categoria) {
            //criando a entidade
            print("Salvando Categorias no Banco...")
            let entidade = NSEntityDescription.entity(forEntityName: "Categorias", in: contexto)
            Categoria = NSManagedObject(entity: entidade!, insertInto: contexto)
            
            Categoria?.setValue(descricao, forKey: "descricao")
            Categoria?.setValue(categoria, forKey: "categoria")
            //Antes de salvar o id, tenho que criar um ...
            let uuid = UUID().uuidString
            let id : UUID = UUID(uuidString: uuid)!
            Categoria?.setValue(id, forKey: "id")
            
            updateContext()
            return true
        } else {
            print("Já existe esta descrição ou categoria(imagem) cadastrada")
            let categoriasDescricao = retrieveCategorys().first {$0.descricao == descricao}
            if (categoriasDescricao?.descricao == descricao) {
                if let alerta = Notificacoes().alertaDeCategoriaJaCadastrada(data: descricao) {
                    guard let viewRef = viewRef else {return false}
                    viewRef.present(alerta, animated: true, completion: nil)
                }
            } else {
                if let alerta = Notificacoes().alertaDeCategoriaJaCadastrada() {
                    guard let viewRef = viewRef else {return false}
                    viewRef.present(alerta, animated: true, completion: nil)
                }
            }
            return false
        }
    }
    
    //MARK: - READ - RECUPERA
    func retrieveCategorys() -> Array<Categorias> {
        let pesquisaCategoria:NSFetchRequest<Categorias> = Categorias.fetchRequest()
        let ordenaPorNome = NSSortDescriptor(key: "descricao", ascending: true)
        pesquisaCategoria.sortDescriptors = [ordenaPorNome]
        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: pesquisaCategoria, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try gerenciadorDeResultados?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        guard let listaDeCategorias = gerenciadorDeResultados?.fetchedObjects else {return []}
        return listaDeCategorias
    }
    
    func retrieveCategorysByImage() -> Array<Categorias> {
        let pesquisaCategoria:NSFetchRequest<Categorias> = Categorias.fetchRequest()
        let ordenaPorNome = NSSortDescriptor(key: "categoria", ascending: true)
        pesquisaCategoria.sortDescriptors = [ordenaPorNome]
        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: pesquisaCategoria, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try gerenciadorDeResultados?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        guard let listaDeCategorias = gerenciadorDeResultados?.fetchedObjects else {return []}
        return listaDeCategorias
    }
    
    
    func retrieveCategorysByID(categoria: [Categorias], idCat: String) -> Array<Categorias> {
        var predicate : NSPredicate = NSPredicate()
        predicate = NSPredicate(format: "id contains[c] '\(idCat)'")
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Categorias")
        fetchRequest.predicate = predicate
        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Categorias>
        do {
            try gerenciadorDeResultados?.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        guard let listaDeCategorias = gerenciadorDeResultados?.fetchedObjects else {return []}
        return listaDeCategorias
    }
    
//    //READ - RECUPERA EM CIMA DO SEARCHBAR
//    func retrievePlaces(local : [Locais], searchText: String) -> Array<Locais> {
//        var predicate : NSPredicate = NSPredicate()
//        predicate = NSPredicate(format: "descricao contains[c] '\(searchText)'")
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Locais")
//        fetchRequest.predicate = predicate
//        let ordenaPorNome = NSSortDescriptor(key: "descricao", ascending: true)
//        fetchRequest.sortDescriptors = [ordenaPorNome]
//        gerenciadorDeResultados = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil) as? NSFetchedResultsController<Locais>
//        do {
//            try gerenciadorDeResultados?.performFetch()
//        } catch {
//            print(error.localizedDescription)
//        }
//        guard let listaDelugares = gerenciadorDeResultados?.fetchedObjects else {return []}
//        return listaDelugares
//    }
    
    
    //MARK: - UPDATE - ATUALIZA
    func updateContext() {
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - DELETE - DELETA
    func deleteCategoria(categoria: Categorias) {
        contexto.delete(categoria)
        updateContext()
    }
    
    
}
