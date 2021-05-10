//
//  RandomViewController.swift
//  Consistency
//
//  Created by Joseph Sanghyun Back on 5/7/21.
//

import UIKit

class RandomViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    
    let answerArray = ["BACK DAY!!!",
                       "CHEST DAY!!",
                       "Take a Break 😎",
                       "LEG DAY 🦵",
                       "ARMS 💪", "Cardio 🏃‍♀️", "Shoulders !!",
                        "Full Body 🏋️‍♀️"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resultLabel.text = ""

    }
    
    func getResult() {
        resultLabel.alpha = 0.0
        var randomPhrase: String
        repeat {
            randomPhrase = answerArray.randomElement()!
        } while randomPhrase == resultLabel.text
        resultLabel.text = randomPhrase
        UIView.animate(withDuration: 1.0, animations: {self.resultLabel.alpha = 1.0})
    }
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        getResult()
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        getResult()
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
        
    }
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
}
