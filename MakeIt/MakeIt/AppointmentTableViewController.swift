//
//  AppointmentTableViewController.swift
//  MakeIt
//
//  Created by Mathias Breistein on 25.11.2016.
//  Copyright © 2016 CyberDollarBoys. All rights reserved.
//

import UIKit

class AppointmentTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Background Image 1")).withAlphaComponent(0.6)
        
        tableView.separatorStyle = .none
    }
    
    var appointment = Appointment.testAppointments()[0]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        optionButton.removeFromSuperview()
    }

    var optionButton: UIButton!
    var yOffset: CGFloat {
        return view.frame.height - 100.0
    }
    
    private func addButton() {
        let distance: CGFloat = 80
        let frame = CGRect(x: view.frame.width - (20.0 + distance), y: yOffset , width: distance, height: distance)

        optionButton = UIButton(frame: frame)
        optionButton.setImage(#imageLiteral(resourceName: "Button"), for: .normal)
        optionButton.addTarget(self, action: #selector(optionButtonPressed), for: .touchUpInside)
        
        view.addSubview(optionButton)
        
    }
    
    var rotated = false
    func optionButtonPressed() {
        self.performSegue(withIdentifier: "CreateAppointment", sender: nil)
 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAppointment" {
            if let avc = segue.destination as? AppointmentsViewController {
                avc.appointment = appointment
            }
        }
    }
  

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowAppointment", sender: nil)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var frame: CGRect = self.optionButton.frame
        frame.origin.y = scrollView.contentOffset.y + yOffset
        optionButton.frame = frame
        
        view.bringSubview(toFront: optionButton
        )
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentCell", for: indexPath) as! AppointmentTableViewCell

        // Configure the cell...

        
        // MIS

        
        let horizontalPadding: CGFloat = 10
        let verticalPadding: CGFloat = 10
        
        let cellFrame = CGRect(x: horizontalPadding, y: verticalPadding, width: view.frame.width - 2 * horizontalPadding, height: 100)
        
        cell.cellView = UIView(frame: cellFrame)
       
        cell.contentView.addSubview(cell.cellView)
        cell.contentView.sendSubview(toBack: cell.cellView)
        cell.appointment = appointment

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130.0
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .normal, title: "Postpone 5 min") { action, index in
            let cell = tableView.cellForRow(at: indexPath) as! AppointmentTableViewCell
            cell.count += 300
        }
        action.backgroundColor = UIColor.clear
        return [action]
    }

}
