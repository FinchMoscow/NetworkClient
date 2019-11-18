//
//  Tests.swift
//  Tests
//
//  Created by Maxim Smirnov on 18/01/2018.
//  Copyright © 2018 Maxim Smirnov. All rights reserved.
//

import XCTest
@testable import NetworkClient

class NetworkSessionMock: NetworkSession {
    
    var data: Data?
    var error: Error?
    var response: URLResponse?
    var request: URLRequest?
    
    func loadData(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        self.request = request
        completionHandler(data, response, error)
    }
    
}

class Tests: XCTestCase {
    
    //MARK: - Properties
    
    let sut: NetworkClient = NetworkClient()
    
    //MARK: - Setup
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //MARK: - GET
    
    func testSuccessGet() {
        
        //given
        let session = NetworkSessionMock()
        sut.session = session
        
        guard let json = JSON(["key" : "value"]) else {
            XCTFail()
            return
        }
        session.data = json.data
        
        let url = "url"
        
        //when
        
        var result: Result <JSON?, ServerResponseFailure>?
        sut.getJSONRequest(url) { result = $0 }
        
        //then
        
        guard let jsonResult = result?.value ?? nil else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(jsonResult.dictionary!["key"] as! String, json.dictionary!["key"] as! String)
        
    }
    
    func testGetParams() {
        
        //given
        let session = NetworkSessionMock()
        sut.session = session
        
        let params: [String : Any] = ["key" : "value",
                                      "key1" : "value1",
                                      "number" : 1]
        
        let url = "url"
        
        //when
        sut.getJSONRequest(url, parameters: params, completionHandler: nil)
        
        //then
        
        let checkParams: Set = ["key=value", "number=1", "key1=value1"]
        let components = session.request?.url?.query?.components(separatedBy: "&")
        
        XCTAssertEqual(Set(components!), checkParams)
        
    }
    
    func testFailureGet() {
        
        //given
        let session = NetworkSessionMock()
        sut.session = session
        
        guard let json = JSON(["key" : "value"]) else {
            XCTFail()
            return
        }
        session.data = json.data
        session.error = NSError()
        
        let url = "url"
        
        //when
        
        var result: Result <JSON?, ServerResponseFailure>?
        sut.getJSONRequest(url) { result = $0 }
        
        //then
        
        XCTAssert(result?.isFailure == true)
        
    }
    
    func testServerFailureGet() {
        
        //given
        let session = NetworkSessionMock()
        sut.session = session
        
        guard let json = JSON(["key" : "value"]) else {
            XCTFail()
            return
        }
        session.data = json.data
        session.response = HTTPURLResponse(url: URL(string: "ya.ru")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        let url = "url"
        
        //when
        
        var result: Result <JSON?, ServerResponseFailure>?
        sut.getJSONRequest(url) { result = $0 }
        
        //then
        
        XCTAssert(result?.isFailure == true)
        
    }
    
    //MARK: - POST
    
    func testSuccessPost() {
        
        //given
        let session = NetworkSessionMock()
        sut.session = session
        
        guard let json = JSON(["key" : "value"]) else {
            XCTFail()
            return
        }
        session.data = json.data
        
        let url = "url"
        
        //when
        
        var result: Result <JSON?, ServerResponseFailure>?
        sut.postJSONRequest(url) { result = $0 }
        
        //then
        
        guard let jsonResult = result?.value ?? nil else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(jsonResult.dictionary!["key"] as! String, json.dictionary!["key"] as! String)
        
    }
    
    func testFailurePost() {
        
        //given
        let session = NetworkSessionMock()
        sut.session = session
        
        guard let json = JSON(["key" : "value"]) else {
            XCTFail()
            return
        }
        session.data = json.data
        session.error = NSError()
        
        let url = "url"
        
        //when
        
        var result: Result <JSON?, ServerResponseFailure>?
        sut.postJSONRequest(url) { result = $0 }
        
        //then
        
        XCTAssert(result?.isFailure == true)
        
    }
    
    func testServerFailurePost() {
        
        //given
        let session = NetworkSessionMock()
        sut.session = session
        
        guard let json = JSON(["key" : "value"]) else {
            XCTFail()
            return
        }
        session.data = json.data
        session.response = HTTPURLResponse(url: URL(string: "ya.ru")!, statusCode: 400, httpVersion: nil, headerFields: nil)
        
        let url = "url"
        
        //when
        
        var result: Result <JSON?, ServerResponseFailure>?
        sut.postJSONRequest(url) { result = $0 }
        
        //then
        
        XCTAssert(result?.isFailure == true)
        
    }
    
    func testPostParams() {
        
        //given
        let session = NetworkSessionMock()
        sut.session = session
        
        let params = JSON(["key" : "value",
                           "key1" : "value1",
                           "number" : 1])
        
        let url = "url"
        
        //when
        sut.postJSONRequest(url, parameters: params?.dictionary, completionHandler: nil)
        
        //then
        XCTAssertEqual(session.request!.httpBody, params!.data)
        
    }
    
    func testPostProper() {
        
        //given
        let session = NetworkSessionMock()
        sut.session = session
        
        let url = "url"
        
        //when
        sut.postJSONRequest(url, completionHandler: nil)
        
        //then
        XCTAssertEqual(session.request?.httpMethod, "POST")
        
    }
    
}
