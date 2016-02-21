//
//  ViewController.swift
//  LoginScreen
//
//  Created by Patrick Li on 2/20/16.
//  Copyright © 2016 Dali Labs, Inc. All rights reserved.
//

import UIKit

func encode<T>(var value: T) -> NSData {
    return withUnsafePointer(&value) { p in
        NSData(bytes: p, length: sizeofValue(value))
    }
}

func decode<T>(data: NSData) -> T {
    let pointer = UnsafeMutablePointer<T>.alloc(sizeof(T.Type))
    data.getBytes(pointer)

    return pointer.move()
}

class LoginViewController: VideoSplashViewController {
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var foraLogo: UIImageView!
    @IBOutlet weak var textField: UITextField!
    var screen = UIScreen.mainScreen().bounds
    @IBOutlet weak var loginButton: UIButton!
    //var cells : NSMutableArray = NSMutableArray()
    var uberCells : [Uber] = []
    var hotelCells : [Hotel] = []
    var planeCells : [Plane] = []
    var typesArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource("test", ofType: "mp4")!)
        self.videoFrame = view.frame
        self.fillMode = .ResizeAspectFill
        self.alwaysRepeat = true
        self.sound = true
        self.startTime = 0.0
        self.duration = 15.0
        self.alpha = 0.7
        self.backgroundColor = UIColor.blackColor()
        self.contentURL = url

        textField.layer.cornerRadius = 3
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        self.loginButton.addTarget(self, action: "goToView:", forControlEvents: UIControlEvents.TouchUpInside)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func keyboardWillShow(notification: NSNotification) {
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height + 20
        })
    }
    
    func keyboardWillHide(notification: NSNotification){
        var info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = 59
        })
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func goToView(sender: UIButton) {
        SwiftSpinner.show("Loading...")
        if(self.textField.text == ""){
            print("fill up text field")
        }
        else {
            let textFieldText: String = self.textField.text!
            request(.GET, "https://radiant-plains-34333.herokuapp.com/candidate/\(textFieldText).json", parameters: nil).responseJSON {
                response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        for(var i=0; i < json["steps"].count; i++){
                            self.typesArray.append(json["steps"][i]["type"].string!)
                            if(json["steps"][i]["type"] == "Uber"){
                                var UberStruct = Uber(dayOfWeek: json["steps"][i]["pickUpDate"].string!,
                                    pickupTime: json["steps"][i]["pickUpTime"].string!,
                                    startDestination: json["steps"][i]["startDestination"].string!,
                                    endDestination: json["steps"][i]["endDestination"].string!,
                                    estimatedArrivalTime: json["steps"][i]["estimatedArrivalTime"].string!,
                                    driverName: json["steps"][i]["driverName"].string!)
                                self.uberCells.append(UberStruct)
                            }
                            else if(json["steps"][i]["type"] == "Hotel"){
                                var HotelStruct = Hotel(dayOfWeek: json["steps"][i]["dayOfWeek"].string!,
                                    checkinTime: json["steps"][i]["checkInDate"].string!,
                                    checkoutTime: json["steps"][i]["checkOutDate"].string!,
                                    name: json["steps"][i]["name"].string!)
                                self.hotelCells.append(HotelStruct)
                            }
                            else if(json["steps"][i]["type"] == "Flight"){
                                var PlaneStruct = Plane(flightTime: json["steps"][i]["flightTime"].string!,
                                    startDestination: json["steps"][i]["startDestination"].string!,
                                    endDestination: json["steps"][i]["endDestination"].string!,
                                    gate: json["steps"][i]["Gate"].string!,
                                    estimatedArrivalTime: json["steps"][i]["estimatedArrivalTime"].string!,
                                    airlineName: json["steps"][i]["airline"].string!)
                                self.planeCells.append(PlaneStruct)
                            }
                        }
                        self.performSegueWithIdentifier("move", sender: self)
                        SwiftSpinner.hide()

                    }
                case .Failure(let error):
                    print(error)
                }
                
                
            }
        }

    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "move"){
            let vc = segue.destinationViewController as! MainTableViewController
            vc.uberCells = self.uberCells
            vc.hotelCells = self.hotelCells
            vc.planeCells = self.planeCells
            print(self.typesArray)
            vc.typesArray = self.typesArray
        }
    }



}