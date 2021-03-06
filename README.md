# Updraft

[![CI Status](https://travis-ci.org/davidweiss/updraft.svg?branch=master)](https://travis-ci.org/davidweiss/updraft)
[![Version](https://img.shields.io/cocoapods/v/Updraft.svg?style=flat)](http://cocoapods.org/pods/Updraft)
[![Language](https://img.shields.io/badge/swift-4-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/cocoapods/p/Updraft.svg?style=flat)](http://cocoapods.org/pods/Updraft)
[![IDE](https://img.shields.io/badge/Xcode-9-blue.svg)](https://developer.apple.com/xcode/)
[![License](https://img.shields.io/cocoapods/l/Updraft.svg?style=flat)](http://cocoapods.org/pods/Updraft)

Updraft is a Swift tool for running executable specifications written in a plain language. It is a [Swift](https://swift.org) implementation of [Cucumber](https://cucumber.io), using the [Gherkin](https://cucumber.io/docs/reference#gherkin) language.

> Cucumber is a tool for running automated tests written in plain language.
> Because they're written in plain language, they can be read by anyone on
> your team. Because they can be read by anyone, you can use them to help
> improve communication, collaboration and trust on your team.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

You can write tests in [Gherkin](https://cucumber.io/docs/reference#gherkin), here's an example `An array.feature` file:

```cucumber
Feature: An array

    Scenario: Append to an array
        Given an empty array
        When the number 1 is added to the array
        Then the array has 1 items

    Scenario: Filter an array
        Given an array with the numbers 1 through 5
        When the array is filtered for even numbers
        Then the array has 2 items
```

You can then write the implementations of these rules in Swift as a XCTest method :

```swift
import XCTest
import Updraft

class UpdraftExampleTests: XCTestCase {
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

        do {
            try featureFile.run()
        } catch {
            XCTFail("Unexpected error: \(error).")
        }
    }
}
```

## Requirements

iOS 11.0.0

## Installation

Updraft is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Updraft'
```
and run `pod install`

## Process

1. With everyone on the team, discuss the new feature idea. When you think you've got it mostly understood write it down in [Gherkin](https://cucumber.io/docs/reference#gherkin).
2. Add a `<feature name>.feature` file to your test target
3. Create a new `XCTest` method to test the new feature.
4. Add `let featureFile = FeatureFile(name: "<feature name>.feature")`
5. Match and define each step in your feature file with the `.given`, `.when`, and `.then` methods on `FeatureFile`
6. Add `featureFile.run()`
7. Build the UI or Interface that will be needed for each step in each scenario.
8. Run the test and watch it exercise the test code and fail.
9. Write just enough code to make each step in each scenario pass.
10. Repeat until all the scenarios for the feature succeed.

## Why Updraft?

_noun._ an upward current or draft of air

Birds, even swifty ones, if they find an updraft will often circle around as they are lifted up together. This allows them to go higher, further, and faster while expending less effort. Taking the time to define what "done" looks like in a way that can be automated and proven, may seem like you are flying in circles at first, but I believe it will allow you to go higher, further, and faster while expending less effort.

## Acknowledgements

The initial version of Updraft was based on the excellent work of [Kyle Fuller](https://fuller.li) on [Ploughman](https://github.com/kylef/Ploughman)

## Author

David Weiss, davidweiss@users.noreply.github.com

## License

Updraft is available under the Apache License 2.0 license. See the LICENSE file for more info.
