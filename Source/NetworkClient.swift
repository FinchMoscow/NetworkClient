//
//  NetworkClient.swift
//  NetworkClient
//
//  Created by Smirnov Maxim on 19/07/2017.
//  Copyright © 2017 SmirnovMaxim. All rights reserved.
//

import UIKit

open class NetworkClient: NetworkSettings {
    
    //MARK: - Init
    
    public init() {}
    
    // MARK: - Types
    
    private struct ServerResponse {
        var data: Data?
        var response: URLResponse?
    }
    
    private enum NetworkType {
        case GET([String:String]?)
        case POST([String:String]?,Data?)
    }
    
    // MARK: - Properties
    
    open var timeout: Double = 10.0
    private let boundary = "--WebKitFormBoundaryE19zNvXGzXaLvS5C"
    
    private var _session: NetworkSession = URLSession.shared
    open var session: NetworkSession {
        
        get {
            
            guard let updater = sessionUpdater else {
                return _session
            }
            
            return updater()
        }
        
        set {
            _session = newValue
        }
        
    }
    
    open var sessionUpdater: (() -> (URLSession))?
    
    // MARK: - Methods
    
    ///return url parametres
    private func returnParams(_ dict:[String:Any?],_ separator: String) -> String {
        let keys = Array(dict.keys)
        if keys.count > 0 {
            var result = separator
            for key: String in keys {
                
                if let param = dict[key], let realParam = param {
                    result = "\(result)\(key)=\(realParam)&"
                }
                
            }
            _ = result.removeLast()
            return result
        }
        return ""
    }
    
    ///return GET parameters
    private func getParams(_ dict:[String:Any?]) -> String {
        return returnParams(dict, "?")
    }
    
    ///return POST parameters
    private func postParams(_ dict:[String:Any?]) -> String {
        return returnParams(dict, "")
    }
    
    // MARK: - JSON
    
    private func tryToGetJson(fromResult result: Result <ServerResponse, ServerResponseFailure>, withUrl url: String?, completionHandler: ((Result <JSON?, ServerResponseFailure>) -> ())? = nil) {
        
        let json = getJson(fromData: result.value?.data)
        completionHandler?(Result.success(json))
        
    }
    
    private func getJson(fromData data: Data?) -> JSON? {
        
        guard let data = data else {
            return nil
        }
        
        return JSON(data)
    }
    
    // MARK: - Requests
    
    private func request(_ url:String, _ type: NetworkType, completionHandler: ((Result <ServerResponse, ServerResponseFailure>) -> ())?) {
        
        guard let URL = URL(string: url) else {
            completionHandler?(Result.failure(ServerResponseFailure(data: nil, object: nil, error: nil)))
            return
        }
        
        var request = URLRequest(url: URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: timeout)
        
        let headersSet = { (headers:[String:String]?) -> () in
            if let _ = headers {
                for h in headers!.keys {
                    request.addValue(headers![h] ?? "", forHTTPHeaderField: h)
                }
            }
        }
        
        switch type {
            
        case .GET(let headers):
            headersSet(headers)
            
        case .POST(let headers,let body):
            headersSet(headers)
            request.httpMethod = "POST"
            request.httpBody = body
            
        }
        
        session.loadData(with: request) { data, response, err in
            
            var isError = false
            if let _ = err {
                isError = true
            } else if let resp = response as? HTTPURLResponse, !(200..<300 ~= resp.statusCode) {
                isError = true
            }
            
            if isError {
                
                completionHandler?(Result.failure(ServerResponseFailure(data: data,
                                                                     object: response,
                                                                     error: err)))
                
            } else {
                
                completionHandler?(Result.success(ServerResponse(data: data, response: response)))
                
            }
            
            }
        
    }
    
}

extension NetworkClient: GetableNetworkClient {
    
    open func getJSONRequest(_ url:String, parameters: [String : Any?]?, completionHandler: ((Result <JSON?, ServerResponseFailure>) -> ())?) {
        
        var resultUrl = url
        
        var allowedParameters: [String : Any?] = [:]
        
        parameters?.forEach {
            
            if let value = $0.value as? String,
                
                let allowedValue = value.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) {
                allowedParameters[$0.key] = allowedValue
                
            } else {
                
                allowedParameters[$0.key] = $0.value
                
            }
            
        }
        
        let stringParams = self.getParams(allowedParameters)
        resultUrl += stringParams
        
        request(resultUrl,.GET(["Content-Type":"application/json"])) { result in
            
            switch result {
                
            case .success:
                self.tryToGetJson(fromResult: result, withUrl: url, completionHandler: completionHandler)
                
            case .failure(let errorValue):
                completionHandler?(Result.failure(errorValue))
                
            }
            
        }
        
    }
    
}

extension NetworkClient: PostableNetworkClient {
    
    open func postJSONRequest(_ url:String, parameters: [String:Any?]?, completionHandler: ((Result <JSON?, ServerResponseFailure>) -> ())?) {
        
        let JSON: [String:Any?] = parameters ?? [:]
        request(url,.POST(["Content-Type":"application/json"], try? JSONSerialization.data(withJSONObject: JSON, options: JSONSerialization.WritingOptions(rawValue:UInt(0))))) { result in
            
            switch result {
                
            case .success:
                self.tryToGetJson(fromResult: result, withUrl: url, completionHandler: completionHandler)
                
            case .failure(let errorValue):
                completionHandler?(Result.failure(errorValue))
                
            }
            
        }
        
    }
    
    open func postMultipartRequest(_ url:String, body:Data?, cached: Bool, completionHandler: ((Result <JSON?, ServerResponseFailure>) -> ())?) {
        
        request(url, .POST(["Content-Type":"multipart/form-data; boundary=\(boundary)"], body)) { result in
            
            switch result {
                
            case .success:
                self.tryToGetJson(fromResult: result, withUrl: url, completionHandler: completionHandler)
                
            case .failure(let errorValue):
                completionHandler?(Result.failure(errorValue))
                
            }
            
        }
        
    }
    
}

extension NetworkClient: NetworkImageUploader {
    
    open func uploadImage(_ image:UIImage?, urlSig:String, completionHandler: ((Result <JSON?, ServerResponseFailure>) -> ())?) {
        
        guard let _ = image else {
            completionHandler?(Result.failure(ServerResponseFailure(data: nil, object: nil, error: nil)))
            return
        }
        let url = "\(urlSig)"
        let body = NSMutableData()
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"media.jpg\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: image/jpeg\r\n".data(using: String.Encoding.utf8)!)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        if let imgData = UIImageJPEGRepresentation(image!, 0.5) {
            body.append(imgData)
        }
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        postMultipartRequest(url, body: body as Data, cached: false, completionHandler: completionHandler)
        
    }
    
}
