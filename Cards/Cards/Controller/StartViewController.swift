//
//  StartViewController.swift
//  Cards
//
//  Created by Ярослав Антонович on 04.11.2021.
//

import UIKit
import CoreData

protocol UpdatingDataController: AnyObject {
    var updatingData: [Result] { get set }
    var i: Int { get set }
}

class StartViewController: UIViewController {
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resultButton: UIButton!
    @IBOutlet weak var preferencesButton: UIButton!
    
    var person: [Some] = []
    
    var result = [Result]()
    
    var i = 0
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Some> = Some.fetchRequest()
        
        do {
            person = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
        print(person.count)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        startButton.layer.cornerRadius = 20
        resultButton.layer.cornerRadius = 20
        preferencesButton.layer.cornerRadius = 20
        // Do any additional setup after loading the view.
    }
    
    let storyboardInstance = UIStoryboard(name: "Main", bundle: nil)
    let storyboardIs = UIStoryboard(name: "Main", bundle: nil)
    
    @IBAction func toCardGameScene(_ sender: UIButton) {
        
        
        guard let gameScreen = self.storyboardInstance.instantiateViewController(withIdentifier: "gameScene") as? BoardGameController else { return }
        
//        guard let resultScreen = self.storyboardIs.instantiateViewController(withIdentifier: "resultTable") as? ResultTableViewController else { return }
        
        
        let alert = UIAlertController(title: "Привет!", message: "Представьтесь пожалуйста", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Ваше имя"
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            
            guard let userName = alert.textFields?[0].text else { return }
            if userName == "" {
                let ac = UIAlertController(title: "Ошибка", message: "Введите имя!", preferredStyle: .alert)
                let ok = UIAlertAction(title: "OK", style: .cancel, handler: { _ in
                    self.present(alert, animated: true)
                })
                ac.addAction(ok)
                self.present(ac, animated: true)
                
            } else {
            self.result.append(Result(name: userName))
            self.i = self.result.count
//            print("points - \(self.result[self.i - 1].points)")
            if self.i >= 2 {
                print("Первое имя: \(self.result[self.i - 1].userName ?? "some name"), второе имя: \(self.result[self.i - 2].userName ?? "some name")")
            }
//            print("name = \(self.result[self.i - 1].userName ?? "some name")")
//            resultScreen.i = self.i
            gameScreen.i = self.i
//            gameScreen.updatingData = [Result(name: userName)]
            gameScreen.updatingData = self.result
            
         
            self.navigationController?.pushViewController(gameScreen, animated: true)
            }
            
        }
        alert.addAction(okAction)
        self.present(alert, animated: true)
        
    }
    
    @IBAction func toResultScene(_ sender: Any) {
        
        guard let resultScene = self.storyboardInstance.instantiateViewController(withIdentifier: "resultTable") as? ResultTableViewController else { return }
        print("person count - \(person.count)")
        if person.count <= 0 {
            let alert = UIAlertController(title: "Внимание", message: "Результаты пусты", preferredStyle: .actionSheet)
            let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true)
        } else {
            self.navigationController?.pushViewController(resultScene, animated: true)
        }
    }
    
    @IBAction func toPrefScene(_ sender: UIButton) {
//
//        guard let prefScene = self.storyboardInstance.instantiateViewController(withIdentifier: "preferencesScreen") as? PreferencesViewController else { return }
//
//
//        self.navigationController?.pushViewController(prefScene, animated: true)
    }
    
}

