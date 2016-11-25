//
//  AppointmentsViewController.swift
//  MakeIt
//
//  Created by Mathias Breistein on 25.11.2016.
//  Copyright © 2016 CyberDollarBoys. All rights reserved.
//

import UIKit


class AppointmentsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Background Image 1")).withAlphaComponent(0.6)

    }

    var appointment: Appointment! {
        didSet {
            
        }
    }
   

}
