//
//  RecordViewController.swift
//  GeoLocationTracking
//
//  Created by takami228 on 2018/05/27.
//  Copyright © 2018年 takami228. All rights reserved.
//

import UIKit

class RecordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(_ table: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordDateArray.count
    }
    
    func tableView(_ table: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "record", for: indexPath)
        let dateLabel = cell.viewWithTag(1) as! UILabel
        dateLabel.text = recordDateArray[indexPath.row]
        
        let distanceLabel = cell.viewWithTag(2) as! UILabel
        distanceLabel.text = recordTimeArray[indexPath.row]

        let recordLabel = cell.viewWithTag(3) as! UILabel
        recordLabel.text = recordDistanceArray[indexPath.row]

        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
