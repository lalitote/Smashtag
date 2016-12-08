//
//  Recent Searches.swift
//  
//
//  Created by lalitote on 08.12.2016.
//
//

import Foundation

class RecentSearches
{
    private struct Const {
        static let ValuesKey = "RecentSearches.Values"
        static let NumberOfSearches = 100
    }
    
    private let defaults = UserDefaults.standard
    
    var values: [String] {
        get {
            return defaults.object(forKey: Const.ValuesKey) as? [String] ?? []
        }
        set {
            defaults.set(newValue, forKey: Const.ValuesKey)
        }
    }
    
    func add(search: String) {
        var currentSearches = values
        if let index = currentSearches.index(of: search) {
            currentSearches.remove(at: index)
        }
        currentSearches.insert(search, at: 0)
        while currentSearches.count > Const.NumberOfSearches {
            currentSearches.removeLast()
        }
        values = currentSearches
    }
}
