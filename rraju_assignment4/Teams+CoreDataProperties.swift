//
//  Teams+CoreDataProperties.swift
//  rraju_assignment4
//
//  Created by Rohith Raju on 10/22/16.
//  Copyright © 2016 Rohith Raju. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Teams {

    @NSManaged var cid: NSNumber?
    @NSManaged var fav: NSNumber?
    @NSManaged var goals: NSNumber?
    @NSManaged var id: NSNumber?
    @NSManaged var lid: NSNumber?
    @NSManaged var name: String?
    @NSManaged var points: NSNumber?
    @NSManaged var sid: NSNumber?

}
