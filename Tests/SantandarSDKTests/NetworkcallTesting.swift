//
//  NetworkcallTesting.swift
//  
//
//  Created by Vipin Chaudhary on 07/09/22.
//

import XCTest
@testable import SantandarSDK

class NetworkcallTesting: XCTestCase {

    
    func testAPI_CheckResponse() throws {
        let obj = FrameworkClass()
        let baseUrl = "https://reqres.in/api/"
        let expectation = self.expectation(description: "CheckResponse")
        obj.APICll(baseUrl: baseUrl, body: [:], view: UIViewController().self) { isSucess in

                print("Api result is in inside --------- \(isSucess)")
                XCTAssertEqual(isSucess, true)
               // XCTAssert(isSucess == "tkkrue3", "statusCode is not matching the server data")
           
            expectation.fulfill()
        }
        waitForExpectations(timeout: 15.0, handler: nil)
    }
    
    func testHasUsers() {
        let welcome   = Welcome(data: DataClass(id: 12, name: "Vipin", year: 2002, color: "red", pantoneValue: ""), support: Support(url: "https://en.wikipedia.org/wiki/Mukesh_Khanna", text: "Value"))
        XCTAssertTrue(welcome.support.url == "https://en.wikipedia.org/wiki/Mukesh_Khanna")
        
        }
    func testAPI_Response_error() throws {
        //let obj = FrameworkClass()
        let baseUrl = "" //"https://reqres.in/api/products/3"
        let expectation = self.expectation(description: "Response_error")
        APICall.getInformation(url: URL(string: baseUrl), type: Welcome.self) { result in
          
            switch result{
            case .success(let welcome):
               // print(welcome)
                XCTAssertEqual(welcome.data.name, "true red")
            case .failure(let error):
                print(error.localizedDescription)
                XCTAssertEqual(error.self as! CustomError, CustomError.invalidUrl)
            
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testAPI_Response_PostGet_Error() throws {
        //let obj = FrameworkClass()
        let baseUrl = "" //"https://reqres.in/api/products/3"
        let expectation = self.expectation(description: "PostGet_Error")
        APICall.getInformation(url: URL(string: baseUrl), type: Welcome.self) { result in
          
            switch result{
            case .success(let welcome):
               // print(welcome)
                XCTAssertEqual(welcome.data.name, "true red")
            case .failure(let error):
                print(error.localizedDescription)
                XCTAssertEqual(error.self as! CustomError, CustomError.invalidUrl)
            
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_Response_PostRequest_Error() throws {
        let baseUrl = "https://reqres.in/api/products/3"
        let expectation = self.expectation(description: "PostRequest_Error")
        let http = HttpUtility()
        http.postService(methodName: .POST, url: URL(string: baseUrl), type: Welcome.self, body: ["userName":"Vipin Chaudhary"]) { result in
            switch result{
            case .success(let welcome):
               // print(welcome)
                XCTAssertEqual(welcome.data.name, "true red")
            case .failure(let error):
                print(error.localizedDescription)
                //XCTAssertEqual(error, nil)
                XCTAssertEqual(error.localizedDescription, "The data couldn’t be read because it is missing.")
            
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }

}
