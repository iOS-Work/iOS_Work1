//
//  Search.swift
//  Memo
//
//  Created by 刘琦 on 2016/11/26.
//  Copyright © 2016年 Liu. All rights reserved.
//

protocol SearchDelegate {
    func hideSearchView(status : Bool)
}

//import Foundation
import UIKit

class Search: UIView, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    //MARK: Properties
    let statusView: UIView = {
        let st = UIView.init(frame: UIApplication.shared.statusBarFrame)
        st.backgroundColor = UIColor.black
        st.alpha = 0.15
        return st
    }()
    
    lazy var searchView: UIView = {
        let sv = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: 68))
        sv.backgroundColor = UIColor.white
        sv.alpha = 0
        return sv
    }()
    lazy var backgroundView: UIView = {
        let bv = UIView.init(frame: self.frame)
        bv.backgroundColor = UIColor.black
        bv.alpha = 0
        return bv
    }()
    lazy var backButton: UIButton = {
        let bb = UIButton.init(frame: CGRect.init(x: 0, y: 25, width: 40, height: 40))
        bb.setBackgroundImage(UIImage.init(named: "search2"), for: [])
        //cancel search
//        bb.addTarget(self, action: #selector(Search.dismiss), for: .touchUpInside)
        return bb
    }()
    lazy var searchField: UITextField = {
        let sf = UITextField.init(frame: CGRect.init(x: 48, y: 20, width: self.frame.width - 50, height: 48))
        sf.placeholder = "Seach Memo"
//        sf.placeholderImageView = ""
        sf.keyboardAppearance = .dark
        return sf
    }()
    lazy var tableView: UITableView = {
        let tv: UITableView = UITableView.init(frame: CGRect.init(x: 0, y: 68, width: self.frame.width, height: 288))
        return tv
    }()
    var items = [String]()
    
    var delegate:SearchDelegate?
    
    //MARK: Methods
    func customization()  {
        self.addSubview(self.backgroundView)
        self.backgroundView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(Search.dismiss)))
        self.addSubview(self.searchView)
        self.searchView.addSubview(self.searchField)
        self.searchView.addSubview(self.backButton)
        self.tableView.register(searchCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundColor = UIColor.clear
        self.searchField.delegate = self
        self.addSubview(self.statusView)
    }
    
    func animate()  {
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundView.alpha = 0.5
            self.searchView.alpha = 1
            self.searchField.becomeFirstResponder()
        })
    }
    
    func  dismiss()  {
        searchText = self.searchField.text!
        searchItems = self.items
        searchStatus = 1
        self.searchField.text = ""
        self.items.removeAll()
        self.tableView.removeFromSuperview()
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundView.alpha = 0
            self.searchView.alpha = 0
            self.searchField.resignFirstResponder()
        }, completion: {(Bool) in
            self.delegate?.hideSearchView(status: true)
        })
//        super.reloadInputViews()
    }
    
    //MARK: TextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (self.searchField.text == "" || self.searchField.text == nil) {
            self.items = []
            self.tableView.removeFromSuperview()
        } else{
            self.items.removeAll()
            let acqList = globalList
            //这里把所有的数据库信息都存到了acqList里
            for list in acqList {
                if (list.memoContent?.localizedCaseInsensitiveContains(textField.text!))! {
                    self.items.append(list.memoContent!)
                }
                //self.items.append(list.memoContent!)
            }
            DispatchQueue.main.async(execute: {
                if self.items.count > 0  {
                    self.addSubview(self.tableView)
                } else {
                    self.tableView.removeFromSuperview()
                }
                self.tableView.reloadData()
            })
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (self.searchField.text == "" || self.searchField.text == nil) {
            self.items = []
            self.tableView.removeFromSuperview()
        } else{
            self.items.removeAll()
            let acqList = globalList
            //这里把所有的数据库信息都存到了acqList里
            for list in acqList {
                let checkText = textField.text! + string
                if (list.memoContent?.localizedCaseInsensitiveContains(checkText))! {
                    self.items.append(list.memoContent!)
                }
                //self.items.append(list.memoContent!)
            }
            DispatchQueue.main.async(execute: {
                if self.items.count > 0  {
                    self.addSubview(self.tableView)
                } else {
                    self.tableView.removeFromSuperview()
                }
            self.tableView.reloadData()
            })
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismiss()
        return true
    }
    
    //MARK: TableView Delegates and Datasources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! searchCell
        cell.itemLabel.text = items[indexPath.row]
//        cell.backgroundColor = UIColor.rbg(r: 245, g: 245, b: 245)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchField.text = items[indexPath.row]
        //选择相应的信息后的返回
        searchText = self.searchField.text!
        searchItems = self.items
        searchStatus = 2
        self.searchField.text = ""
        self.items.removeAll()
        self.tableView.removeFromSuperview()
        UIView.animate(withDuration: 0.2, animations: {
            self.backgroundView.alpha = 0
            self.searchView.alpha = 0
            self.searchField.resignFirstResponder()
        }, completion: {(Bool) in
            self.delegate?.hideSearchView(status: true)
        })
//        ShowMemoTableViewController.reloadInputViews(<#T##UIResponder#>)
    }
    
    //MARK: Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        customization()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        self.tableView.separatorStyle = .none
    }
}

class searchCell: UITableViewCell {
    
    lazy var itemLabel: UILabel = {
        let il: UILabel = UILabel.init(frame: CGRect.init(x: 48, y: 0, width: self.contentView.bounds.width - 48, height: self.contentView.bounds.height))
        il.textColor = UIColor.gray
        return il
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "Cell")
        self.addSubview(itemLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
