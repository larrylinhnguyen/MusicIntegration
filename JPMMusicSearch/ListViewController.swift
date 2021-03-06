//
//  ListViewController.swift
//  JPMMusicSearch
//
//  Created by Larry on 1/8/17.
//  Copyright © 2017 Savings iOS Dev. All rights reserved.
//

import UIKit

final class ListViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    let viewModel = ListViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTableView()
        
        setUpSearchController()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let indexPath = listTableView.indexPathForSelectedRow {
            listTableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    private func setUpTableView() {
        listTableView.delegate = self
        listTableView.dataSource = self
    }
    
    private func setUpSearchController() {
        //searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.backgroundColor = UIColor.blue
        definesPresentationContext = true
        listTableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowDetailViewController" {
            let detailViewController = segue.destination as! DetailViewController
            if let indexPath = listTableView.indexPathForSelectedRow {
                detailViewController.viewModel = viewModel.detailViewModel(for: indexPath)
            }
            
        }
    }
    
}



// MARK: - UITableViewDataSource methods
extension ListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath) as! ListItemCell
        
        // TODO: Check if is necessary to cancel download image for dequeued cells
        cell.viewModel = viewModel.listItelCellViewMode(for: indexPath)
        
        return cell
    }
}



// MARK: - UITableViewDelegate methods
extension ListViewController: UITableViewDelegate {
    
}



// MARK: - UISeacrBarDelegate methods
extension ListViewController: UISearchBarDelegate {
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            viewModel.search(for: text, completion: { [weak self] error in
                DispatchQueue.main.async(execute: {
                    self?.navigationItem.title = self?.viewModel.title
                    self?.searchController.isActive = false
                    
                    if error == nil {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self?.listTableView.reloadData()
                    } else {
                        //MARK: - create an alert here
                    }
                })
            })
            
        }
        
        return
    }
    
}

