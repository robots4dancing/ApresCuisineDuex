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

class DetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var currentFoodDish     :FoodDish?
    
    @IBOutlet var foodDishTextField             :UITextField!
    @IBOutlet var ratingTextField               :UITextField!
    @IBOutlet var dateEatenDatePicker           :UIDatePicker!
    @IBOutlet var reviewTextTextView            :UITextView!
    @IBOutlet private weak var capturedImage    :UIImageView!
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMapView" {
            let destVC = segue.destination as! MapViewController
            destVC.currentFoodDish = currentFoodDish
        }
    }
    
    @IBAction func saveButtonPressed(button: UIBarButtonItem){
        save(foodDish: currentFoodDish!)
    }
    
    @IBAction func shareOnWhateverButtonPressed(button: UIBarButtonItem) {
        let shareString = "Food Dish: \(currentFoodDish!.dishName)\nDate Eaten: \(currentFoodDish!.dateEaten)\nRating (0 to 10): \(currentFoodDish!.rating)\nReview: \(currentFoodDish!.reviewText)"
        let activityVC = UIActivityViewController(activityItems: [shareString], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    //MARK: - Camera Methods
    
    @IBAction func builtInCameraPressed(button: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("No Camera")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        capturedImage.image = (info[UIImagePickerControllerOriginalImage] as! UIImage)
        saveImg(image: capturedImage.image!)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - Image Saving Methods
    
    func getNewImageFilename() -> String {
        return ProcessInfo.processInfo.globallyUniqueString + ".png"
    }
    
    func getDocumentPathForFile(filename: String) -> URL {
        let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let docURL = URL(fileURLWithPath: docPath)
        return docURL.appendingPathComponent(filename)
    }
    
    func delete(localFileURL: URL) {
        let fileMgr = FileManager()
        try? fileMgr.removeItem(at: localFileURL)
    }
    
    func saveImg(image: UIImage) {
        saveImgFile(image: image, filename: getNewImageFilename())
    }
    
    func saveImgFile(image: UIImage, filename: String) {
        do {
            let localPath = getDocumentPathForFile(filename: filename)
            guard let png = UIImagePNGRepresentation(image) else {
                print("Error: Failed to create PNG")
                return
            }
            try png.write(to: localPath)
            print("Saved: \(filename)")
            currentFoodDish?.imageName = filename
            save(foodDish: currentFoodDish!)
            
        } catch let error {
            print("Error: Saving local failed \(error.localizedDescription)")
        }
        
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("\(currentFoodDish?.imageName)")
        if currentFoodDish?.imageName != nil {
            print("GOT HERE!!!")
            let imgUrl = getDocumentPathForFile(filename: (currentFoodDish?.imageName)!)
            print("\(imgUrl)")
            capturedImage.image = UIImage(contentsOfFile: imgUrl.path)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
