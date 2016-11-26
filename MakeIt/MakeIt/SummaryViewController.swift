//
//  SummaryViewController.swift
//  MakeIt
//
//  Created by Mathias Breistein on 26.11.2016.
//  Copyright © 2016 CyberDollarBoys. All rights reserved.
//

import UIKit
import LocalAuthentication

class SummaryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Punishment"
        navigationItem.backBarButtonItem?.title = ""

        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Background 2")).withAlphaComponent(0.8)

        
        askForSettlements(id: appointment.id!) { settlements in
            self.settlements.append(contentsOf: settlements!)
            self.tableView.reloadData()
        }
        
        setupTableView()
        addComeButton()
        
    }
    
    private func addComeButton() {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(arrived))
        navigationItem.rightBarButtonItem = button
    }
    
    func arrived() {
        didArrive(id: appointment.id!, number: appointment.attendees![0])
    }
    
    
    let myNumber = "23234"
    
    @IBAction func settle(_ sender: Any) {
        
        /*
        let context = LAContext()
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Settle", reply: { [unowned self] (success, error) -> Void in
            
            if( success ) {
                
                // Fingerprint recognized
                // Go to view controller
                self.showAlertWithTitle(title: "Success", message: "You've settled it!")
                
            } else {
                
                // Check if there is an error
                
                    self.showAlertWithTitle(title: "Error", message: "Something went awfully wrong.")
                    return
                
            }
            
        })
        */
    
        
        
        for var i in 0..<settlements.count {
            if settlements[i].from == UserDefaults.number() {
                settlements[i].settled = true
            }
        }
        updateSettling(settlements)
        tableView.reloadData()
    }

    var appointment: Appointment!
    var settlements = [Settlement]()
    
    var tableView: UITableView!
    
    private func setupTableView() {
        let frame = CGRect(x: 19, y: 125, width: 337, height: 416)
        tableView = UITableView(frame: frame)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.gray.withAlphaComponent(0.75)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.layer.cornerRadius = 8
        tableView.separatorStyle = .none

        view.addSubview(tableView)
    }
    
    func showAlertWithTitle(title: String, message: String) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        DispatchQueue.main.async() { () -> Void in
            
            self.present(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
}

extension SummaryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return settlements.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let settlement = settlements[indexPath.row]
        
        cell.textLabel?.text = settlement.coolify()
        cell.backgroundColor = .clear
        cell.textLabel?.font = cell.textLabel?.font.withSize(24)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        if settlement.settled {
            cell.textLabel?.textColor = .green
        } else {
            cell.textLabel?.textColor = .white
        }
        
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
 
}

struct Settlement {
    let id: String
    let from: String
    let to: String
    let amount: Double
    var settled: Bool
    
    func coolify() -> String {
        return "From: " + from + " - To: " + to + ". Amount: Eur " + String(Int(amount))
    }
    
    func JSON() -> [String: Any] {
        var json = [String: Any]()
        json["from"] = from
        json["to"] = to
        json["amount"] = amount
        json["settled"] = settled
        return json
    }
}




