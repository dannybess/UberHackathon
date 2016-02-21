//
//  DemoCell.swift
//  FoldingCell
//
//  Created by Alex K. on 25/12/15.
//  Copyright © 2015 Alex K. All rights reserved.
//

import UIKit
import MapKit

var coordinateToPass : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 37.411461, longitude: -122.031090)
class DemoCell: FoldingCell, MKMapViewDelegate {
    
    @IBOutlet weak var mapView1: MKMapView!
    @IBOutlet weak var uberEndAddress: UILabel!
    @IBOutlet weak var uberHomeAddress: UILabel!
    @IBOutlet weak var uberImageView: UIImageView!
    @IBOutlet weak var uberDate: UILabel!
    @IBOutlet weak var uberStartTime: UILabel!
    @IBOutlet weak var uberArrivalValue: UILabel!
    @IBOutlet weak var uberArrivalTime: UILabel!
    @IBOutlet weak var uberLine: UIView!    
    @IBOutlet weak var centerValue: UILabel!
    @IBOutlet weak var centerLabel: UILabel!
    @IBOutlet weak var sideColor: UIView!
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var driverLabel: UILabel!
    @IBOutlet weak var underTopLabel: UILabel!
    @IBOutlet weak var underDriverLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var underFromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var underToLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var underArrivalTimeLabel: UILabel!
    @IBOutlet weak var underUnderArrivalTimeLabel: UILabel!
    @IBOutlet weak var returnTripLabel: UILabel!
    
    @IBOutlet weak var testImageView: UIImageView!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var sideView: UIView!
    @IBOutlet weak var arrowImage1: UIImageView!
    override func awakeFromNib() {
        foregroundView.layer.cornerRadius = 10
        foregroundView.layer.masksToBounds = true
        self.mapView1.delegate = self
        let annotation = MKPointAnnotation()
        //37.411461, -122.031090
        let location = coordinateToPass
        let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        annotation.coordinate = location
        annotation.title = "End"
        self.mapView1.setRegion(MKCoordinateRegion(center: location, span: span), animated: false)
        self.mapView1.addAnnotation(annotation)
        requestSnapshotData(self.mapView1) { snapshot, error in
            self.testImageView.image = UIImage(data: snapshot!)
        }
        self.mapView1.hidden = true

        super.awakeFromNib()
    }
    
    override func animationDuration(itemIndex:NSInteger, type:AnimationType)-> NSTimeInterval {
     
        let durations = [0.26, 0.2, 0.2]
        return durations[itemIndex]
    }

    func requestSnapshotData(mapView: MKMapView, completion: (NSData?, NSError?) -> ()) {
        let options = MKMapSnapshotOptions()
        options.region = mapView.region
        options.size = mapView.frame.size
        options.scale = UIScreen.mainScreen().scale

        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.startWithCompletionHandler() { snapshot, error in
            guard snapshot != nil else {
                completion(nil, error)
                return
            }

            let image = snapshot!.image
            let data = UIImagePNGRepresentation(image)
            completion(data, nil)
        }
    }

}
