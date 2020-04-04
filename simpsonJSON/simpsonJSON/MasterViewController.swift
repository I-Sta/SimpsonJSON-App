//
//  MasterViewController.swift
//  simpsonJSON
//
//  Created by Field Employee on 4/2/20.
//  Copyright © 2020 Field Employee. All rights reserved.
//

import UIKit



class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var objects = [Any]()
    var simsonObjects = [SimpsonCharact]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = editButtonItem
       
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
        navigationItem.rightBarButtonItem = addButton
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
            self.simpsonJsonParse()
               
               
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    func simpsonJsonParse() {
        if let url = URL(string: "http://api.duckduckgo.com/?q=simpsons+characters&format=json") {
            URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let json = try! JSONSerialization.jsonObject(with: data, options:[]) as? [String: Any]
                if let subjson = json!["RelatedTopics"] as? [[String: Any]] {
        
                    for item in subjson {
                        print(item["Text"])
                        let simson = SimpsonCharact()
                        guard let splitstring = item["Text"] as? String else{
                            return
                        }
                        var subcast = splitstring.components(separatedBy: " - ")
                        guard let name = item["Text"] as? String  else {
                            return
                        }
                        guard let description = item["Text"] as? String else{
                            return
                        }
                        
                        simson.name = subcast[0]
                        
                        simson.description = subcast[1]
                        if let image = item["Icon"] as? [String: Any] {
                            guard let imageUrl = image["URL"] as? String else{
                                 return
                            }
                           simson.image = imageUrl
                            print(imageUrl)
                        }
                        self.simsonObjects.append(simson)
                        
                        
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                     }
                 }.resume()
            
              }
       
    }
    @objc
    func insertNewObject(_ sender: Any) {
       tableView.reloadData()
    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = simsonObjects[indexPath.row] as! SimpsonCharact
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                detailViewController = controller
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return simsonObjects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let name = simsonObjects[indexPath.row].name
        cell.textLabel!.text = name
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            objects.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        } else if editingStyle == .insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//        }
//    }


}

