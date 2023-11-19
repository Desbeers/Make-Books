//
//  Debug.swift
//  Make Books
//
//  Created by Nick Berendsen on 24/07/2023.
//

import Foundation

/// Print raw JSON to the console
func debugJsonResponse(data: Data) {
    do {
        if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
            print(jsonResult)
        }
    } catch let error {
        print(error.localizedDescription)
    }
}
