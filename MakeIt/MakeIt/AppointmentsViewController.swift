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
        blanketView.layer.cornerRadius = 8
        blanketView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.75)
        
        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swiped(_:)))
        blanketView.addGestureRecognizer(swipeGestureRecognizer)
        
        setupAttendeesView()
        
        testAPI()
        testPost()
        configureViews()
    }
    
    
    
    
    func swiped(_ gesture: UIGestureRecognizer) {
        print("Swiping to ")
    }
    
    func flip() {
        let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        
        UIView.transition(with: blanketView, duration: 1.0, options: transitionOptions, animations: {
            self.blanketView.isHidden = true
        })
        
        UIView.transition(with: attendeesView, duration: 1.0, options: transitionOptions, animations: {
            self.attendeesView.isHidden = false
        })
    }
    
    
    private func setupAttendeesView() {
        attendeesView = UITableView(frame: blanketView.frame)
        attendeesView.isHidden = true
        attendeesView.dataSource = self
        attendeesView.delegate = self
        
        
        view.addSubview(attendeesView)
    }
    
    var attendeesView: UITableView!
    
    var appointment: Appointment! {
        didSet {
           
        }
    }
    
    @IBOutlet weak var blanketView: UIView!
    @IBOutlet weak var punishmentLabel: UILabel!
    @IBOutlet weak var nextAppointmentInLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    
    private func configureViews() {
        punishmentLabel.text = appointment.amountFormatted
        nameLabel.text = appointment.appointmentName
        locationLabel.text = appointment.locationName
        // Set the counter and start updating
        count = appointment.date!.seconds(from: Date())
        
        _ = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    
    
    @IBAction func postpone(_ sender: Any) {
        count += 300
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

    
   

}

extension AppointmentsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return appointment.attendees!.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

     
     return cell
        
     }
   
    
}

