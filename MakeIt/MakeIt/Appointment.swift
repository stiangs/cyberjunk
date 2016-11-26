//
//  Appointment.swift
//  MakeIt
//
//  Created by Mathias Breistein on 25.11.2016.
//  Copyright © 2016 CyberDollarBoys. All rights reserved.
//

import Foundation


class Appointment {
    
    var name: String?
    var attendees: [String]?
    var punishment: Double?
    var currency: String?
    var location: (latitude: Double, longtitude: Double)?
    var date: Date?
    var id: String?
    var meetup: [String]?
    
    convenience init(name: String, attendees: [String], punishment: Double, currency: String, location: (latitude: Double, longtitude: Double), date: Date) {
        self.init()
        self.name = name
        self.attendees = attendees
        self.punishment = punishment
        self.currency = currency
        self.location = location
        self.date = date
    }
    

    
    var amountFormatted: String {
        guard currency != nil && punishment != nil else {
            return "0 EUR"
        }
        
        return String(punishment!) + " " + currency!
    }
    
    var timeOfAppointment: String {
        guard date != nil else {
            return "Never"
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter.string(from: date!)
    }
    
    var appointmentName: String {
        return name ?? "Appointment"
    }
    
    var participants: String {
        return "\(attendees != nil ? attendees!.count : 0) " + "participants"
    }
    
    var locationName: String {
        return "Oslo, Norway"
    }
    
    func JSON() -> [String: Any] {
        var appointment = [String: Any]()
        
        appointment["name"] = name!
        var nameArray = [String]()
        for number in attendees! {
            nameArray.append(number)
        }


        appointment["attendees"] = nameArray
        appointment["punishment"] = String(punishment!)
        appointment["currency"] = currency!
        appointment["lat"] = String(location!.latitude)
        appointment["lon"] = String(location!.longtitude)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        appointment["date"] = dateFormatter.string(from: date!)
    
    
        return appointment
    }
    
    class func testAppointments() -> [Appointment] {
        var appointments = [Appointment]()
        let appointment = Appointment(
            name: "Pubcrawl",
            attendees: ["94255783", "585849823"],
            punishment: 200,
            currency: "NOK",
            location: (latitude: 30.0, longtitude: 60.0),
            date: Date().addingTimeInterval(180))
        appointments.append(appointment)
        
        return appointments
    }
    
    
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
