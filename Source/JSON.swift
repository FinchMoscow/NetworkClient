//
//  JSON.swift
//  NetworkClient
//
//  Created by Smirnov Maxim on 31/08/2017.
//  Copyright © 2017 SmirnovMaxim. All rights reserved.
//

import Foundation

public struct JSON {
    
    public typealias Dictionary = [String : Any]
    public typealias Array = [Dictionary]
    
    let data: Data
    fileprivate var _dictionary: Dictionary?
    fileprivate var _array: Array?
    
}

extension JSON {
    
    init?(_ data: Data) {
        
        self.data = data
        
        guard value != nil else {
            return nil
        }
        
    }
    
    init?(_ dictionary: Dictionary) {
        
        self._dictionary = dictionary
        
        guard let data = try? JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions()) else {
            return nil
        }
        
        self.data = data
        
    }
    
    init?(_ array: Array) {
        
        self._array = array
        
        guard let data = try? JSONSerialization.data(withJSONObject: array, options: JSONSerialization.WritingOptions()) else {
            return nil
        }
        
        self.data = data
        
    }
    
}

public extension JSON {
    
    enum Value {
        
        case dictionary(Dictionary)
        case array(Array)
        
    }
    
    public var value: Value? {
        
        guard let anyJSON = anyJSON else {
            return nil
        }
        
        if let dictionary = anyJSON as? Dictionary {
            return .dictionary(dictionary)
        }
        
        if let array = anyJSON as? Array {
            return .array(array)
        }
        
        return nil
    }
    
    private var anyJSON: Any? {
        
        if let dictionary = _dictionary {
            return dictionary
        }
        
        if let array = _array {
            return array
        }
        
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
    }
    
    public var array: Array? {
        
        if let array = _array {
            return array
        }
        
        guard let value = value else {
            return nil
        }
        
        switch value {
            
        case .array(let array):
            return array
            
        default:
            return nil
            
        }
        
    }
    
    public var dictionary: Dictionary? {
        
        if let dictionary = _dictionary {
            return dictionary
        }
        
        guard let value = value else {
            return nil
        }
        
        switch value {
            
        case .dictionary(let dictionary):
            return dictionary
            
        default:
            return nil
            
        }
        
    }
    
}
