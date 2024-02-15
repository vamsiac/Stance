//
//  StanceTests.swift
//  StanceTests
//
//  Created by Vamsi Anguluru on 15/02/2024.
//

import XCTest
import CoreBluetooth
@testable import Stance

final class PeripheralsViewModelTests: XCTestCase {
	private var sut: PeripheralsViewModel!
	
	func testInit() {
		let mockCBManager = MockCBManager()
		sut = PeripheralsViewModel(centralManager: mockCBManager)
		XCTAssertNotNil(mockCBManager.delegate)
	}
	
	func testConnect() {
		let mockCBManager = MockCBManager()
		sut = PeripheralsViewModel(centralManager: mockCBManager)
		sut.connect(Self.mockPeripheral())
		XCTAssertEqual(mockCBManager.interactions.first, "connect(_:options:)")
	}
	
	func testDisconnect() {
		let mockCBManager = MockCBManager()
		sut = PeripheralsViewModel(centralManager: mockCBManager)
		sut.disconnect(Self.mockPeripheral())
		XCTAssertEqual(mockCBManager.interactions.first, "cancelPeripheralConnection(_:)")
	}
	
	func testDisconnectAllPeripherals() {
		let mockCBManager = MockCBManager()
		sut = PeripheralsViewModel(centralManager: mockCBManager)
		sut.disconnectAllPeripherals()
		XCTAssertEqual(mockCBManager.interactions.first, "scanForPeripherals(withServices:options:)")
	}
	
}

extension PeripheralsViewModelTests {
	static func mockPeripheral() -> CBPeripheral {
		let peripheral = Creator.create("CBPeripheral") as! CBPeripheral
		peripheral.addObserver(peripheral, forKeyPath: "delegate", options: .new, context: nil)
		return peripheral
	}
}

class MockCBManager: CBCentralManager {
	var interactions: [String] = []
	override func connect(_ peripheral: CBPeripheral, options: [String : Any]? = nil) {
		interactions.append(#function)
	}
	
	override func cancelPeripheralConnection(_ peripheral: CBPeripheral) {
		interactions.append(#function)
	}
	
	override func scanForPeripherals(withServices serviceUUIDs: [CBUUID]?, options: [String : Any]? = nil) {
		interactions.append(#function)
	}
}
