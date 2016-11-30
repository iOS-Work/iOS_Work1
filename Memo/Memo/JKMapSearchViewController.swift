//
//  JKMapSearchViewController.swift
//  Memo
//
//  Created by 刘琦 on 2016/11/30.
//  Copyright © 2016年 Liu. All rights reserved.
//

import UIKit

class JKMapSearchViewController: UITableViewController {
    
    lazy var searchResults = {
        return [AnyObject]()
    }()
    
    // 代理
    weak open var delegate: JKMapSearchViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.searchResults = []
        self.clearsSelectionOnViewWillAppear = true
        self.tableView.rowHeight = 55
        self.tableView.tableFooterView = UIView.init()
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.searchResults.count)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: JKLocationTableViewCell = JKLocationTableViewCell.cell(withTableView: tableView) as JKLocationTableViewCell
        
        // Configure the cell...
        let tip = self.searchResults[indexPath.row]
        cell.textLabel?.text = tip.district
        cell.detailTextLabel?.text = tip.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tip = self.searchResults[indexPath.row]
        self.delegate?.jkMapSearchViewController(didSelected: tip as! AMapTip)
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */

    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

// protocol
public protocol JKMapSearchViewControllerDelegate: NSObjectProtocol {
    func jkMapSearchViewController(didSelected item: AMapTip)
    
}
