//
//  NumberCount.swift
//  Testing
//
//  Created by admin on 06/01/17.
//  Copyright © 2017 admin. All rights reserved.
//

import Foundation
import RealmSwift

class NumberCount: Object {
    
    dynamic var date: Date = Date()
    dynamic var count: Int = Int(0)
    
    func save() {
        do{
            let realm = try Realm()
            try realm.write
                {
                    realm.add(self)
            }
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
}
