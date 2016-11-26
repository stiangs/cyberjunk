//
//  CreateAppointmentViewController.swift
//  MakeIt
//
//  Created by Mathias Breistein on 25.11.2016.
//  Copyright © 2016 CyberDollarBoys. All rights reserved.
//

//
//  CreateAppointmentViewController.swift
//  MakeIt
//
//  Created by Mathias Breistein on 25.11.2016.
//  Copyright © 2016 CyberDollarBoys. All rights reserved.
//

import UIKit
import Former
import ContactsUI

class CreateAppointmentViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        view.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "Background Image 1")).withAlphaComponent(0.6)
        self.title = "New Appointment"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(saveAppointment))
        self.bottomToolbar.tintColor = .white
        
        self.bottomToolbar.isTranslucent = true
        self.bottomToolbar.barTintColor = .formerBackgroundColor()
    }
    
    // MARK: Properties
    var inviteRow: LabelRowFormer<FormLabelCell>? = nil
    var name: String = "Meeting"
    var attendees: [String] = []
    var punishment: Double = 50.0
    var currency: String = "KR"
    var location: (latitude: Double, longtitude: Double) = (latitude: 35.0, longtitude: 35.0)
    var date: Date = Date().addingTimeInterval(600)
    
    func saveAppointment(){
        let appointment = Appointment(name: self.name, attendees: self.attendees, punishment: self.punishment, currency: self.currency, location: location, date: self.date)
        
        appointment.attendees?.insert(UserDefaults.number(), at: 0)
        print(appointment)
        print(name)
        print(currency)
        print(date)
        //DO: API call here
        uploadAppointment(appointment)
        
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func test(){
        print("hei")
        if let titleCell = self.former[0][0] as? TextFieldRowFormer<FormTextFieldCell>{
            print(titleCell.cell.textField.text!)
        }
        if let dateCell = self.former[1][0] as? InlineDatePickerRowFormer<FormInlineDatePickerCell>{
            print(dateCell.cell.displayLabel.text!)
        }
    }
    
    // MARK: Private
    
    private enum Currency{
        case NOK, EUR
        func title() -> String {
            switch self {
            case .EUR: return "€ - Euro"
            case .NOK: return "KR - Norwegian Kroners"
            }
        }
        static func getReverse(kkkk: String) -> String{
            if kkkk == "€ - Euro"{
                return "EUR"
            }
            return "KR"
        }
        
        static func values() -> [Currency]{
            return[EUR]
        }
    }
    
    
    private func configure() {
        title = "Add Event"
        tableView.contentInset.top = 10
        tableView.contentInset.bottom = 30
        tableView.contentOffset.y = -10
        
        // Set a backgroundImage to the view
        let imageView = UIImageView(frame: self.view.frame)
        let image = #imageLiteral(resourceName: "Background Image 1")
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        self.tableView.backgroundView = imageView
        
        // Make the tableView transparant
        tableView.backgroundColor = .clear
        
        // Create RowFomers
        
        let titleRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = .white //.formerColor()
            $0.textField.font = .systemFont(ofSize: 15)
            $0.backgroundColor = .formerBackgroundColor()
            }.configure {
                $0.placeholder = "Event title"
                $0.attributedPlaceholder = NSAttributedString(string:"Event Title", attributes: [NSForegroundColorAttributeName: UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)])
            }.onTextChanged {
                self.name = $0
        }
        let locationRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = .formerColor()
            $0.textField.font = .systemFont(ofSize: 15)
            $0.backgroundColor = .formerBackgroundColor()
            }.configure {
                $0.placeholder = "Location"
                $0.attributedPlaceholder = NSAttributedString(string:"Location", attributes: [NSForegroundColorAttributeName: UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)])
        }
        let currencyRow = InlinePickerRowFormer<FormInlinePickerCell, Currency>() {
            $0.titleLabel.text = "Currency"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 15)
            $0.backgroundColor = .formerBackgroundColor()
            $0.displayLabel.textColor = .formerSubColor()
            $0.displayLabel.font = .systemFont(ofSize: 15)
            }.configure {
                let nok = Currency.NOK
                $0.pickerItems.append(
                    InlinePickerItem(title: nok.title(),
                                     displayTitle: NSAttributedString(string: nok.title(),
                                                                      attributes: [NSForegroundColorAttributeName: UIColor.formerSubColor()]),
                                     value: nok)
                )
                $0.pickerItems += Currency.values().map {
                    InlinePickerItem(title: $0.title(), value: $0)
                }
            }.inlineCellSetup{
                $0.backgroundColor = .formerBackgroundColor()
            }.onValueChanged{
                self.currency = Currency.getReverse(kkkk: $0.title)
        }
        let amountRow = TextFieldRowFormer<FormTextFieldCell>() {
            $0.textField.textColor = .formerColor()
            $0.textField.font = .systemFont(ofSize: 15)
            $0.backgroundColor = .formerBackgroundColor()
            $0.textField.keyboardType = .numberPad
            }.configure {
                $0.placeholder = "Amount"
                $0.attributedPlaceholder = NSAttributedString(string:"Amount", attributes: [NSForegroundColorAttributeName: UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)])
            }.onTextChanged{
                self.punishment = Double($0)!
        }
        let startRow = InlineDatePickerRowFormer<FormInlineDatePickerCell>() {
            $0.titleLabel.text = "Start"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 15)
            $0.backgroundColor = .formerBackgroundColor()
            $0.displayLabel.textColor = .formerSubColor()
            $0.displayLabel.font = .systemFont(ofSize: 15)
            }.inlineCellSetup {
                $0.datePicker.datePickerMode = .dateAndTime
                $0.datePicker.setValue(UIColor.white, forKeyPath: "textColor")
                $0.backgroundColor = .formerBackgroundColor()
            }.displayTextFromDate(String.mediumDateShortTime).onDateChanged{
                self.date = $0
        }
        inviteRow = LabelRowFormer<FormLabelCell>(){
            $0.titleLabel.text = "Currency"
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 15)
            $0.backgroundColor = .formerBackgroundColor()
            $0.subTextLabel.textColor = .formerSubColor()
            $0.subTextLabel.font = .systemFont(ofSize: 15)
            }.configure {
                $0.text = "Invite"
                $0.subText = "0"
            }.onSelected { [weak self] _ in
                self?.former.deselect(animated: true)
                self?.showContacts()
        }
        let saveRow = LabelRowFormer<FormLabelCell>(){
            $0.titleLabel.textColor = .formerColor()
            $0.titleLabel.font = .boldSystemFont(ofSize: 15)
            $0.backgroundColor = .formerSubColor()
            }.configure {
                $0.text = "Save"
            }.onSelected{ _ in
                self.saveAppointment()
                
        }
        
        
        
        // Create Headers
        
        let createHeader: (() -> ViewFormer) = {
            return CustomViewFormer<FormHeaderFooterView>()
                .configure {
                    $0.viewHeight = 20
                    $0.view.isHidden = true
            }
        }
        
        // Create SectionFormers
        
        //titleRow.cell.backgroundColor = UIColor(red: 0.23, green: 0.23, blue: 0.23, alpha: 0.6)
        
        let titleSection = SectionFormer(rowFormer: titleRow, locationRow, currencyRow, amountRow)
            .set(headerViewFormer: createHeader())
        let dateSection = SectionFormer(rowFormer: startRow, self.inviteRow!)
            .set(headerViewFormer: createHeader())
        let saveSection = SectionFormer(rowFormer: saveRow)
            .set(headerViewFormer: createHeader())
        
        
        
        former.append(sectionFormer: titleSection, dateSection, saveSection)
        
    }
    
    
    @IBOutlet weak var invitedFriends: UIBarButtonItem!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
}

