//
//  SequencerTests.swift
//  AVFoundation Test 8 Timer @ half periodLength Tests
//
//  Created by Alexander Nagel on 10.05.21.
//
@testable import AVFoundation_Test_8_Timer___half_periodLength
import XCTest

class SequencerTests: XCTestCase {

    var sequencer: Sequencer!
    
    override func setUp() {
        super.setUp()
        sequencer = Sequencer()
    }
    override func tearDown() {
        super.tearDown()
        sequencer = nil
    }
    
    func test_rubbish() {
        
        XCTAssertEqual(sequencer.rubbish(a: 2, b: 3), 5)
        
        
    }
    
    
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//
//    func testExample() throws {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct results.
//    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
