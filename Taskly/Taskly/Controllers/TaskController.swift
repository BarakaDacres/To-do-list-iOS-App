//
//  TaskController.swift
//  Taskly
//
//  Created by Baraka Dacrés on 25/4/18.
//  Copyright © 2018 Baraka Dacrés. All rights reserved.
//

import UIKit

class TasksController: UITableViewController {
    
    var taskStore : TaskStore! {
        didSet {
            // Get data
            taskStore.tasks = TaskUtility.fetch() ?? [[Task](), [Task]()]
        
            // Reload table
            tableView.reloadData()
        }
    }
    
   // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func addTask(_ sender: UIBarButtonItem) {
        
        // Setting up our alert controller
        let alertController = UIAlertController(title: "Add Task", message: nil , preferredStyle: .alert)
        
        // Setup the actions
        let addAction = UIAlertAction(title: "Add", style: .default){ _ in
            
            // Grab text field text
            guard let name = alertController.textFields?.first?.text else { return }
            
            // Create task
            let newTask = Task(name: name)
            
            // Add task
            self.taskStore.add(task: newTask, at: 0)
            
            // Reload data in tableview
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
            

        
        }
        addAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        // Add the text field
        alertController.addTextField { textField in
            
            textField.placeholder = "Enter task name..."
            textField.addTarget(self, action: #selector(self.handleTextChanged), for: .editingChanged)
        }
        
        // Add the actions
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        // Present alert controller
        present(alertController, animated: true)
    }
    
    @objc private func handleTextChanged( sender: UITextField){
        // Grab alert controller and add action
        
        guard let alertConroller = presentedViewController as? UIAlertController,
            let addAction = alertConroller.actions.first,
            let text = sender.text
            else  { return }
        
        // Enable add action based on if text is empty or contains white space
        addAction.isEnabled = !text.trimmingCharacters(in: .whitespaces).isEmpty
    
    }
}

// MARK: - DataSource

extension TasksController{
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return section == 0 ? "To-Do" : "Done"
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return taskStore.tasks.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskStore.tasks[section].count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = taskStore.tasks[indexPath.section][indexPath.row].name
        return cell
    }
}

// MARK: - Delegate
extension TasksController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { (action, sourceView, completionHandler) in
            
            // Determine wether task 'isDone'
            guard let isDone = self.taskStore.tasks[indexPath.section][indexPath.row].isDone else { return }
            
            // Remove task from appropriate array
            self.taskStore.removeTask(at: indexPath.row, isDone: isDone)
            
            // Reload table view
            tableView.deleteRows(at: [indexPath], with: .automatic)
            

            
            // Indicate that the action was performed
            completionHandler(true)
        }
        deleteAction.image = #imageLiteral(resourceName: "delete")
        deleteAction.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.1450980392, blue: 0.2470588235, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let doneAction = UIContextualAction(style: .normal, title: nil) { (action, sourceView, completionHandler) in
            
            // Toggle that task 'isDone'
            self.taskStore.tasks[0][indexPath.row].isDone = true
            
            // Remove task from array containing todo taks
            let doneTask = self.taskStore.removeTask(at: indexPath.row)
            
            // Reload table for to-do tasks
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            // Add the task from the array containing done tasks
            self.taskStore.add(task: doneTask, at: 0, isDone: true)
            
            // Reload table view
            tableView.insertRows(at: [IndexPath(row: 0, section: 1)], with: .automatic)
            
            
            // Indicate the action was performed
            completionHandler(true)
        }
        
        doneAction.image = #imageLiteral(resourceName: "done")
        doneAction.backgroundColor = #colorLiteral(red: 0.01176470588, green: 0.7529411765, blue: 0.2901960784, alpha: 1)
        return indexPath.section == 0 ? UISwipeActionsConfiguration(actions: [doneAction]) : nil
    }
}
