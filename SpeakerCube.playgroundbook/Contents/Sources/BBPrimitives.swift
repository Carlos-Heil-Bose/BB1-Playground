import Foundation

public enum BBcolor  {
    case red,
         green,
         blue,
         unknown
}

public struct RGB {
    public var R : UInt8
    public var G : UInt8
    public var B : UInt8
    public init( R: UInt8, G: UInt8, B: UInt8) {
        self.R = R
        self.G = G
        self.B = B
    }
}

public extension RGB {
    static func == (left: RGB, right: RGB) -> Bool {
        return (left.R == right.R) &&
               (left.G == right.G) &&
               (left.B == right.B)
    }
}

var CubeColor = RGB(R: 0, G: 0, B: 0)

public func BBsetcolor(BLE : BLEPlayground, color: RGB) {
    let SetLEDColor = BMAP(FunctionBlock:BMAPFunctionBlock.BOSEbuild, Function:BBFunction.bb_LEDUserControlValue,
                           Operator:BMAPOperator.op_Set, Data :[0,1,color.R,color.G,color.B] )
    BLE.WriteBMAP(SetLEDColor)
    CubeColor = color
    sleep(1)
}

public func BBsetmode(BLE : BLEPlayground, Mode : BB_LEDModes) {
    let SetLEDModeRGB = BMAP(FunctionBlock:BMAPFunctionBlock.BOSEbuild, Function:BBFunction.bb_LEDMode,
                             Operator:BMAPOperator.op_Set, Data :[Mode.rawValue] )
    BLE.WriteBMAP(SetLEDModeRGB)
}

public func BBstarttone(BLE : BLEPlayground, freq: Float, chan : dsp_LR) {

    let FreqBytes = typetobinary(freq)
    let StartTone = BMAP(FunctionBlock: BMAPFunctionBlock.dsp, Function: DSPFunction.dsp_ToneCommand,
                         Operator: BMAPOperator.op_SetGet, Data: [1,1, chan.rawValue,
                         FreqBytes[3], FreqBytes[2], FreqBytes[1], FreqBytes[0]])
    BLE.WriteBMAP(StartTone)
}

public func BBstoptone(BLE : BLEPlayground) {

    let StopTone = BMAP(FunctionBlock: BMAPFunctionBlock.dsp, Function: DSPFunction.dsp_ToneCommand,
                        Operator: BMAPOperator.op_SetGet, Data: [0])
    BLE.WriteBMAP(StopTone)
}

public func BBgetcolor() -> RGB {
    return CubeColor
}

