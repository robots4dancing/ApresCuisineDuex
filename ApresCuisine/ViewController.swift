//
//  ViewController.swift
//  ApresCuisine
//
//  Created by Valerie Greer on 2/27/17.
//  Copyright © 2017 Shane Empie. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    var dateFormat = DateFormatter()
    var foodDishArray = [FoodDish]()
    var selectedFoodDish :FoodDish?
    
    @IBOutlet var foodDishTableView :UITableView!
    
    //MARK: - Parse Methods
    
    func save(foodDish: FoodDish) {
        
        foodDish.saveInBackground { (success, error) in
            print("Object Saved")
            self.fetchFoodDishes()
        }
    }
    
    func fetchFoodDishes() {
        let query = PFQuery(className: "FoodDish")
        query.limit = 1000
        query.order(byAscending: "isComplete")
        query.order(byDescending: "priorityLevel")
        query.findObjectsInBackground { (results, error) in
            if let err = error {
                print("Got error \(err.localizedDescription)")
            } else {
                self.foodDishArray = results as! [FoodDish]
                print("Count: \(self.foodDishArray.count)")
                self.foodDishTableView.reloadData()
            }
        }
    }
    
    //MARK: - Life Cycle Mthods

    override func viewDidLoad() {
        super.viewDidLoad()
    //    testParse()
        fetchFoodDishes()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFoodDishes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Test Methods
    
    func testParse() {
        
        let testObject = FoodDish(dishName: "Lentil Soup", dateEaten: Date(), rating: 10, reviewText: "Soup made from lentils. Delicious and nutritious!")
        save(foodDish: testObject)
        
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodDishArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FoodDishTableViewCell
        let currentFoodDish = foodDishArray[indexPath.row]
        self.dateFormat.dateFormat = "MM/dd/yyyy"
        let date = currentFoodDish.dateEaten
        let dateString = self.dateFormat.string(from: date)
        cell.dishNameLabel.text = currentFoodDish.dishName
        cell.dateEatenLabel.text = dateString
        cell.ratingLabel.text = "\(currentFoodDish.rating)"
        cell.reviewTextLabel.text = currentFoodDish.reviewText
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedFoodDish = foodDishArray[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("About to Delete")
            let foodDishToDelete = foodDishArray[indexPath.row]
            foodDishToDelete.deleteInBackground(block: { (sucess, error) in
                print("Deleted")
                self.fetchFoodDishes()
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

