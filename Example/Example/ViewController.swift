//
//  ViewController.swift
//  Example
//
//  Created by Maxim Smirnov on 17/01/2018.
//  Copyright © 2018 Maxim Smirnov. All rights reserved.
//

import UIKit
import NetworkClient

class ViewController: UIViewController {

    let networkClient: GetableNetworkClient = {
        let client = NetworkClient()
        return client
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        networkClient.getJSONRequest("http://api.openweathermap.org/data/2.5/weather?q=Moscow&appid=228a74e57d51bf2a295dceba8a2fb0ef&units=metric") { result in
            
            switch result {
                
            case .success(let json):
                print("success")
                print(json?.dictionary as Any)
                
            case .failure(let resposeFailure):
                print("failure")
                print(resposeFailure.error as Any)
                
            }
            
        }
        
    }

}

