//
//  Netowrk.swift
//  FoldingCell
//
//  Created by Patrick Li on 2/21/16.
//  Copyright © 2016 Alex K. All rights reserved.
//

import Foundation

class Uber {
    var dayOfWeek : String = ""
    var pickupTime : String = ""
    var startDestination : String = ""
    var endDestination : String = ""
    var estimatedArrivalTime : String = ""
    var driverName : String = ""

    init(dayOfWeek: String, pickupTime: String, startDestination: String, endDestination: String, estimatedArrivalTime: String, driverName: String ){
        self.dayOfWeek = dayOfWeek
        self.pickupTime = pickupTime
        self.startDestination = startDestination
        self.endDestination = endDestination
        self.estimatedArrivalTime = estimatedArrivalTime
        self.driverName = driverName
    }

}

class Hotel {
    var dayOfWeek : String = ""
    var checkinTime : String = ""
    var checkoutTime : String = ""
    var name : String = ""

    init(dayOfWeek: String, checkinTime: String, checkoutTime: String, name: String){
        self.dayOfWeek = dayOfWeek
        self.checkinTime = checkinTime
        self.checkoutTime = checkoutTime
        self.name = name
    }
}

class Plane {
    var flightTime : String = ""
    var startDestination : String = ""
    var endDestination : String = ""
    var gate : String = ""

    init(flightTime: String, startDestination: String, endDestination: String, gate: String, estimatedArrivalTime: String, airlineName: String){
        self.flightTime = flightTime
        self.startDestination = startDestination
        self.endDestination = endDestination
        self.gate = gate
    }
}

class Network {

    var cells: [AnyObject] = []

    public func getContentFromServr(withUserId : String) {

        request(.GET, "https://radiant-plains-34333.herokuapp.com/candidate/\(withUserId).json", parameters: nil).responseJSON {
            response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    print(json)

                    /*var jsonArray = JSON(value) as NSArray
                    for(var i=0; i<jsonArray.count; i++)[
                        if(jsonArray[i]["type"] == "Uber"){
                            var UberStruct = Uber(jsonArray[i]["driverName"]...)
                            cells.append(UberStruct)
                        }
                        else if(jsonArray[i]["type"] == "Hotel"){

                        }
                        else if(jsonArray[i]["type"] == "Flight"){

                        }
                    }

                    
                    */

                }
            case .Failure(let error):
                print(error)
            }

            
        }

    }
    
}

