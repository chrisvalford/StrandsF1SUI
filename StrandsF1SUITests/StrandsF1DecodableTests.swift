//
//  StrandsF1DecodableTests.swift
//  StrandsF1SUITests
//
//  Created by Christopher Alford on 7/8/23.
//

import XCTest

final class StrandsF1DecodableTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func testDriverDecode() throws {
        let driverJSON = "{\"driverId\":\"albon\",\"permanentNumber\":\"23\",\"code\":\"ALB\",\"url\":\"http://en.wikipedia.org/wiki/Alexander_Albon\",\"givenName\":\"Alexander\",\"familyName\":\"Albon\",\"dateOfBirth\":\"1996-03-23\",\"nationality\":\"Thai\"}"
        let data = Data(driverJSON.utf8)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        let obj = try decoder.decode(Driver.self, from: data)
        XCTAssert(obj.givenName == "Alexander")
        let dob = dateFormatter.date(from: "1996-03-23")
        XCTAssert(obj.dateOfBirth == dob)
    }
}
