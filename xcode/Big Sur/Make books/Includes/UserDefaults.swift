//
//  UserDefaultsPropertyWrapper.swift
//  SwiftUI-Mac
//
//  Created by Sarah Reichelt on 7/11/19.
//
// from https://www.avanderlee.com/swift/property-wrappers/

import Foundation

@propertyWrapper
struct UserDefault<T> {
    let key: String
    let defaultValue: T
    
    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

struct UserDefaultsConfig {

    @UserDefault("font_size", defaultValue: 1)
    static var fontSize: Int

    @UserDefault("paper_size", defaultValue: 1)
    static var paperSize: Int
    
    @UserDefault("pathBooks", defaultValue: FileManager.default.homeDirectoryForCurrentUser.path)
    static var pathBooks: String

    @UserDefault("pathExport", defaultValue: FileManager.default.homeDirectoryForCurrentUser.path)
    static var pathExport: String

}


