//
//  FeatureFile.swift
//  UpdraftUITests
//
//  Created by David Weiss on 1/23/18.
//  Copyright © 2018 David Weiss. All rights reserved.
//

import Foundation

public struct StepHandler {
    public typealias Handler = (RegexMatch) throws -> ()
    
    let expression: Regex
    let handler: Handler
    
    init(expression: Regex, handler: @escaping Handler) {
        self.expression = expression
        self.handler = handler
    }
}

enum StepError : Error, CustomStringConvertible {
    case NoMatch(Step)
    case AmbiguousMatch(Step, [StepHandler])
    
    var description: String {
        switch self {
        case .NoMatch:
            return "No matches found"
        case .AmbiguousMatch(let handlers):
            let matches = handlers.1.map { "       - `\($0.expression)`" }.joined(separator: "\n")
            return "Too many matches found:\n\(matches)"
        }
    }
}

public class FeatureFile {
    public var path: URL?
    
    public init(name: String) {
        let bundle = Bundle(for: type(of: self))
        if let url = bundle.resourceURL?.appendingPathComponent("\(name).feature") {
            path = url
        }
    }
    
    public typealias Handler = () -> ()
    
    var befores: [Handler] = []
    var afters: [Handler] = []
    var givens: [StepHandler] = []
    var whens: [StepHandler] = []
    var thens: [StepHandler] = []
    
    public func before(closure: @escaping Handler) {
        befores.append(closure)
    }
    
    public func after(closure: @escaping Handler) {
        afters.append(closure)
    }
    
    public func given(_ expression: String, closure: @escaping StepHandler.Handler) {
        let regex = try! Regex(expression: expression)
        let handler = StepHandler(expression: regex, handler: closure)
        givens.append(handler)
    }
    
    public func when(_ expression: String, closure: @escaping StepHandler.Handler) {
        let regex = try! Regex(expression: expression)
        let handler = StepHandler(expression: regex, handler: closure)
        whens.append(handler)
    }
    
    public func then(_ expression: String, closure: @escaping StepHandler.Handler) {
        let regex = try! Regex(expression: expression)
        let handler = StepHandler(expression: regex, handler: closure)
        thens.append(handler)
    }
    
    let scenario: [Scenario] = []
    
    public func run() throws {
        
    }
    
    public func run(paths: [URL]) throws {
        let features = try Feature.parse(paths: paths)
        
        if features.isEmpty {
            print("No features found.")
            exit(1)
        }
        
        try run(features: features)
    }
    
    public func run(features: [Feature]) throws {
        var scenarios = 0
        var failures = 0
        let reporter = Reporter()
        for feature in features {
            reporter.report(feature.name) { reporter in
                for scenario in feature.scenarios {
                    scenarios += 1
                    
                    reporter.report(scenario.name) { reporter in
                        befores.forEach { $0() }
                        
                        for step in scenario.steps {
                            if !run(step: step, reporter: reporter) {
                                failures += 1
                                break
                            }
                        }
                        
                        afters.forEach { $0() }
                    }
                }
            }
        }
        
        print("\n\(scenarios - failures) scenarios passed, \(failures) scenarios failed.")
        if failures > 0 {
            exit(1)
        }
    }
    
    func run(step: Step, reporter: ScenarioReporter) -> Bool {
        var failure: Error? = nil
        
        switch step {
        case .given(let given):
            do {
                let (handler, match) = try findGiven(step, name: given)
                try handler.handler(match)
            } catch {
                failure = error
            }
        case .when(let when):
            do {
                let (handler, match) = try findWhen(step, name: when)
                try handler.handler(match)
            } catch {
                failure = error
            }
        case .then(let then):
            do {
                let (handler, match) = try findThen(step, name: then)
                try handler.handler(match)
            } catch {
                failure = error
            }
        }
        
        reporter.report(step: step, failure: failure)
        return failure == nil
    }
    
    func findGiven(_ step: Step, name: String) throws -> (StepHandler, RegexMatch) {
        let matchedGivens = givens.filter { $0.expression.matches(name) != nil }
        if matchedGivens.count > 1 {
            throw StepError.AmbiguousMatch(step, matchedGivens)
        } else if let given = matchedGivens.first {
            let match = given.expression.matches(name)!
            return (given, match)
        }
        
        throw StepError.NoMatch(step)
    }
    
    func findWhen(_ step: Step, name: String) throws -> (StepHandler, RegexMatch) {
        let matched = whens.filter { $0.expression.matches(name) != nil }
        if matched.count > 1 {
            throw StepError.AmbiguousMatch(step, matched)
        } else if let result = matched.first {
            let match = result.expression.matches(name)!
            return (result, match)
        }
        
        throw StepError.NoMatch(step)
    }
    
    func findThen(_ step: Step, name: String) throws -> (StepHandler, RegexMatch) {
        let matched = thens.filter { $0.expression.matches(name) != nil }
        if matched.count > 1 {
            throw StepError.AmbiguousMatch(step, matched)
        } else if let result = matched.first {
            let match = result.expression.matches(name)!
            return (result, match)
        }
        
        throw StepError.NoMatch(step)
    }
}


//public let ploughman: Ploughman = {
//    return Ploughman()
//}()
//
//public func given(_ expression: String, closure: @escaping StepHandler.Handler) {
//    ploughman.given(expression, closure: closure)
//}
//
//public func when(_ expression: String, closure: @escaping StepHandler.Handler) {
//    ploughman.when(expression, closure: closure)
//}
//
//public func then(_ expression: String, closure: @escaping StepHandler.Handler) {
//    ploughman.then(expression, closure: closure)
//}

struct ParseError : Error, CustomStringConvertible {
    let description: String
    
    init(_ message: String) {
        description = message
    }
}

enum ParseState {
    case unknown
    case feature
    case scenario
    case given
    case when
    case then
    case and
    
    init?(value: String) {
        if value == "feature" {
            self = .feature
        } else if value == "scenario" {
            self = .scenario
        } else if value == "given" {
            self = .given
        } else if value == "when" {
            self = .when
        } else if value == "then" {
            self = .then
        } else if value == "and" {
            self = .and
        } else {
            return nil
        }
    }
    
    func toStep(_ value: String) -> Step? {
        switch self {
        case .given:
            return .given(value)
        case .when:
            return .when(value)
        case .then:
            return .then(value)
        default:
            return nil
        }
    }
}
