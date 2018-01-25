//
//  Feature.swift
//  UpdraftUITests
//
//  Created by David Weiss on 1/23/18.
//  Copyright © 2018 David Weiss. All rights reserved.
//
//  based on: https://github.com/kylef/Ploughman

import Foundation

public struct Feature {
    public let name: String
    public let scenarios: [Scenario]
    
    public static func parse(paths: [URL]) throws -> [Feature] {
        var features: [Feature] = []
        
        for path in paths {
            let content: String = try String(contentsOf: path)
            var line = 0
            var state = ParseState.unknown
            var scenario: Scenario?
            
            var featureName: String?
            var scenarios: [Scenario] = []
            
            func commitFeature() {
                commitScenario()
                
                if let featureName = featureName {
                    features.append(Feature(name: featureName, scenarios: scenarios))
                }
                
                featureName = nil
                scenarios = []
            }
            
            func commitScenario() {
                if let scenario = scenario {
                    scenarios.append(scenario)
                }
                
                scenario = nil
            }
            
            func handleComponent(_ key: String, _ value: String) throws {
                if let newState = ParseState(value: key.lowercased()) {
                    var newState = newState
                    
                    if newState == .and {
                        newState = state
                    }
                    
                    if newState == .unknown {
                        throw ParseError("Invalid content `\(key.lowercased())` on line \(line) of \(path)")
                    }
                    
                    if newState == .feature {
                        commitFeature()
                        featureName = value
                    } else if newState == .scenario {
                        commitScenario()
                        scenario = Scenario(name: value, steps: [], file: path, line: line)
                    } else if let step = newState.toStep(value) {
                        scenario?.steps.append(step)
                    }
                    
                    state = newState
                } else {
                    throw ParseError("Invalid content on line \(line) of \(path)")
                }
            }
            
            for content in content.components(separatedBy: "\n") {
                line += 1
                
                let contents = content.trimmingCharacters(in: .whitespaces)
                if contents.isEmpty {
                    continue
                }
                let tokens = contents.split(":", maxSplits: 1)
                if tokens.count == 2 {
                    let key = String(tokens[0]).trimmingCharacters(in: .whitespaces)
                    let value = String(tokens[1]).trimmingCharacters(in: .whitespaces)
                    try handleComponent(key, value)
                } else {
                    let tokens = contents.split(" ", maxSplits: 1)
                    if tokens.count == 2 {
                        let key = String(tokens[0]).trimmingCharacters(in: .whitespaces)
                        let value = String(tokens[1]).trimmingCharacters(in: .whitespaces)
                        try handleComponent(key, value)
                    } else {
                        throw ParseError("Invalid content on line \(line) of \(path)")
                    }
                }
            }
            
            commitFeature()
        }
        
        return features
    }
    
    init(name: String, scenarios: [Scenario]) {
        self.name = name
        self.scenarios = scenarios
    }
}

extension String {
    func split(_ character: Character, maxSplits: Int) -> [String] {
        return self.split(maxSplits: maxSplits) { $0 == character }
            .map(String.init)
    }
}
