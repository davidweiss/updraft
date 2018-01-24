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
        
        let featureFile = FeatureFile(name: "An array.feature")
        
        featureFile.given("^an empty array$") { match in
            array = []
        }
        
        featureFile.when("^the number 1 is added to the array$") { match in
            array.append(1)
        }
        
        featureFile.then("^the array has (\\d) items$") { match in
            let itemCount = Int(match.groups[1])!
            XCTAssertEqual(array.count, itemCount)
        }
        
        featureFile.given("^an array with the numbers (\\d) through (\\d)$") { match in
            let start = Int(match.groups[1])!
            let end = Int(match.groups[2])!
            
            array = Array(start ..< end)
        }
        
        featureFile.when("^the array is filtered for even numbers$") { match in
            array = array.filter { $0 % 2 == 0 }
        }
        
        featureFile.run()
    }
}

