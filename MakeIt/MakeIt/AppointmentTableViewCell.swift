//
//  AppointmentTableViewCell.swift
//  MakeIt
//
//  Created by Mathias Breistein on 25.11.2016.
//  Copyright © 2016 CyberDollarBoys. All rights reserved.
//

import UIKit

class AppointmentTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    
    // MARK: Labels
    @IBOutlet weak var appointmentNameLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var participantLabel: UILabel!
    
    @IBOutlet weak var remainingTimeLabel: UILabel!
    
    @IBOutlet weak var amountLabel: UILabel!
    
    @IBOutlet weak var appointmentTimeLabel: UILabel!
    
    var timer: Timer!
    var appointment: Appointment! {
        didSet {
            // Set UI elements here
            appointmentNameLabel.text = appointment.appointmentName
            locationLabel.text = appointment.locationName
            participantLabel.text = appointment.participants
            
            amountLabel.text = appointment.amountFormatted
            appointmentTimeLabel.text = appointment.timeOfAppointment
            
            // Set the counter and start updating
            count = appointment.date!.seconds(from: Date())
            
            if timer == nil {
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(AppointmentTableViewCell.update), userInfo: nil, repeats: true)
            }
            
            
        }
    }
    
    
    
    
    var count = 0

func update() {
    
    if(count >= 0){
        let minutes = String(count / 60)
        let seconds = count % 60 > 10 ? String(count % 60) : "0" + String(count % 60)
        remainingTimeLabel.text = minutes + ":" + seconds
        count -= 1
    } else {
        remainingTimeLabel.text = "Started!"
    }
    
}
    

    var cellView: UIView! {
        didSet {
            backgroundColor = .clear
            selectionStyle = .none
            cellView.layer.backgroundColor = UIColor.lightGray.withAlphaComponent(0.85).cgColor
            cellView.layer.masksToBounds = false
            cellView.layer.cornerRadius = 8.0
            cellView.layer.shadowOffset = CGSize(width: -1.0, height: 1.0)
            cellView.layer.shadowOpacity = 0.2
            
            separatorInset = UIEdgeInsets.zero
            layoutMargins = UIEdgeInsets.zero
        }
    }
    
   
}
