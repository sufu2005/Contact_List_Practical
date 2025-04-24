//
//  ContactViewModel.swift
//  Contact-App
//
//  Created by RNF-Dev on 24/04/25.
//

import Foundation

/// ViewModel for managing contact list and pagination
class ContactViewModel: NSObject {
    
    /// Holds the full list of fetched contacts
    var contactdata: ContactModel?
    
    /// Current page number for pagination
    var currentPage = 1
    
    /// Flag to prevent multiple pagination calls simultaneously
    private var isLoading = false
    
    /// Fetch contacts with pagination
    /// - Parameter completion: Returns `true` on success, `false` on failure
    func getData(completion: @escaping (Bool) -> Void) {
        guard !isLoading else { return }
        isLoading = true
        
        // Compose URL
        let url = APIKeys.base_Url + APIKeys.Endpoint.users
        
        // Define query parameters
        let parameters = ["page": currentPage, "per_page": 10]
        
        // Make network request
        NetworkCall(
            data: parameters,
            url: url,
            method: NetworkCall.Services.get.rawValue,
            isJSONRequest: false
        ).executeQuery { (result: Result<ContactModel, Error>) in
            self.isLoading = false
            
            switch result {
            case .success(let response):
                if self.currentPage == 1 {
                    // First page: replace data
                    self.contactdata = response
                } else {
                    // Next pages: append data
                    if let newData = response.data {
                        self.contactdata?.data?.append(contentsOf: newData)
                    }
                }
                
                // Increment page if not at the end
                self.currentPage += 1
                
                completion(true)
                
            case .failure(let error):
                print("Pagination error:", error.localizedDescription)
                completion(false)
            }
        }
    }
    
    /// Call this before fetching to check if more pages are available
    var hasMorePages: Bool {
        guard let totalPages = contactdata?.total_pages else { return true }
        return currentPage <= totalPages
    }
}
