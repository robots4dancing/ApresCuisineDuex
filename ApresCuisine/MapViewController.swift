//
//  MapViewController.swift
//  ApresCuisine
//
//  Created by Valerie Greer on 3/28/17.
//  Copyright © 2017 Shane Empie. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController{
    
    var currentFoodDish     :FoodDish?
    
    @IBOutlet var foodMapView       :MKMapView!
    
    //MARK: - Parse Methods
    
    func save(foodDish: FoodDish) {
            foodDish.saveInBackground { (success, error) in
            print("Object Saved")
        }
    }
    
    //MARK: - Map Methods
    
    func addFoodMapPointOnLoad() {
        var pinsToRemove = [MKPointAnnotation]()
        for annotation in foodMapView.annotations {
            if annotation is MKPointAnnotation {
                pinsToRemove.append(annotation as! MKPointAnnotation)
            }
        }
        foodMapView.removeAnnotations(pinsToRemove)
        let foodMapPoint = MKPointAnnotation()
        foodMapPoint.coordinate = CLLocationCoordinate2D(latitude: (currentFoodDish?.latitude)!, longitude: (currentFoodDish?.longitude)!)
        foodMapPoint.title = currentFoodDish?.dishName
        foodMapPoint.subtitle = currentFoodDish?.reviewText
        foodMapView.addAnnotation(foodMapPoint)
        zoomToPin(lat: foodMapPoint.coordinate.latitude, lon: foodMapPoint.coordinate.longitude)
    }
    
    func zoomToPin(lat: Double, lon: Double) {
        let coord = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let viewRegion = MKCoordinateRegionMakeWithDistance(coord, 3000.0, 3000.0)
        let adjustedRegion = foodMapView.regionThatFits(viewRegion)
        foodMapView.setRegion(adjustedRegion, animated: true)
    }
    
    func addAnnotationOnLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .ended {
            let point = gesture.location(in: self.foodMapView)
            let coordinate = self.foodMapView.convert(point, toCoordinateFrom: self.foodMapView)
            print(coordinate)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = currentFoodDish?.dishName
            annotation.subtitle = currentFoodDish?.reviewText
            self.foodMapView.addAnnotation(annotation)
            currentFoodDish?.latitude = coordinate.latitude
            currentFoodDish?.longitude = coordinate.longitude
            save(foodDish: currentFoodDish!)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if currentFoodDish?.latitude != nil && currentFoodDish?.longitude != nil {
            addFoodMapPointOnLoad()
        }
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotationOnLongPress(gesture:)))
        longPressGesture.minimumPressDuration = 0.5
        self.foodMapView.addGestureRecognizer(longPressGesture)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
