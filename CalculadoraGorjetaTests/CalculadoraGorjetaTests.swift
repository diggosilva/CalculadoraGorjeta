//
//  CalculadoraGorjetaTests.swift
//  CalculadoraGorjetaTests
//
//  Created by Diggo Silva on 04/03/26.
//

import XCTest
@testable import CalculadoraGorjeta

final class CalculatorViewModelTests: XCTestCase {
    
    private var sut: CalculatorViewModel!
    
    override func setUp() {
        super.setUp()
        sut = CalculatorViewModel()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown( )
    }
    
    func test_initialValues() {
        XCTAssertEqual(sut.numberOfPeople, 1)
        XCTAssertEqual(sut.isValidAmount, false)
        XCTAssertEqual(sut.totalAmountText, .defaultValue)
        XCTAssertEqual(sut.totalTipText, .defaultValue)
        XCTAssertEqual(sut.totalPerPersonText, .defaultValue)
    }
    
    func test_setBillAmount() {
        sut.setBillAmount(100)
        
        XCTAssertEqual(sut.isValidAmount, true)
        XCTAssertTrue(sut.totalAmountText.contains("100"))
        XCTAssertTrue(sut.totalTipText.contains("0"))
        XCTAssertTrue(sut.totalPerPersonText.contains("100"))
    }
    
    func test_setBillAmount_whenAmountIsZero_shouldSetInvalidAndClear() {
        sut.setBillAmount(0)

        XCTAssertFalse(sut.isValidAmount)
        XCTAssertTrue(sut.totalAmountText.contains("0"))
        XCTAssertTrue(sut.totalTipText.contains("0"))
        XCTAssertTrue(sut.totalPerPersonText.contains("0"))
    }
    
    func test_setTipAmount10Percent() {
        sut.setBillAmount(100)
        sut.setTipAmount(.tenPercent)
        
        XCTAssertEqual(sut.isValidAmount, true)
        XCTAssertTrue(sut.totalAmountText.contains("110"))
        XCTAssertTrue(sut.totalTipText.contains("10"))
        XCTAssertTrue(sut.totalPerPersonText.contains("110"))
    }
    
    func test_setNumberOfPeople() {
        sut.setBillAmount(100)
        sut.setTipAmount(.fifteenPercent)
        XCTAssertEqual(sut.isValidAmount, true)
        XCTAssertTrue(sut.totalAmountText.contains("115"))
        XCTAssertTrue(sut.totalTipText.contains("15"))
        
        sut.increasePeopleCount()
        sut.increasePeopleCount()
        sut.decreasePeopleCount()
        
        XCTAssertEqual(sut.numberOfPeople, 2)
        XCTAssertTrue(sut.totalPerPersonText.contains("57,50"))
    }
    
    func test_setTipAmount20Percent() {
        sut.setBillAmount(100)
        sut.setTipAmount(.twentyPercent)
        
        XCTAssertEqual(sut.isValidAmount, true)
        XCTAssertTrue(sut.totalAmountText.contains("120"))
        XCTAssertTrue(sut.totalTipText.contains("20"))
        XCTAssertTrue(sut.totalPerPersonText.contains("120"))
    }
    
    func test_setTipAmount25Percent() {
        sut.setBillAmount(100)
        sut.setTipAmount(.twentyFivePercent)
        
        XCTAssertEqual(sut.isValidAmount, true)
        XCTAssertTrue(sut.totalAmountText.contains("125"))
        XCTAssertTrue(sut.totalTipText.contains("25"))
        XCTAssertTrue(sut.totalPerPersonText.contains("125"))
    }
    
    func test_setCustomTipAmount() {
        sut.setBillAmount(100)
        sut.setTipAmount(.customTip(50))
        
        XCTAssertEqual(sut.isValidAmount, true)
        XCTAssertTrue(sut.totalAmountText.contains("150"))
        XCTAssertTrue(sut.totalTipText.contains("50"))
        XCTAssertTrue(sut.totalPerPersonText.contains("150"))
    }
}
