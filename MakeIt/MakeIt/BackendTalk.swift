//
//  BackendTalk.swift
//  MakeIt
//
//  Created by Mathias Breistein on 26.11.2016.
//  Copyright © 2016 CyberDollarBoys. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


func testPost() {
    let appointment = Appointment.testAppointments()[0]
    let data = appointment.JSON() as Parameters?
    let postUrl = url + "/users/" + appointment.attendees![0] + "/newappointment"
    _ = Alamofire.request(postUrl, method: .post, parameters: data, encoding: JSONEncoding.default)
   
    
}

let url = "http://85.188.10.170:3000"

func didArrive(id: String, number: String) {
    let confirmUrl = url + "/appointments/update/" + id + "/" + number
    _ = Alamofire.request(confirmUrl, method: .put, parameters: nil, encoding: JSONEncoding.default, headers: nil)
}

func checkArrived(for number: String, id: String, _ completion: @escaping ((Bool) -> ())) {
    let checkUrl = url + "/appointments/arrived/" + id + "/" + number
    _ = Alamofire.request(checkUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
        let json = JSON(response.result.value!)
        var value = false
        for name in json.array! {
            if name.string == number {
                value = true
            }
        }
        print(value)
        completion(value)
        
        
        
    })
    
    
}





func testAPI(completion: @escaping ((_ appointments: [Appointment]?) -> ()) ) {
    
    let testUrl = url + "/94255783/appointment"
    Alamofire.request(testUrl, method: .get).responseJSON { (response) in
        if(response.result.value) != nil {
            let json = JSON(response.result.value!)
            var appointments = [Appointment]()
            for object in json.array! {
                
                let appointment = Appointment()
                
                if let id = object["_id"].string {
                    appointment.id = id
                }
                
                if let name = object["name"].string {
                    appointment.name = name
                }
                
                if let currency = object["currency"].string {
                    appointment.currency = currency
                }
                
                if let meetup = object["meetup"].arrayObject as? [String] {
                    appointment.meetup = meetup
                }
                
                
                if let lon = Double(object["lon"].string!) {
                    if let lat = Double(object["lat"].string!) {
                      
                        let location = (latitude: lat, longtitude: lon)
                        appointment.location = location
                    }
                    
                }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .short
                
                
                if let date = dateFormatter.date(from: object["date"].string!) {
                    appointment.date = date
                }
                
                if let punishment = object["punishment"].double {
                    appointment.punishment = punishment
                }
                
                if let attendees = object["attendees"].arrayObject as? [String] {
                    appointment.attendees = attendees
                }
             
                print(object)
                appointments.append(appointment)
            }
            completion(appointments)
        } else {
            completion(nil)
        }
    }
    
}
