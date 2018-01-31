import UIKit
import XCTest
import Updraft

class Tests: XCTestCase {
    
    func testMissingFeatureFile() {
        let featureFile = FeatureFile(name: "bogus feature file", testCase: self)
        
        XCTAssertThrowsError(try featureFile.run())
    }
    
    func testCommentParsing() {
        let featureFile = FeatureFile(name: "comment.feature", testCase: self)
        
        XCTAssertNoThrow(try featureFile.run())
    }
    
    func testIgnoreTagsParsing() {
        let featureFile = FeatureFile(name: "ignoreTags.feature", testCase: self)
        
        XCTAssertNoThrow(try featureFile.run())
    }
    
    func testFeatureDescription() {
        let featureFile = FeatureFile(name: "ViewTermsAndConditionsOfUse.feature", testCase: self)
        
        XCTAssertNoThrow(try featureFile.run())
    }
    
    func testArrayFeature() {
        var array: [Int] = []
        
        let featureFile = FeatureFile(name: "An array.feature", testCase: self)
        
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
        
        XCTAssertNoThrow(try featureFile.run())
    }
    
}
