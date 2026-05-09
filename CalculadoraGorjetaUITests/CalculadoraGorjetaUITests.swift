//
//  CalculadoraGorjetaUITests.swift
//  CalculadoraGorjetaUITests
//
//  Created by Diggo Silva on 24/04/26.
//

import XCTest

final class CalculadoraGorjetaUITests: XCTestCase {
    
    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testInitialState() throws {
        // Verifica se os campos de resultado iniciam com o valor padrão
        XCTAssertEqual(app.staticTexts[DSIdentifiers.grandTotalValue].label, "R$ 0,00")
        XCTAssertEqual(app.staticTexts[DSIdentifiers.totalTipValue].label, "R$ 0,00")
        XCTAssertEqual(app.staticTexts[DSIdentifiers.totalPerPersonValue].label, "R$ 0,00")
        XCTAssertEqual(app.staticTexts[DSIdentifiers.totalPeopleValue].label, "1")
        
        // Verifica se os botões estão desabilitados inicialmente (alpha reduzido conforme sua lógica)
        XCTAssertFalse(app.buttons[DSIdentifiers.tenPercentButton].isEnabled)
    }
    
    func testFullCalculationFlow() throws {
        let amountTextField = app.textFields[DSIdentifiers.amountTextField]
        XCTAssertTrue(amountTextField.exists)
        
        // Insere 100,00 (Digitando 10000 devido à máscara de moeda)
        amountTextField.tap()
        amountTextField.typeText("10000")
        
        // Seleciona 10% de gorjeta
        app.buttons[DSIdentifiers.tenPercentButton].tap()
        
        // Verifica cálculos para 1 pessoa
        XCTAssertTrue(app.staticTexts[DSIdentifiers.totalTipValue].label.contains("10,00"))
        XCTAssertTrue(app.staticTexts[DSIdentifiers.grandTotalValue].label.contains("110,00"))
        XCTAssertTrue(app.staticTexts[DSIdentifiers.totalPerPersonValue].label.contains("110,00"))
        
        // Divide para 2 pessoas
        app.buttons[DSIdentifiers.plusButton].tap()
        XCTAssertEqual(app.staticTexts[DSIdentifiers.totalPeopleValue].label, "2")
        XCTAssertTrue(app.staticTexts[DSIdentifiers.totalPerPersonValue].label.contains("55,00"))
        
        // Testa decremento de pessoas (não deve baixar de 1)
        app.buttons[DSIdentifiers.minusButton].tap()
        app.buttons[DSIdentifiers.minusButton].tap()
        XCTAssertEqual(app.staticTexts[DSIdentifiers.totalPeopleValue].label, "1")
    }
    
    func testCustomTipAlert() throws {
        let amountTextField = app.textFields[DSIdentifiers.amountTextField]
        amountTextField.tap()
        amountTextField.typeText("10000")
        
        // Abre alerta de gorjeta personalizada
        app.buttons[DSIdentifiers.customTipButton].tap()
        
        let alert = app.alerts[DSIdentifiers.customTipAlert]
        XCTAssertTrue(alert.exists)
        
        let customTextField = alert.textFields[DSIdentifiers.customTipTextField]
        customTextField.typeText("50") // 50 reais de gorjeta fixa
        alert.buttons.element(boundBy: 1).tap() // Clica no OK (segundo botão)
        
        XCTAssertTrue(app.staticTexts[DSIdentifiers.totalTipValue].label.contains("50,00"))
        XCTAssertTrue(app.staticTexts[DSIdentifiers.grandTotalValue].label.contains("150,00"))
    }
    
    func testClearButton() throws {
        let amountTextField = app.textFields[DSIdentifiers.amountTextField]
        amountTextField.tap()
        amountTextField.typeText("25000")
        app.buttons[DSIdentifiers.twentyPercentButton].tap()
        
        // Clica no botão de limpar (borracha) na Navigation Bar
        app.buttons[DSIdentifiers.clearButton].tap()
        
        XCTAssertEqual(app.staticTexts[DSIdentifiers.grandTotalValue].label, "R$ 0,00")
        XCTAssertEqual(amountTextField.label, "") // TextField vazio
        XCTAssertFalse(app.buttons[DSIdentifiers.shareButton].isEnabled)
    }
    
    func testShareAction() throws {
        let amountTextField = app.textFields[DSIdentifiers.amountTextField]
        amountTextField.tap()
        amountTextField.typeText("10000")
        
        app/*@START_MENU_TOKEN@*/.staticTexts["1 Person"]/*[[".otherElements.staticTexts[\"1 Person\"]",".staticTexts[\"1 Person\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        
        let shareButton = app.buttons[DSIdentifiers.shareButton]
        XCTAssertTrue(shareButton.isEnabled)
        shareButton.tap()
        
        // Verifica se o Activity Controller (Share Sheet) apareceu
        let activityListView = app.otherElements["ActivityListView"]
        XCTAssertTrue(activityListView.waitForExistence(timeout: 2))
    }
}
