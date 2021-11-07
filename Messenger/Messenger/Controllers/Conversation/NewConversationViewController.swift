//
//  NewConversationViewController.swift
//  Messenger
//
//  Created by munira almallki on 27/03/1443 AH.
//

import UIKit
import JGProgressHUD
class NewConversationViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    private var users = [[String:String]]()
    private var hasFetched = false
    private var results = [[String:String]]()
    
    private let searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search For Users..."
        return searchBar
    }()

    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
  
    private let noResultsLabel : UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = "no Result"
        label.textAlignment = .center
        label.textColor = .green
        label.font = .systemFont(ofSize: 21 , weight: .medium)
        return label
    
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .done, target: self,
                                                            action: #selector(dismissSelf))
        searchBar.becomeFirstResponder()
       
    }
    @objc private func dismissSelf(){
         dismiss(animated: true, completion: nil)
     }
}
extension NewConversationViewController: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text , !text.replacingOccurrences(of: "", with: "").isEmpty else{
            return
        }
        results.removeAll()
        spinner.show(in: view)
        self.searchUser(query: text)
    }
    func searchUser(query: String){
        // check if array has firebase results
        if hasFetched{
        // if it does filter
            filterUsers(with: query)
        }else {
            // if not , fetch then filter
            DatabaseManger.shared.getAllUsers(completion: {[weak self] result in
                switch result {
                case .success(let usersCollections):
                    self?.users = usersCollections
                    self?.filterUsers(with: query)
                case .failure(let error):
                    print("Field to get users:\(error)")
                    
                }
            })
        }
        
    }
    func filterUsers(with term:String){
        // update the ui either show results or show no results  label
        guard hasFetched else {
            return
        }
        var results :[[String:String]] = self.users.filter({
            guard let name = $0["name"]?.lowercased()  else {
                return false
            }
            return name.hasPrefix(term.lowercased())
        })
        
        updateUI()
    }
    func updateUI(){
        if results.isEmpty{
            self.noResultsLabel.isHidden = false
            self.tableView.isHidden = true
        }else {
            self.noResultsLabel.isHidden = true
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
}
