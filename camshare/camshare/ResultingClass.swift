//
//  Result.swift
//  camshare
//
//  Created by Janco Erasmus on 2020/02/20.
//  Copyright © 2020 DVT. All rights reserved.
//

import UIKit

class ResultingClass {
    // MARK: Properties
    
    var description: String
    var photo: UIImage?

    init?(description: String, photo: UIImage?) {
        if description.isEmpty {
            return nil
        }
        
        self.description = description
        self.photo = photo
    }
}
