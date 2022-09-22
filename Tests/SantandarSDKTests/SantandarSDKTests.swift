import XCTest
@testable import SantandarSDK

final class SantandarSDKTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SantandarSDK().text, "Hello, World!")
    }

    
    func test_Netavailablity() throws{
       // HttpUtility()
        let reachability =  Reachability()
        let networkStatus  = reachability?.currentReachabilityStatus
        
        if networkStatus == .notReachable {
            XCTAssertEqual(networkStatus, .notReachable)
        }
        if networkStatus == .reachableViaWiFi {
            XCTAssertEqual(networkStatus, .reachableViaWiFi)
        }
    }
    
}
