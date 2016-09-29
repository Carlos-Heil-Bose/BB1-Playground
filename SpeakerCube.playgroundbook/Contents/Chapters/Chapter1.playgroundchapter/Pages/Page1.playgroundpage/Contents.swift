//: **Goal:** See if you can use the BBcube_color(color) command to get the cube to glow in the color shown.

//#-hidden-code
import CoreBluetooth
import UIKit
import PlaygroundSupport


let BLE = BLEPlayground()


PlaygroundPage.current.needsIndefiniteExecution = true

public func BBcube_color(_ color: BBcolor) {
    var RGBColor = RGB(R: 0, G: 0, B: 0)
    switch color {
    case BBcolor.red:
        RGBColor.R = 0xff
    case BBcolor.green:
        RGBColor.G = 0xff
    case BBcolor.blue:
        RGBColor.B = 0xff
    default:
        break
    }

    BBsetcolor(BLE: BLE, color : RGBColor)

    // Now change the LED mode to RGB...
    BBsetmode(BLE: BLE, Mode: BB_LEDModes.ledMode_RGB)
}

public class UserCode {


    init() {

        NotificationCenter.default.addObserver(self, selector: #selector(UserEditableCode(_:)), name: NSNotification.Name(rawValue: BLEBOSEbuildDeviceConnectedNotification), object: nil)
    }
    

    @objc func UserEditableCode(_ notification: Notification) {
        let Red = RGB(R: 0xff, G: 0, B: 0)
        //#-end-hidden-code


        //#-code-completion(everything, hide)
        //#-code-completion(identifier, show, BBcube_color(_:))
        //#-editable-code Tap to enter code

        //#-end-editable-code
        //#-hidden-code

        if (BBgetcolor() == Red) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: PageSuccessNotification), object: self, userInfo: nil)
            BBstarttone(BLE: BLE, freq: 25.0, chan: .left)
            sleep(1)
            BBstoptone(BLE: BLE)
            PlaygroundPage.current.assessmentStatus = .pass(message: "### Great job! You've successfully set the cube color to red. \n\n[**Next Page**](@next)")
        }
        else {
            PlaygroundPage.current.assessmentStatus = .fail(hints:["Try setting the color to `.red`"], solution:nil)
        }
    }
}

let UC = UserCode()

//#-end-hidden-code

