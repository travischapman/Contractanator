//
//  PostViewController.swift
//  Contractanator
//
//  Created by Porter Frazier on 11/29/18.
//  Copyright © 2018 BULB. All rights reserved.
//

import UIKit

class PostViewController: UIViewController {
    
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var jobDescriptionTextView: UITextView!
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var button4: UIButton!
    @IBOutlet var button5: UIButton!
    @IBOutlet var button6: UIButton!
    @IBOutlet var button7: UIButton!
    @IBOutlet var button8: UIButton!
    @IBOutlet var button9: UIButton!
    @IBOutlet var button10: UIButton!
    @IBOutlet var button11: UIButton!
    @IBOutlet var button12: UIButton!
    @IBOutlet var postButton: UIButton!
    
    // These variables change based on the selection by the user
    var selectedJobType: JobType?
    var selectedJobTypeButton: UIButton?
    var vcThemeColor: UIColor? = UIColor.lightGray
    
    var selectedCriterias: [JobCriteria] = []
    var selectedCriteriaButtons: [UIButton] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button4.titleLabel?.adjustsFontSizeToFitWidth = true
        UIChanges()
        
        self.hideKeyboardWhenTappedAround()
        
        
    }
    
    
    fileprivate func turnOnButtonColor(_ sender: UIButton) {
        
        // Updates the view for the button tapped by the User
        sender.backgroundColor = vcThemeColor
        sender.layer.shadowColor = vcThemeColor?.cgColor
        sender.layer.shadowRadius = 4
        sender.layer.shadowOpacity = 1
        sender.layer.shadowOffset = CGSize(width: 0, height: 0)
        sender.layer.borderColor = vcThemeColor?.cgColor
        sender.setTitleColor(UIColor.white, for: .normal)
    }
    
    fileprivate func turnOffButtonColor(_ button: UIButton?) {
        
        guard let button = button else { return }
        // Restores the view for the button to its default
        button.backgroundColor = UIColor.white
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.layer.shadowColor = UIColor.white.cgColor
        
        if button != selectedJobTypeButton {
            
            button.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    fileprivate func updateVCThemeColor() {
        self.navigationController?.navigationBar.barTintColor = vcThemeColor
        _ = selectedCriteriaButtons.map({ turnOnButtonColor($0) })
        paySlider.tintColor = vcThemeColor
        postButton.backgroundColor = vcThemeColor
        postButton.layer.shadowColor = vcThemeColor?.cgColor
        postButton.layer.borderColor = vcThemeColor?.cgColor
        postButton.layer.shadowOpacity = 2.0
        postButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        postButton.setTitleColor(UIColor.white, for: .normal)
    }
    
    @IBAction func jobTypeButtonTapped(_ sender: UIButton) {
        
        var jobType: JobType?
        
        switch sender.restorationIdentifier {
        case "contracting":
            jobType = JobType.generalContracting
            vcThemeColor = UIColor(named: "CoolOrange")
        case "electrical":
            jobType = JobType.electrical
            vcThemeColor = UIColor(named: "CoolBlue")
        case "handyman":
            jobType = JobType.handyman
            vcThemeColor = UIColor(named: "UrineYellow")
        case "interiorDesign":
            jobType = JobType.interiorDesign
            vcThemeColor = UIColor(named: "RudeRed")
        case "homeRenno":
            jobType = JobType.homeRenovation
            vcThemeColor = UIColor(named: "PopsiclePurple")
        case "landscaping":
            jobType = JobType.landscaping
            vcThemeColor = UIColor(named: "GrassyGreen")
        default:
            print("Something went wrong!")
        }
        
        if jobType != selectedJobType {
            
            // Updates the theme accross the entire view
            turnOnButtonColor(sender)
            updateVCThemeColor()
            
            // Turn off the color on the previously selected button
            turnOffButtonColor(selectedJobTypeButton)
            
            // Make the sender/tapped button the new selected button
            selectedJobTypeButton = sender
            selectedJobType = jobType
        }
    }
    
    
    @IBAction func criteriaButtonTapped(_ sender: UIButton) {
        
        var criteria: JobCriteria?
        
        switch sender.restorationIdentifier {
        case "team":
            criteria = JobCriteria.fullTeam
        case "quality":
            criteria = JobCriteria.highQuality
        case "specalized":
            criteria = JobCriteria.specialized
        case "fast":
            criteria = JobCriteria.fast
        case "experienced":
            criteria = JobCriteria.experienced
        case "affordable":
            criteria = JobCriteria.affordable
            
        default:
            print("something went wrong")
        }
        
        guard let unwrappedCriteria = criteria else { return }
        if selectedCriterias.contains(unwrappedCriteria) {
            let index = selectedCriterias.firstIndex(of: unwrappedCriteria)
            selectedCriterias.remove(at: index!)
            selectedCriteriaButtons.remove(at: index!)
            turnOffButtonColor(sender)
        } else {
            selectedCriterias.append(unwrappedCriteria)
            selectedCriteriaButtons.append(sender)
            turnOnButtonColor(sender)
        }
    }
    
    @IBAction func postButtonTapped(_ sender: UIButton) {
        
        guard let title = titleTextField.text, !title.isEmpty,
            let description = jobDescriptionTextView.text, !description.isEmpty,
            let jobType = selectedJobType,
            selectedCriterias.count == 3
            else { print("Missing info") ; return  }
        
        let hourlyPay = Int(paySlider.value)
        let zipCode = "84041"
        
        if (UserController.shared.loggedInUser != nil) {
            JobListingController.shared.postJobListing(withTitle: title, description: description, jobType: jobType,
                                                       criteria: selectedCriterias, hourlyPay: hourlyPay,
                                                       zipCode: zipCode) { (success) in
                if success {
                    print("Posted:):)")
                } else {
                    print("WompWompWompppp...")
                }
            }
        } else {
            print("Need to sign up")
        }
    }
    
    //Slider Code
    
    
    @IBOutlet weak var sliderValueLabel: UILabel!
    
    @IBOutlet var paySlider: UISlider!
    
    @IBAction func sliderValueChange(_ sender: UISlider) {
        
        let currentValue = Int(sender.value)
        
        sliderValueLabel.text = "$\(currentValue)/hr"
        
        
    }
    
    
    func UIChanges() {
        
        
        titleTextField.layer.cornerRadius = 15.0
        titleTextField.layer.borderWidth = 1.0
        titleTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        jobDescriptionTextView.layer.cornerRadius = 18.0
        jobDescriptionTextView.layer.borderWidth = 1.0
        jobDescriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        button1.layer.cornerRadius = 18.0
        button1.layer.borderWidth = 1.0
        button1.layer.borderColor = UIColor(named: "CoolOrange")?.cgColor
        
        
        button2.layer.cornerRadius = 18.0
        button2.layer.borderWidth = 1.0
        button2.layer.borderColor = UIColor(named: "CoolBlue")?.cgColor
        
        button3.layer.cornerRadius = 18.0
        button3.layer.borderWidth = 1.0
        button3.layer.borderColor = UIColor(named: "UrineYellow")?.cgColor
        
        button4.layer.cornerRadius = 18.0
        button4.layer.borderWidth = 1.0
        button4.layer.borderColor = UIColor(named: "RudeRed")?.cgColor
        
        button5.layer.cornerRadius = 18.0
        button5.layer.borderWidth = 1.0
        button5.layer.borderColor = UIColor(named: "PopsiclePurple")?.cgColor
        
        button6.layer.cornerRadius = 18.0
        button6.layer.borderWidth = 1.0
        button6.layer.borderColor = UIColor(named: "GrassyGreen")?.cgColor
        
        button7.layer.cornerRadius = 18.0
        button7.layer.borderWidth = 1.0
        button7.layer.borderColor = UIColor.lightGray.cgColor
        
        button8.layer.cornerRadius = 18.0
        button8.layer.borderWidth = 1.0
        button8.layer.borderColor = UIColor.lightGray.cgColor
        
        button9.layer.cornerRadius = 18.0
        button9.layer.borderWidth = 1.0
        button9.layer.borderColor = UIColor.lightGray.cgColor
        
        button10.layer.cornerRadius = 18.0
        button10.layer.borderWidth = 1.0
        button10.layer.borderColor = UIColor.lightGray.cgColor
        
        button11.layer.cornerRadius = 18.0
        button11.layer.borderWidth = 1.0
        button11.layer.borderColor = UIColor.lightGray.cgColor
        
        button12.layer.cornerRadius = 18.0
        button12.layer.borderWidth = 1.0
        button12.layer.borderColor = UIColor.lightGray.cgColor
        
        paySlider.tintColor = UIColor.gray
        
        postButton.layer.cornerRadius = 24.0
        postButton.layer.borderWidth = 1.0
        postButton.layer.borderColor = UIColor.gray.cgColor
        
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}


//THis dismisses the keyboard when tapped off the screen. Call function in view controller(viewDidLoad) to add
extension UIViewController {
    
    @objc func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
