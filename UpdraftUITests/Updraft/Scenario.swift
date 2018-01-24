//
//  Scenario.swift
//  UpdraftUITests
//
//  Created by David Weiss on 1/23/18.
//  Copyright © 2018 David Weiss. All rights reserved.
//

import Foundation

public struct Scenario {
    public let name: String
    public var steps: [Step]
    
    public let file: URL
    public let line: Int
    
    init(name: String, steps: [Step], file: URL, line: Int) {
        self.name = name
        self.steps = steps
        self.file = file
        self.line = line
    }
}
