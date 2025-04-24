//
//  APIKeys.swift
//  Contact-App
//
//  Created by RNF-Dev on 24/04/25.
//




import Foundation
import UIKit


struct APIKeys {
    static var base_Url = "https://reqres.in/api/"
    
    struct Endpoint {
        static var users = "users"

    }
    
}


class Helper {
    @MainActor
    class func getImgFromUrl(imgView: UIImageView, url: String) {
        guard let imageUrl = URL(string: url) else {
            imgView.image = UIImage(named: "placeHolder")
            return
        }

        // Set placeholder image first
        imgView.image = UIImage(named: "placeHolder")

        // Fetch the image data using URLSession
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            guard let data = data, error == nil,
                  let image = UIImage(data: data) else {
                print("Failed to load image from URL: \(url)")
                return
            }

            // Update the image on the main thread
            DispatchQueue.main.async {
                imgView.image = image
            }
        }.resume()
    }
}
