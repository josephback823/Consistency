//
//  WorkOutDetailTableViewController.swift
//  Consistency
//
//  Created by Joseph Sanghyun Back on 5/7/21.
//

import UIKit

class WorkOutDetailTableViewController: UITableViewController {

    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var summaryView: UITextView!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var pauseButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
    @IBOutlet weak var addSeconds: UIButton!
    
    @IBOutlet weak var minusSeconds: UIButton!
    
    
    var logItem: LogItem!
    var timer = Timer()
    var seconds = 60
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if logItem == nil {
            logItem = LogItem(date: Date(), name: "", summary: "")
        }
        nameField.text = logItem.name
        datePicker.date = logItem.date
        summaryView.text = logItem.summary
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        logItem = LogItem(date: datePicker.date, name: nameField.text!, summary: summaryView.text)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
            let isPresentingInAddMode = presentingViewController is UINavigationController
            if isPresentingInAddMode {
                dismiss(animated: true, completion: nil)
            } else{
                navigationController?.popViewController(animated: true)
            }
    }
    
    @IBAction func startButton(_ sender: UIButton) {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(WorkOutDetailTableViewController.timerClass), userInfo: nil, repeats: true)
    }
    
    @IBAction func pauseButton(_ sender: UIButton) {
        timer.invalidate()
    }
    
    @IBAction func resetButton(_ sender: UIButton) {
        timer.invalidate()
        seconds = 60
        timerLabel.text = String(seconds)
    }
    
    @IBAction func addSeconds(_ sender: UIButton) {
        seconds = seconds + 10
        timerLabel.text = String(seconds)
    }
    
    
    @IBAction func minusSeconds(_ sender: UIButton) {
        seconds = seconds - 10
        timerLabel.text = String(seconds)
    }
    
    @objc func timerClass() {
        seconds -= 1
        timerLabel.text = String(seconds)
        
        if (seconds == 0) {
            timer.invalidate()
        }
    }
    
}
