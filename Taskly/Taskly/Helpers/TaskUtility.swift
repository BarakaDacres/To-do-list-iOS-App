//
//  TaskUtility.swift
//  Taskly
//
//  Created by Baraka Dacrés on 26/4/18.
//  Copyright © 2018 Baraka Dacrés. All rights reserved.
//

import Foundation

class TaskUtility {
    
    private static let key = "tasks"
    
    // Archive
    private static func archive(_ tasks: [[Task]]) -> NSData {
        return NSKeyedArchiver.archivedData(withRootObject: tasks) as NSData
    }
    
    // Fetch
    static func fetch() -> [[Task]]? {
        guard let unarchivedData = UserDefaults.standard.object(forKey: key) as? Data else { return nil }
        
        return NSKeyedUnarchiver.unarchiveObject(with: unarchivedData) as? [[Task]]
    }
    
    // Save
    static func save(_ tasks: [[Task]]) {
        // Archive
        let archivedTaks = archive(tasks)
        
        // Set object for key
        UserDefaults.standard.set(archivedTaks, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
}
