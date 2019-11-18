//
//  NetworkInterface.swift
//  NetworkClient
//
//  Created by Smirnov Maxim on 19/07/2017.
//  Copyright © 2017 SmirnovMaxim. All rights reserved.
//

import UIKit

public typealias NetworkInterface = GetableNetworkClient & PostableNetworkClient & NetworkImageUploader & NetworkSettings

public protocol NetworkSession {
    func loadData(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> ())
}

public protocol GetableNetworkClient {
    
    func getJSONRequest(_ url:String, parameters: [String : Any?]?, completionHandler: ((Result <JSON?, ServerResponseFailure>) -> ())?)
    func getJSONRequest(_ url:String, completionHandler: ((Result <JSON?, ServerResponseFailure>) -> ())?)
    
}

public protocol PostableNetworkClient {
    
    func postJSONRequest(_ url:String, parameters: [String:Any?]?, completionHandler: ((Result <JSON?, ServerResponseFailure>) -> ())?)
    func postJSONRequest(_ url:String, completionHandler: ((Result <JSON?, ServerResponseFailure>) -> ())?)
    func postMultipartRequest(_ url:String, body:Data?, cached: Bool, completionHandler: ((Result <JSON?, ServerResponseFailure>) -> ())?)
    
}

public protocol NetworkImageUploader {
    func uploadImage(_ image:UIImage?, urlSig:String, completionHandler: ((Result <JSON?, ServerResponseFailure>) -> ())?)
}

public protocol NetworkSettings: class {
    
    var timeout: Double { get set }
    var session: NetworkSession { get set }

}

public extension GetableNetworkClient {
    public func getJSONRequest(_ url:String, completionHandler: ((Result <JSON?, ServerResponseFailure>) -> ())?) {
        getJSONRequest(url, parameters: nil, completionHandler: completionHandler)
    }
}

public extension PostableNetworkClient {
    public func postJSONRequest(_ url:String, completionHandler: ((Result <JSON?, ServerResponseFailure>) -> ())?) {
        postJSONRequest(url, parameters: nil, completionHandler: completionHandler)
    }
}
