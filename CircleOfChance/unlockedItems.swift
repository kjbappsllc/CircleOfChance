//
//  unlockedItems.swift
//  CircleOfChance
//
//  Created by Mac on 1/25/17.
//  Copyright © 2017 KJB Apps LLC. All rights reserved.
//

import UIKit

class unlockedItems: NSObject, NSCoding {
    //MARK: Properties
    var items: item
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("unlockedItems")
    
    // MARK: Types
    
    struct PropertyKey {
        static let itemKey = "item"
    }
    
    init(items: item) {
        self.items = items
    }
    
    //MARK: NSCoding
    
    required convenience init?(coder aDecoder: NSCoder) {
        let items = aDecoder.decodeObjectForKey(PropertyKey.itemKey) as! item
        self.init(items: items)
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(items, forKey: PropertyKey.itemKey)
    }
}
