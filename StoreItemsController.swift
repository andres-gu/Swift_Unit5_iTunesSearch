//
//  StoreItemsController.swift
//  iTunesSearch
//
//  Created by Andres Gutierrez on 1/30/18.
//  Copyright © 2018 Andres Gutierrez. All rights reserved.
//

import Foundation


struct StoreItemsController {
    func fetchItems(matching query: [String: String], completion: @escaping ([StoreItem]?) -> Void) {
        
        let baseUrl = URL(string: "https://itunes.apple.com/search?")!
        
        guard let url = baseUrl.withQueries(query) else {
            completion(nil)
            print("Unable to build URL with supplied queries.")
            return
        }
        
        let apiTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let storeItems = try? jsonDecoder.decode(StoreItems.self, from: data) {
                completion(storeItems.results)
            } else {
                print("No data was returned or was not properly decoded.")
                completion(nil)
            }
        }
        
        apiTask.resume()
    }
}
