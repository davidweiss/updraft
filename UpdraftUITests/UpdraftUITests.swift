//
//  UpdraftUITests.swift
//  UpdraftUITests
//
//  Created by David Weiss on 1/23/18.
//  Copyright © 2018 David Weiss. All rights reserved.
//

import XCTest

class UpdraftUITests: XCTestCase {
    
    func testArrayFeature() {
        var array: [Int] = []
        
        let featureFile = FeatureFile(name: "An array")
        
        featureFile.given("^I have an empty array$") { match in
            array = []
        }
        
        featureFile.given("^I have an array with the numbers (\\d) through (\\d)$") { match in
            let start = match.groups[1]
            let end = match.groups[2]
            
            array = Array(Int(start)! ..< Int(end)!)
        }
        
        featureFile.when("^I add (\\d) to the array$") { match in
            let number = Int(match.groups[1])!
            array.append(number)
        }
        
        featureFile.when("^I filter the array for even numbers$") { match in
            array = array.filter { $0 % 2 == 0 }
        }
        
        featureFile.then("^I should have (\\d) items? in the array$") { match in
            let count = Int(match.groups[1])!
            XCTAssertEqual(array.count, count)
        }
        
        do {
            try featureFile.run()
        } catch {
            XCTFail()
        }
    }
}
