//
//  ContactModel.swift
//  Contact-App
//
//  Created by RNF-Dev on 24/04/25.
//

import Foundation

/// Root model representing the contact response from the server
struct ContactModel: Codable {
    
    /// Current page number
    var pages: Int?
    
    /// Total number of pages available
    var total_pages: Int?
    
    /// List of individual contact entries
    var data: [DataModel]?
    
    /// Custom initializer to decode JSON with optional values
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decodeIfPresent([DataModel].self, forKey: .data)
        self.pages = try container.decodeIfPresent(Int.self, forKey: .pages)
        self.total_pages = try container.decodeIfPresent(Int.self, forKey: .total_pages)
    }
}

/// Model representing an individual contact/user
struct DataModel: Codable {
    
    /// User's email address
    var email: String?
    
    /// User's first name
    var first_name: String?
    
    /// User's last name
    var last_name: String?
    
    /// URL string of user's avatar image
    var avatar: String?
    
    /// Custom initializer to decode optional contact fields
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.first_name = try container.decodeIfPresent(String.self, forKey: .first_name)
        self.last_name = try container.decodeIfPresent(String.self, forKey: .last_name)
        self.avatar = try container.decodeIfPresent(String.self, forKey: .avatar)
    }
}
