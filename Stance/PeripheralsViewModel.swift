//
//  PeripheralsViewModel.swift
//  Stance
//
//  Created by Vamsi Anguluru on 15/02/2024.
//

import Foundation
import CoreBluetooth

final class PeripheralsViewModel: NSObject, ObservableObject {
	private let centralManager: CBCentralManager
	@Published private(set) var peripherals: [CBPeripheral] = []
	@Published private(set) var connectedPeripherals: [CBPeripheral] = []
	@Published var showErrorAlert = false
	
	var otherPeripherals: [CBPeripheral] {
		return peripherals.filter({ !connectedPeripherals.contains($0) })
			.sorted(by: { $0.name ?? "~" < $1.name ?? "~"})
	}
	
	init(
		centralManager: CBCentralManager = CBCentralManager()
	) {
		self.centralManager = centralManager
		super.init()
		self.centralManager.delegate = self
	}
	
	func connect(_ peripheral: CBPeripheral) {
		centralManager.connect(peripheral)
	}
	
	func disconnect(_ peripheral: CBPeripheral) {
		centralManager.cancelPeripheralConnection(peripheral)
	}
	
	func disconnectAllPeripherals() {
		connectedPeripherals.forEach { peripheral in
			centralManager.cancelPeripheralConnection(peripheral)
		}
		self.centralManager.scanForPeripherals(withServices: nil)
	}
}

extension PeripheralsViewModel: CBCentralManagerDelegate {
	func centralManagerDidUpdateState(_ central: CBCentralManager) {
		switch central.state {
			case .poweredOn:
				self.centralManager.scanForPeripherals(withServices: nil)
			case .poweredOff:
				self.centralManager.stopScan()
			case .unknown:
				break
			case .resetting:
				break
			case .unsupported:
				break
			case .unauthorized:
				break
			@unknown default:
				break
		}
	}
	
	func centralManager(
		_ central: CBCentralManager,
		didDiscover peripheral: CBPeripheral,
		advertisementData: [String : Any],
		rssi RSSI: NSNumber
	) {
		if !peripherals.contains(peripheral) {
			self.peripherals.append(peripheral)
		}
	}
	
	func centralManager(
		_ central: CBCentralManager,
		didConnect peripheral: CBPeripheral
	) {
		if !connectedPeripherals.contains(peripheral) {
			connectedPeripherals.append(peripheral)
		}
	}
	
	func centralManager(
		_ central: CBCentralManager,
		didDisconnectPeripheral peripheral: CBPeripheral,
		error: Error?
	) {
		if let index = connectedPeripherals.firstIndex(where: { $0.identifier == peripheral.identifier} ) {
			connectedPeripherals.remove(at: index)
		}
	}
	
	func centralManager(
		_ central: CBCentralManager,
		didFailToConnect peripheral: CBPeripheral,
		error: Error?
	) {
		showErrorAlert = true
	}
}
