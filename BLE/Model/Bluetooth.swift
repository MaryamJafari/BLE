//
//  Bluetooth.swift
//  BLE
//
//  Created by Maryam Jafari on 10/1/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import Foundation
import UIKit
import  CoreBluetooth
struct BLEParamether {
    static let cptionLedService =  CBUUID(string: "")
}

class Bluetooth: NSObject,CBCentralManagerDelegate, CBPeripheralDelegate {
    var centetalManager : CBCentralManager!
    private var capcenseLedBoard : CBPeripheral?
    private var capcenseLedService : CBService?
    private var ledCharasteritric : CBCharacteristic?
    private var capcenseCharasteritric : CBCharacteristic?
    public var servicesPrinted: String!
    public var Char: String!
    public var BLEOn: String!
    public var scan: String!
    public var preferalPrented : String!
    
    //Step 1 starting up a central Manager
    func startUpCentralManager(){
        centetalManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: RCNotifications.BluetoothRedy), object: self)
            print("Bluetooth Is On")
            BLEOn = "Bluetooth Is On"
        case .poweredOff:
            break
        case .resetting:
            break
        case .unauthorized :
            break
        case .unknown:
            break
        case .unsupported:
            break
        }
    }
    
    // Step 2 Scan for Peripherial
    func discoverDevise(){
        print("Starting Scan")
        scan = "Starting Scan"
        centetalManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : false])
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if capcenseLedBoard == nil{
            print ("Find new peripheral")
            capcenseLedBoard = peripheral
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: RCNotifications.DiscoverDevise), object: nil)
            centetalManager.stopScan()
        }
    }
    
    // Step 3 connecting to Device
    func ConnectToDevice(){
        centetalManager.connect(capcenseLedBoard!, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("connection Complete\(String(describing: capcenseLedBoard))\(peripheral)")
        preferalPrented = "\(peripheral)"
        capcenseLedBoard?.delegate = self
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: RCNotifications.ConnectionComplete), object: nil)
    }
    
    // discover Service
    func discoverServices(){
        capcenseLedBoard?.discoverServices(nil)
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print ("Discoverd Services")
        
        for servis in peripheral.services!{
            servicesPrinted   = "\(servis)"
            print ("Found Service \(servis)")
            // if servis.uuid == BLEParamether.cptionLedService{
            capcenseLedService = servis
            //}
            
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: RCNotifications.ServiceScanComplite), object: nil)
    }
    
    //Discover Charcteristic
    func discoverCharacteristic(){
        capcenseLedBoard?.discoverCharacteristics(nil, for: capcenseLedService!)
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        for characteristic in service.characteristics!{
            print ("Found Characteristic \(characteristic)")
            Char = "Found Characteristic \(characteristic)"
            capcenseCharasteritric = characteristic
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: RCNotifications.CharacteristicScanComplete), object: nil)
    }
    
    func writeCapsenNotify(state : Bool){
        
        capcenseLedBoard?.setNotifyValue(true, for: capcenseCharasteritric!)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: RCNotifications.readCha), object: nil)
        
    }
    
    // Read Characteristic value
    var capsenValue = 0
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if characteristic == capcenseCharasteritric{
            
            var out : NSInteger = 0
            let data = NSData(bytes: &out, length: size_t(NSInteger()))
            data.getBytes(&out, length: size_t(NSInteger()))
            
            capsenValue = out
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: RCNotifications.UpdatedCaption), object: nil)
        }
    }
}

















