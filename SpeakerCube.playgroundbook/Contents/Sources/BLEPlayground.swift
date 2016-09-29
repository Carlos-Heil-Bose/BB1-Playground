import CoreBluetooth


open class BLEPlayground {

    var centralmanager : CBCentralManager!
    // Instantiate the BLE manager
    var BLEmanager = BLEManager()
    var connected : Bool = false;

    public init() {

        // Establish handlers for the notification coming from BLEmanager
        NotificationCenter.default.addObserver(self, selector: #selector(BLEPoweredOn(_:)), name: NSNotification.Name(rawValue: BLEPoweredOnNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BLEDevicesFound(_:)), name: NSNotification.Name(rawValue: BLEBOSEbuildDeviceFoundNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BLEConnectionUpdate(_:)), name: NSNotification.Name(rawValue: BLEBMAPServiceAvailableNotification), object: nil)
        
        // Instantiate the BLE central manager with the BLEmanager as a delegate
        centralmanager = CBCentralManager(delegate: BLEmanager, queue:nil, options: nil);
        self.connected = false;
    }

    public func Connected() -> Bool {
        return self.connected
    }

    // Handler for BLEPoweredOnNotification
    @objc func BLEPoweredOn(_ notification: Notification) {
        // BLE is up. Search for BOSEbuild devices
        BLEmanager.ScanForBOSEbuildDevices(centralmanager, timeout: 1)
    }

    // Handler for BLEBOSEbuildDeviceFoundNotification
    @objc func BLEDevicesFound(_ DeviceList: Notification) {
        var SelectedDevice : String
        if ((DeviceList as NSNotification).userInfo != nil) {
            SelectedDevice = FindHighestRSSI(DeviceList)
            BLEmanager.ConnectToDevice(SelectedDevice)
        }
        else {
            NSLog("No BOSEbuild devices found")
        }
    }

    // Handler for BLEBMAPServiceAvailableNotification
    @objc func BLEConnectionUpdate(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo as! [String: Bool]
        // Check if connection is successful
        if let isConnected: Bool = userInfo["isConnected"] {
            if (isConnected) {
                #if false
                // We are good to go. Set the cube red!
                // Set the color red...
                var SetLEDColor = BMAP(FunctionBlock:.BOSEbuild, Function:.bb_LEDUserControlValue, Operator:.op_Set, Data :[0,1,0xff,0,0] )
                BLEmanager.WriteBMAP(SetLEDColor)

                // Now change the LED mode to RGB...
                let SetLEDModeRGB = BMAP(FunctionBlock:.BOSEbuild, Function:.bb_LEDMode, Operator:.op_Set, Data :[BB_LEDModes.ledMode_RGB.rawValue] )
                BLEmanager.WriteBMAP(SetLEDModeRGB)
                sleep(1)
                SetLEDColor = BMAP(FunctionBlock:.BOSEbuild, Function:.bb_LEDUserControlValue, Operator:.op_Set, Data :[0,1,0x0,0,0] )
                BLEmanager.WriteBMAP(SetLEDColor)
                #endif
                NotificationCenter.default.post(name: Notification.Name(rawValue: BLEBOSEbuildDeviceConnectedNotification), object: self, userInfo: nil)
                self.connected = true;
            }
        }
    }

    func FindHighestRSSI(_ notification:Notification) -> String {
        var HighRSSI : Int = -255
        var HighRSSIName : String = ""
        let DeviceList = (notification as NSNotification).userInfo
        if (DeviceList != nil) {
            for (DeviceName, DeviceRSSI) in DeviceList! {
                if ((DeviceRSSI as AnyObject).intValue < 0) {
                    NSLog("Device \(DeviceName): RSSI = \(DeviceRSSI)" )
                    if (HighRSSI < (DeviceRSSI as AnyObject).intValue) {
                        HighRSSI = (DeviceRSSI as AnyObject).intValue
                        HighRSSIName = DeviceName as! String
                    }
                }
            }
        }
        return HighRSSIName
    }

    open func WriteBMAP(_ BMAPMessage : BMAP) {
        BLEmanager.WriteBMAP(BMAPMessage)
    }
}

