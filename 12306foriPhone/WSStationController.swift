//
//  WSStationController.swift
//  12306foriPhone
//
//  Created by WS on 2017/5/22.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

class WSStationController: UIViewController {
    
    var selectBlock: ((WSStation)->())?
    var tableView: UITableView!
    var searchController: UISearchController!
    
    let allInitials: [String] = WSStationNameJs.sharedInstance.allInitials
    let allStation: [WSStation] = WSStationNameJs.sharedInstance.allStation
    let allStationMap: [String: [WSStation]] = WSStationNameJs.sharedInstance.allStationMap
    let searchResultController: WSSearchStationController = WSSearchStationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        configSubViews()
        registerSearchResultControllerSelectBlock()
    }


//MARK:- layout
    private func configSubViews() {
        
        tableView = UITableView(frame: self.view.bounds)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(self.tableView)
        
        searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchResultsUpdater = self;
        searchController.dimsBackgroundDuringPresentation = false;
        
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = self.searchController.searchBar;
    }
    
//MARK:- action response
    private func registerSearchResultControllerSelectBlock() {
        searchResultController.selectBlock = { station in
            
            self.didSelectItem(station)
        }
    }
    
    fileprivate func didSelectItem(_ item: WSStation) {
        
        searchController.dismiss(animated: true, completion: nil)
        searchController.isActive = false
        if let block = self.selectBlock {
            block(item)
        }
        navigationController?.popViewController(animated: true)
    }
}

extension WSStationController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return allInitials.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return allStationMap[allInitials[section]]!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.textColor = UIColor(hexString: "555555")
        cell?.textLabel?.font = UIFont.init(name: "Helvetica Neue", size: 14)
        cell?.textLabel?.text = allStationMap[allInitials[indexPath.section]]![indexPath.row].Name
        return cell!
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return WSStationNameJs.sharedInstance.allInitials
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return allInitials[section]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        didSelectItem(allStationMap[allInitials[indexPath.section]]![indexPath.row])
    }
}

extension WSStationController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String) {
        
        var filteredStation: [WSStation] = [WSStation]()
        filteredStation.removeAll()
        if searchText != "" {
            filteredStation = allStation.filter({ (station) -> Bool in
                return (station.Name.contains(searchText) || station.FirstLetter.contains(searchText.lowercased()))
            })
        }
        
        DispatchQueue.main.async {
            self.searchResultController.filteredStation = filteredStation
        }
        
    }
}
