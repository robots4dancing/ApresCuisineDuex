//
//  DetailViewController.swift
//  ApresCuisine
//
//  Created by Valerie Greer on 2/28/17.
//  Copyright © 2017 Shane Empie. All rights reserved.
//

import UIKit
import Parse
import Social

class DetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var currentFoodDish     :FoodDish?
    
    @IBOutlet var foodDishTextField     :UITextField!
    @IBOutlet var ratingTextField       :UITextField!
    @IBOutlet var dateEatenDatePicker   :UIDatePicker!
    @IBOutlet var reviewTextTextView    :UITextView!
    
    //MARK: - Display Methods
    
    func display(foodDish: FoodDish) {
        foodDishTextField.text = foodDish.dishName
        ratingTextField.text = "\(foodDish.rating)"
        dateEatenDatePicker.date = foodDish.dateEaten
        reviewTextTextView.text = foodDish.reviewText
    }
    
    //MARK: - Parse Methods
    
    func save(foodDish: FoodDish) {
        currentFoodDish?.dishName = foodDishTextField.text!
        currentFoodDish?.rating = Int(ratingTextField.text!)!
        currentFoodDish?.dateEaten = dateEatenDatePicker.date
        currentFoodDish?.reviewText = reviewTextTextView.text!
        foodDish.saveInBackground { (success, error) in
            print("Object Saved")
        }
    }
    
    //MARK: - Interactivity Methods
    
    @IBAction func saveButtonPressed(button: UIBarButtonItem){
        save(foodDish: currentFoodDish!)
    }
    
    @IBAction func shareOnWhateverButtonPressed(button: UIBarButtonItem) {
        let shareString = "Food Dish: \(currentFoodDish!.dishName)\nDate Eaten: \(currentFoodDish!.dateEaten)\nRating (0 to 10): \(currentFoodDish!.rating)\nReview: \(currentFoodDish!.reviewText)"
        let activityVC = UIActivityViewController(activityItems: [shareString], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    //MARK: - Text Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        if let foodDish = currentFoodDish {
            display(foodDish: foodDish)
        } else {
            currentFoodDish = FoodDish()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
