//
//  ResultTableViewController.swift
//  Cards
//
//  Created by Ярослав Антонович on 24.11.2021.
//

import UIKit
import CoreData


class ResultTableViewController: UITableViewController, UpdatingDataController {
    
    let storyboardInstance = UIStoryboard(name: "Main", bundle: nil)
    
    var result = [Result]()
    
    var person: [Some] = []
    
    var i = 0
    
    var updatingData = [Result(name: "", points: 0)]

    
    func saveTask(person: Result) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "Some", in: context)
        let personObject = NSManagedObject(entity: entity!, insertInto: context) as! Some
        personObject.userName = person.userName
        personObject.points = Int16(person.points)
        print(personObject)
        
        do {
            try context.save()
            self.person.append(personObject)
            print("Saved! Good Job")
        } catch {
            print(error.localizedDescription)
        }
    }
    
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

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let startScreen = self.storyboardInstance.instantiateViewController(withIdentifier: "startGame") as? StartViewController
        startScreen?.person = self.person
      
//        print("resultVC = \(self.updatingData[i - 1].userName ?? "somesome")")
        if i > 0 {
        self.result.append(self.updatingData[i - 1])
        print("В массиве во время загрузки сцены - \(self.updatingData.count)")
        self.saveTask(person: self.updatingData[i - 1])
        } 
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        
//        print("Количество элементов в итоговом массиве - \(result.count)")
        print("Core Data elements - \(person.count)")
//        tableView.reloadData()
        return person.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ResultTableViewCell
        cell.nameLabel.text = self.person[indexPath.row].userName
        cell.pointsLabel.text = String(self.person[indexPath.row].points)
        
        
        return cell
    }
    
  

}
