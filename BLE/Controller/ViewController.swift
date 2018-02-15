//
//  ViewController.swift
//  BLE
//
//  Created by Maryam Jafari on 10/1/17.
//  Copyright © 2017 Maryam Jafari. All rights reserved.
//

import UIKit
import CoreBluetooth

struct RCNotifications {
    static let BluetoothRedy  = "Bluetooth is ready"
    static let FoundDevise = "Found Devise"
    static let ConnectionComplete = "Connection Complete"
    static let ServiceScanComplite = "Service Scan Complite"
    static let CharacteristicScanComplete = "Characteristic Scan Complete"
    static let DiscoverDevise = "Discover Devise"
    static let UpdatedCaption = "Updated Caption"
    static let readCha = "Read Characteristic"
}

class ViewController: UIViewController {
    var bleLand = Bluetooth()
    @IBOutlet weak var capsenLable: UILabel!
    @IBOutlet weak var StartBluetooth: UIButton!
    @IBAction func StartBLAction(_ sender: Any) {
        bleLand.startUpCentralManager()
        StartBluetooth.isEnabled = false
        viewWillAppear(true)
        
    }
    @objc func bluetoothOn(notification : Notification){
        SearchForDevice.isEnabled = true
        capsenLable.text = "Search For Device.."
        
    }
    
    @IBOutlet weak var SearchForDevice: UIButton!
    @IBAction func SearchForDeviceAction(_ sender: Any) {
        bleLand.discoverDevise()
        SearchForDevice.isEnabled = false
    }
    
    @objc func DiscoverDevice(){
        connect.isEnabled = true
        capsenLable.text = "Connecting to Device.."
    }
    
    @IBOutlet weak var connect: UIButton!
    @IBAction func connectAction(_ sender: Any) {
        bleLand.ConnectToDevice()
        connect.isEnabled = false
    }
    @objc func connectionComplete(){
        
        let alertController = UIAlertController(title: "Peripheral Found", message: "\(bleLand.preferalPrented!)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
        present(alertController, animated: true, completion: nil)
        discoverServises.isEnabled = true
        capsenLable.text = "Search For Services.."
    }
    
    @IBOutlet weak var discoverServises: UIButton!
    @IBAction func discoverServisesAction(_ sender: Any) {
        bleLand.discoverServices()
        discoverServises.isEnabled = false
    }
    
    @objc func discoverCharacteristic(){
        let alertController = UIAlertController(title: "Services Found", message: "\(bleLand.servicesPrinted!)", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
        
        present(alertController, animated: true, completion: nil)
        discoverCharxteristics.isEnabled = true
        capsenLable.text = "Search For Characteristic.."
        
    }
    
    @IBOutlet weak var discoverCharxteristics: UIButton!
    @IBAction func discoverCharxteristicsAction(_ sender: Any) {
        bleLand.discoverCharacteristic()
        discoverCharxteristics.isEnabled = false
        
    }
    
    @IBOutlet weak var disconnect: UIButton!
    @IBAction func disconnectAction(_ sender: Any) {
        bleLand.writeCapsenNotify(state: true)
        disconnect.isEnabled = false
        
    }
    
    @objc func UpdateCapsen(){
        
    }
    
    @objc func CharacteristicScanComplete(){
        let alertController = UIAlertController(title: "Characteristic Found", message: "\(bleLand.Char!)", preferredStyle: .alert)
        
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler:nil))
        
        present(alertController, animated: true, completion: nil)
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(bluetoothOn),
            name: NSNotification.Name(rawValue: RCNotifications.BluetoothRedy),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.connectionComplete),
            name: NSNotification.Name(rawValue: RCNotifications.ConnectionComplete),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.connectionComplete),
            name: .UIDeviceBatteryLevelDidChange,
            object: nil)
        
        NotificationCenter.default.addObserver(
            self   ,
            selector: #selector(self.DiscoverDevice),
            name: NSNotification.Name(rawValue: RCNotifications.DiscoverDevise),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.discoverCharacteristic),
            name: NSNotification.Name(rawValue: RCNotifications.ServiceScanComplite),
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.CharacteristicScanComplete),
            name: NSNotification.Name(rawValue: RCNotifications.CharacteristicScanComplete),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.UpdateCapsen),
            name: NSNotification.Name(rawValue: RCNotifications.UpdatedCaption),
            object: nil)
        
        NotificationCenter.default.addObserver(
            self,
            selector:  #selector(bleLand.peripheral(_:didUpdateValueFor:error:)),
            name: NSNotification.Name(rawValue: RCNotifications.readCha),
            object: nil)
        
    }
    
    
}