extension CreateAppointmentViewController: UIImagePickerControllerDelegate, CNContactPickerDelegate {
    func showContacts() {
        let contactPickerViewController = CNContactPickerViewController()
        
        contactPickerViewController.predicateForEnablingContact = NSPredicate(format: "phoneNumbers.@count > 0")
        contactPickerViewController.delegate = self
        contactPickerViewController.displayedPropertyKeys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
        
        present(contactPickerViewController, animated: true, completion: nil)
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        //Debug
        print(contact.phoneNumbers[0].value.stringValue)
        print(contact.givenName)
        print(contact.familyName)
        print(attendees)
        
        if attendees.count == 0{
            invitedFriends.title = "\(contact.givenName)"
        }
        else {
            invitedFriends.title = "\(contact.givenName), \(invitedFriends.title!)"
        }
        var nr = contact.phoneNumbers[0].value.stringValue
        print(nr)
        nr = nr.replacingOccurrences(of: " ", with: "")
        nr = nr.replacingOccurrences(of: "+47", with: "")
        nr = nr.replacingOccurrences(of: "0047", with: "")
        print(nr)
        attendees.append(nr)
        self.inviteRow?.subText = String(attendees.count)
        tableView.reloadData()
    }
    
    
}

extension UIColor {
    
    class func formerColor() -> UIColor {
        //return UIColor(red: 0.14, green: 0.16, blue: 0.22, alpha: 1)
        return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    class func formerSubColor() -> UIColor {
        //return UIColor(red: 0.9, green: 0.55, blue: 0.08, alpha: 1)
        return UIColor(red: 0, green: 201/255, blue: 1, alpha: 1)
    }
    
    class func formerHighlightedSubColor() -> UIColor {
        return UIColor(red: 1, green: 0.7, blue: 0.12, alpha: 1)
    }
    
    class func formerBackgroundColor() -> UIColor {
        return UIColor(red: 0.23, green: 0.23, blue: 0.23, alpha: 0.6)
    }
}

extension String {
    
    static func mediumDateShortTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
    
    static func mediumDateNoTime(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }
    
    static func fullDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .full
        return dateFormatter.string(from: date)
    }
}


