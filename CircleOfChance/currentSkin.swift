//
//  currentSkin.swift
//  CircleOfChance
//
//  Created by Mac on 1/26/17.
//  Copyright © 2017 KJB Apps LLC. All rights reserved.
//

import UIKit

class currentSkin: NSObject, NSCoding {
    var currentItem: item
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("currentSkin")
    
    // MARK: Types
    
    struct PropertyKey {
        static let currentKey = "currentItem"
    }
    
    init(items: item) {
        self.currentItem = items
    }
    
    //MARK: NSCoding
    
    required convenience init?(coder aDecoder: NSCoder) {
        let items = aDecoder.decodeObjectForKey(PropertyKey.currentKey) as! item
        self.init(items: items)
        
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(currentItem, forKey: PropertyKey.currentKey)
    }
}
