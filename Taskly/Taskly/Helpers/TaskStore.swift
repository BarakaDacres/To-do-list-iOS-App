//
//  TaskStore.swift
//  Taskly
//
//  Created by Baraka Dacrés on 26/4/18.
//  Copyright © 2018 Baraka Dacrés. All rights reserved.
//

import Foundation

class TaskStore {
    
    var tasks = [[Task](), [Task]()]
    
    // add tasks
    func add( task: Task, at index: Int, isDone: Bool = false){
        
        let section = isDone ? 1 : 0
        
        tasks[section].insert(task, at: index)
    }
    
    // remove tasks
    @discardableResult func removeTask(at index: Int, isDone: Bool = false) -> Task {
        
        let section = isDone ? 1 : 0
        
        return tasks[section].remove(at: index)
    }
}
