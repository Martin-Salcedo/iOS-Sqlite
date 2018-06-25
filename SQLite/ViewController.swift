//
//  ViewController.swift
//  SQLite
//
//  Created by Jose Martin Salcedo Lazaro on 13/05/18.
//  Copyright © 2018 Jose Martin Salcedo Lazaro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  
  @IBOutlet weak var modelTxtSave: UITextField!
  
  @IBOutlet weak var priceTxtSave: UITextField!
  
  @IBOutlet weak var modelTxtSearch: UITextField!
  
  let objetoFileHelper = FileHelper()
  
  var dataBase:FMDatabase? = nil
  
  var alert: UIAlertController? = nil
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    dataBase = FMDatabase(path: objetoFileHelper.pathArchivoEnCarpetaDocumentos(nombreArchivo: "buscadorAutos"))
    modelTxtSearch.keyboardType = .asciiCapable
  }

  @IBAction func SaveCar(_ sender: UIButton) {
    if modelTxtSave.hasText && priceTxtSave.hasText {
      print("se guardaron")
      guardadoData(modelTxtSave.text!, priceTxtSave.text!)
    } else {
      print("no se guardo algun campo")
    }
  }
  
  @IBAction func SearchCar(_ sender: UIButton) {
    if modelTxtSearch.hasText {
      print("se puede buscar el modelo")
      iniciarBusqueda(modelTxtSearch.text!)
    } else {
      print("no se puede buscar")
    }
  }
  
  func guardadoData(_ modelo: String, _ price: String) {
    if (dataBase?.open())! {
      
      let foreingKey = "PRAGMA foreign_keys = ON"
      dataBase?.executeUpdate(foreingKey, withArgumentsIn: [])
      
      let insertQuerySQL = "INSERT INTO Information (model, price) VALUES('\(modelo)', '\(price)')"
      let resultUpdate = dataBase?.executeUpdate(insertQuerySQL, withArgumentsIn: [])
      if resultUpdate! {
        alert = UIAlertController(title: "Bienvenido", message: "Se guardo el value", preferredStyle: .alert)
        alert?.addAction(UIAlertAction(title: "Continuar", style: .cancel, handler: nil))
        present(alert!, animated: true){
          self.modelTxtSave.text = ""
          self.priceTxtSave.text = ""
        }
      } else {
        print("Error en insertar datos: \(dataBase!.lastErrorMessage())")
      }
    } else {
      print("no se pudo abrir la BD")
    }
  }
  
  func iniciarBusqueda(_ modelo: String) {
    
    var precio: Int32?
//   1-  iniciar busqueda
    if (dataBase?.open())! {
      print("si se pudo abrir")
//      crear el query
      let query = "SELECT price FROM Information WHERE model = '\(modelo)'"
//      crear variable que contiene los resultados y ejeutar la sentencia "query"
      let resultados:FMResultSet? = dataBase?.executeQuery(query, withArgumentsIn: [])
//      intinerar los resultados
      while resultados?.next() == true {
        precio = resultados!.int(forColumn: "price")
      }
//      cerrar la base de datos
      dataBase?.close()
      alert = UIAlertController(title: "Resultado", message: "El precio es \(precio!)", preferredStyle: .alert)
      alert?.addAction(UIAlertAction(title: "Cerrar", style: .cancel, handler: nil))
      present(alert!, animated: true) {
        self.modelTxtSearch.text = ""
      }
      print("el precio es \(precio!)")
      
    } else {
      print("no se pudo abrir la base de datos")
    }
  }
  
}

