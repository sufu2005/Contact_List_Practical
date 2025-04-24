//
//  ViewController.swift
//  Contact-App
//
//  Created by RNF-Dev on 24/04/25.
//

import UIKit

/// Main view controller that displays a list of contacts using a UITableView
class ViewController: UIViewController {
    
    /// Outlet for the table view displaying contact list
    @IBOutlet weak var tableviewoutlet: UITableView!
    
    /// ViewModel that handles data fetching and pagination logic
    let contactVM = ContactViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register custom table view cell from XIB
        self.tableviewoutlet.register(UINib(nibName: "ContactTVCell", bundle: nil), forCellReuseIdentifier: "ContactTVCell")
        
        // Initial data load
        getUsersData()
    }
    
    /// Fetches user data via the ViewModel and reloads the table view on success
    func getUsersData() {
        contactVM.getData { success in
            DispatchQueue.main.async {
                self.tableviewoutlet.reloadData()
            }
        }
    }
}

// MARK: - TableView Delegate & DataSource Methods

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    /// Returns the number of rows to display in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactVM.contactdata?.data?.count ?? 0
    }
    
    /// Configures and returns the cell for a given indexPath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTVCell") as! ContactTVCell
        if let data = contactVM.contactdata?.data?[indexPath.row] {
            cell.setData(data: data)
        }
        return cell
    }
    
    /// Returns the fixed height for each row in the table view
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    /// Called just before a cell is displayed. Used here to trigger pagination when the last cell appears.
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let totalCount = contactVM.contactdata?.data?.count else { return }
        
        // If this is the last cell and more pages are available, load next page
        if indexPath.row == totalCount - 1 && contactVM.hasMorePages {
            contactVM.getData { success in
                if success {
                    DispatchQueue.main.async {
                        self.tableviewoutlet.reloadData()
                    }
                }
            }
        }
    }
}
