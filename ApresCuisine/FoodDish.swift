//
//  FoodDish.swift
//  ApresCuisine
//
//  Created by Valerie Greer on 2/27/17.
//  Copyright © 2017 Shane Empie. All rights reserved.
//

import UIKit
import Parse

class FoodDish: PFObject, PFSubclassing {
    
    @NSManaged var dishName     :String
    @NSManaged var dateEaten    :Date
    @NSManaged var rating       :Int
    @NSManaged var reviewText   :String
    
    convenience init(dishName: String, dateEaten: Date, rating: Int, reviewText: String) {
        self.init()
        self.dishName = dishName
        self.dateEaten = dateEaten
        self.rating = rating
        self.reviewText = reviewText
    }
    
    static func parseClassName() -> String {
        return "FoodDish"
    }
    
}
