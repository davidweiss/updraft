//
//  Regex.swift
//  UpdraftUITests
//
//  Created by David Weiss on 1/23/18.
//  Copyright © 2018 David Weiss. All rights reserved.
//
//  based on: https://github.com/kylef/Ploughman
//
//  Note: This should go away once Swift has native Regex support...

import Foundation

public struct RegexMatch {
    let checkingResult: NSTextCheckingResult
    let value: String
    
    init(checkingResult: NSTextCheckingResult, value: String) {
        self.checkingResult = checkingResult
        self.value = value
    }
    
    public var groups: [String] {
        return (0..<checkingResult.numberOfRanges).map {
            let range = checkingResult.range(at: $0)
            return NSString(string: value).substring(with: range)
        }
    }
}

struct Regex : CustomStringConvertible {
    let expression: NSRegularExpression
    
    init(expression: String) throws {
        self.expression = try NSRegularExpression(pattern: expression, options: [.caseInsensitive])
    }
    
    var description: String {
        return expression.pattern
    }
    
    func matches(_ value: String) -> RegexMatch? {
        let matches = expression.matches(in: value, options: NSRegularExpression.MatchingOptions(), range: NSRange(location: 0, length: value.count))
        if let match = matches.first {
            return RegexMatch(checkingResult: match, value: value)
        }
        
        return nil
    }
}

