//
//  ContentView.swift
//  Stance
//
//  Created by Vamsi Anguluru on 15/02/2024.
//

import SwiftUI

struct PeripheralsView: View {
	@ObservedObject private var bluetoothViewModel = PeripheralsViewModel()
	@State private var isBluetoothOn = true

	var body: some View {
		NavigationStack {
			List {
				
				Toggle(isOn: $isBluetoothOn) {
					Text(isBluetoothOn ? "Bluetooth On" : "Bluetooth Off")
						.foregroundStyle(isBluetoothOn ? .green : .red)
					
				}
				
				connectedSection
				disconnectedSection
			}
			.navigationTitle("Stance")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					Button {
						bluetoothViewModel.disconnectAllPeripherals()
					} label: {
						Image(systemName: "gobackward")
					}
				}
			}
		}
		.alert(isPresented: $bluetoothViewModel.showErrorAlert) {
			Alert(title: Text("Failed to connect"),
				  message: Text("Unable to connect to device"),
				  dismissButton: .default(Text("Ok")))
		}
		
	}
	
	private var connectedSection: some View {
		Section("My devices") {
			ForEach(isBluetoothOn ? bluetoothViewModel.connectedPeripherals: []) { peripheral in
				HStack {
					Circle()
						.fill((peripheral.state == .connected) ? .green : .red)
						.fixedSize()
						.padding(2)
					Text(peripheral.name ?? peripheral.identifier.uuidString)
						.onTapGesture {
							bluetoothViewModel.disconnect(peripheral)
						}
				}
			}
		}
	}
	
	private var disconnectedSection: some View {
		Section("Other devices") {
			ForEach(isBluetoothOn ? bluetoothViewModel.otherPeripherals : []) { peripheral in
				HStack {
					Text(peripheral.name ?? peripheral.identifier.uuidString)
						.onTapGesture {
							bluetoothViewModel.connect(peripheral)
							
						}
					Spacer()
					ProgressView()
						.opacity((peripheral.state == .connecting) ? 1 : 0)
				}
			}
		}
	}
}

#Preview {
	PeripheralsView()
}
