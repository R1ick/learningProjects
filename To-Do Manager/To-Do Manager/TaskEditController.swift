//
//  TaskEditController.swift
//  To-Do Manager
//
//  Created by Ярослав Антонович on 29.10.2021.
//

import UIKit

class TaskEditController: UITableViewController {
    
    //параметры задачи
    var taskText: String = ""
    var taskType: TaskPriority = .normal
    var taskStatus: TaskStatus = .planned
    var doAfterEdit: ((String, TaskPriority, TaskStatus) -> Void)?
    //....
    @IBOutlet var taskTitle: UITextField!
    @IBOutlet var taskTypeLabel: UILabel!
    
    //название типов задач
    private var taskTitles: [TaskPriority: String] = [
        .important: "Важная",
        .normal: "Текущая"
    ]
    
    //переключатель статуса
    @IBOutlet var taskStatusSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //обновление текстового поля с названием задачи
        taskTitle?.text = taskText
        //обновление метки в соответствии текущим типом
        taskTypeLabel?.text = taskTitles[taskType]
        
        //обновляем статус задачи
        if taskStatus == .completed {
            taskStatusSwitch.isOn = true
        }
        
    }
    
    @IBAction func saveTask(_ sender: UIBarButtonItem) {
        //получаем актуальные значения
        let title = taskTitle?.text ?? ""
        if title.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            let alert = UIAlertController(
                title: "Error",
                message: "Название задачи не может быть пустым",
                preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            print("Empty")
        } else {
            print("Success")
            let type = taskType
            let status: TaskStatus = taskStatusSwitch.isOn ? .completed : .planned
            //вызываем обработчик
            doAfterEdit?(title, type, status)
        }
    
        
        
        //возвращаемся к предыдущему жкрану
        navigationController?.popViewController(animated: true)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toTaskTypeScreen" {
            //ссылка на контроллер назначения
            let destination = segue.destination as! TaskTypeController
            //передача выбранного типа
            destination.selectedType = taskType
            //передача обработчика выбора типа
            destination.doAfterTypeSelected = { [unowned self] selectedType in
                taskType = selectedType
                //обновляем метку с текущим типом
                taskTypeLabel?.text = taskTitles[taskType]
            }
        }
    }

}
