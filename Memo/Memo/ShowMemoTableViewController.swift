//
//  ShowMemoTableViewController.swift
//  Memo
//
//  Created by TaiyangLiu on 2016/11/25.
//  Copyright © 2016年 Liu. All rights reserved.
//

import UIKit

class ShowMemoTableViewController: UITableViewController, SearchDelegate{
    
    //var acqList = [Memo("Memo1"), Memo("Memo2"), Memo("Memo3"), Memo("Memo4"), Memo("Memo5")]
    var acqList = [MemoDataMO]()
    lazy var search: Search = {
        let se = Search.init(frame: UIScreen.main.bounds)
        se.delegate = self
        return se
    }()
    
    @IBAction func handleSearch(_ sender: Any) {
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(self.search)
            self.search.animate()
        }
        //不起作用
//        viewDidLoad()
    }
    
    //self.navigationController.navigationBar.barTintColor = [UIColor greenColor];

    override func viewDidLoad() {
        super.viewDidLoad()
        //用其他先加一个列表，显示所有信息，然后再看其他
        var acqAllList = [MemoDataMO]()
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate),
            let fetchedList = appDelegate.fetchContext() {
            //acqList += fetchedList
            acqAllList += fetchedList
        }
        acqList.removeAll()
        globalList = acqAllList
        if (searchStatus == 0) {
            acqList = acqAllList
        } else if (searchStatus == 1){
            if searchItems.isEmpty{
                acqList = acqAllList
            } else {
                for list in acqAllList {
                    for cell in searchItems {
                        if list.memoContent == cell {
                            acqList.append(list)
                        }
                    }
                }
            }
            
        } else if (searchStatus == 2){
            for list in acqAllList {
                if list.memoContent == searchText {
                    acqList.append(list)
                }
            }
        } else {
            acqList = acqAllList
        }
//        for memo in acqList {
//            if let mContent = memo?.mContent {
//                memo?.mImage = UIImage(named: mContent)
//                memo?.mTime = "11.26"
//            } }
        //self.navigationController?.navigationBar.barTintColor = UIColor.white
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return acqList.count
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { let cell = tableView.dequeueReusableCell(withIdentifier: "MemoListCell", for: indexPath)
//        // Configure the cell...
//        cell.imageView?.image = UIImage(named: acqList[indexPath.row])
//        cell.textLabel?.text = acqList[indexPath.row]
//        cell.detailTextLabel?.text = "This is a memo for " + acqList[indexPath.row]
//        return cell }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoListCell", for: indexPath) as!
        MemoListTableViewCell
        let memo = acqList[indexPath.row]
        // Configure the cell...
       // let mImage = memo?.mImage
       // cell.alongImageView.image = UIImage(data: memo.memoImage!)
        cell.memoContent.text = memo.memoContent
        //cell.memoTime.text = String(describing: memo.memoDay) + String(describing: memo.memoTime)
        return cell }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let memo = acqList[indexPath.row]
            if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
                appDelegate.deleteFromContext(memo: memo)
                acqList.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail",
        let indexPath = tableView.indexPathForSelectedRow,
        let detailViewController = segue.destination as? DetailViewController { detailViewController.memo = acqList[indexPath.row]
        }
        
    }
    
    //MARK: Delegates implementation
    func didSelectItem(atIndex: Int) {
        //        self.collectionView.scrollRectToVisible(CGRect.init(origin: CGPoint.init(x: (self.view.bounds.width * CGFloat(atIndex)), y: 0), size: self.view.bounds.size), animated: true)
        //do something to init
    }
    func hideSearchView(status : Bool){
        if status == true {
            self.search.removeFromSuperview()
        }
        print("close")
        print("\(searchStatus)")
        viewDidLoad()
        tableView.reloadData()
    }

    @IBAction func unwindToShowMemo(segue:UIStoryboardSegue) {
        if segue.identifier == "unwindToShowMemo",
            let editMemoViewController = segue.source as? EditMemoViewController,
            let memo = editMemoViewController.memo {
            if let selectedIndexPath = tableView.indexPathForSelectedRow { // Update an existing memo.
                acqList[(selectedIndexPath as NSIndexPath).row] = memo
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                // Add a new memo.
                let newIndexPath = IndexPath(row: acqList.count, section: 0)
                acqList.append(memo)
                tableView.insertRows(at: [newIndexPath], with: .bottom) }
        }
    }

}
