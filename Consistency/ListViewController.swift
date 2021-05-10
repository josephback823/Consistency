//
//  ListViewController.swift
//  Consistency
//
//  Created by Joseph Sanghyun Back on 5/6/21.
//

import UIKit

class ListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    @IBOutlet weak var randomButton: UIBarButtonItem!
    
    
    @IBOutlet weak var locationButton: UIBarButtonItem!
    
    
    var logItems: [LogItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setUpToolBar()
        
        loadData()
                
    }
    
    func setUpToolBar(){
        navigationController?.isToolbarHidden = false
        navigationController?.toolbar.barTintColor = UIColor.systemBlue
        navigationController?.toolbar.tintColor = UIColor.white
    }
    
    
    func loadData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!

        let documentURL = directoryURL.appendingPathComponent("logs").appendingPathExtension("json")

        guard let data = try? Data(contentsOf: documentURL) else {return}

        let jsonDecoder = JSONDecoder()
        do{
            logItems = try jsonDecoder.decode(Array<LogItem>.self, from: data)
            tableView.reloadData()
        } catch {
            print("Error: Could not load data \(error.localizedDescription)")
        }
    }
    
    func saveData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
        
        let documentURL = directoryURL.appendingPathComponent("logs").appendingPathExtension("json")
        
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(logItems)
        do{
            try data?.write(to: documentURL, options: .noFileProtection)
        } catch {
            print("Error: Could not save data \(error.localizedDescription)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! WorkOutDetailTableViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.logItem = logItems[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    @IBAction func randomButtonPressed(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "ShowRandom", sender: self)
    }
    
    
    
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
        let source = segue.source as! WorkOutDetailTableViewController
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            logItems[selectedIndexPath.row] = source.logItem
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: logItems.count, section: 0)
            logItems.append(source.logItem)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
        saveData()
    }
 
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            sender.title = "Done"
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
            addBarButton.isEnabled = false
        }
    }
    
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = logItems[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            logItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = logItems[sourceIndexPath.row]
        logItems.remove(at: sourceIndexPath.row)
        logItems.insert(itemToMove, at: destinationIndexPath.row)
        saveData()
    }
}
