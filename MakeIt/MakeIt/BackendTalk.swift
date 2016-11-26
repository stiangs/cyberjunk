//
//  BackendTalk.swift
//  MakeIt
//
//  Created by Mathias Breistein on 26.11.2016.
//  Copyright © 2016 CyberDollarBoys. All rights reserved.
//

import Foundation
import Alamofire


func testPost() {
    let appointment = Appointment.testAppointments()[0]
    let data = appointment.JSON() as Parameters?
    let postUrl = url + "/users/" + appointment.attendees![0] + "/newappointment"
    _ = Alamofire.request(postUrl, method: .post, parameters: data, encoding: JSONEncoding.default)
    
    
    
    
    
}

let url = "http://85.188.10.170:3000"

func testAPI() {
    Alamofire.request(url, method: .get).responseJSON { (response) in
        
        if let data = response.result.value as? [String: String] {
            print(data["name"]!)
        }
        
        
    }
    
}
