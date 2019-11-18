//
//  ServerResponseFailure.swift
//  NetworkClient
//
//  Created by Smirnov Maxim on 20/07/2017.
//  Copyright © 2017 SmirnovMaxim. All rights reserved.
//

import Foundation

public struct ServerResponseFailure {
    
    public var data: Data?
    public var object: AnyObject?
    public var error: Error?
    
    public var statusCode: Int? {
        
        guard let response = object as? HTTPURLResponse else {
            return nil
        }
        
        return response.statusCode
    }
    
    public var json: JSON? {
        
        guard let data = data else {
            return nil
        }
        
        return JSON(data)
    }
    
    public init(data: Data? = nil, object: AnyObject? = nil, error: Error? = nil) {
        self.data = data
        self.object = object
        self.error = error
    }
    
}
