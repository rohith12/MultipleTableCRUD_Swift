//
//  Country+CoreDataProperties.swift
//  rraju_assignment4
//
//  Created by Rohith Raju on 10/20/16.
//  Copyright © 2016 Rohith Raju. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Country {

    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var time_stamp: String?

}
