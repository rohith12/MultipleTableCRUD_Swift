//
//  Genre+CoreDataProperties.swift
//  rraju_Assignment3
//
//  Created by Rohith Raju on 10/3/16.
//  Copyright © 2016 Rohith Raju. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Genre {

    @NSManaged var gid: NSNumber?
    @NSManaged var gname: String?

}
