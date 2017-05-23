//
//  WSStationController.swift
//  12306foriPhone
//
//  Created by WS on 2017/5/22.
//  Copyright © 2017年 WS. All rights reserved.
//

import UIKit

class WSStationController: UIViewController {
    
    var tableView: UITableView!
    var searchController: UISearchController!
    
    let allInitials: [String] = WSStationNameJs.sharedInstance.allInitials
    let allStation: [WSStation] = WSStationNameJs.sharedInstance.allStation
    let allStationMap: [String: [WSStation]] = WSStationNameJs.sharedInstance.allStationMap
    let searchResultController: WSSearchStationController = WSSearchStationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        configSubViews()
    }


    //MARK:- layout
    private func configSubViews() {
        
        self.tableView = UITableView(frame: self.view.bounds)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView)
        
        
        self.searchController = UISearchController(searchResultsController: searchResultController)
        self.searchController.searchResultsUpdater = self;
        self.searchController.dimsBackgroundDuringPresentation = false;
        
        searchController.searchBar.sizeToFit()
        
        self.searchController.searchBar.backgroundColor = .blue;
        self.tableView.tableHeaderView = self.searchController.searchBar;
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
        cell?.textLabel?.text = allStationMap[allInitials[indexPath.section]]![indexPath.row].Name
        return cell!
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return WSStationNameJs.sharedInstance.allInitials
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return allInitials[section]
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
