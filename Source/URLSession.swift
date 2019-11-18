//
//  URLSession.swift
//  NetworkClient
//
//  Created by Maxim Smirnov on 18/01/2018.
//  Copyright © 2018 Maxim Smirnov. All rights reserved.
//

import Foundation

extension URLSession: NetworkSession {
    
    public func loadData(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ()) {
        dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
}
