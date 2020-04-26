//
//  Image+CoreDataProperties.swift
//  
//
//  Created by Janco Erasmus on 2020/04/21.
//
//

import Foundation
import CoreData

extension Image {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Image> {
        return NSFetchRequest<Image>(entityName: "Image")
    }

    @NSManaged public var image: Data?
    @NSManaged public var name: String?

}
