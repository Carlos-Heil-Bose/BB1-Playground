import Foundation
import UIKit

public struct ImageSequenceElement_t {
    var Name : String
    var Delay : Float
    public init(Name: String, Delay: Float) {
        self.Name = Name
        self.Delay = Delay
    }
}

public struct ImageSequence_t {
    var NameList : [ImageSequenceElement_t]
    var Position : CGPoint
    public init(NameList: [ImageSequenceElement_t], Position: CGPoint) {
        self.NameList = NameList
        self.Position = Position
    }
}

public func RenderSequence(View: UIView, Sequence: ImageSequence_t)  {
    var ImageList : [UIImage] = []
    var MaxHeight = CGFloat(0.0)
    var TotalWidth : Float = 0.0
    var CurrentPosition = Sequence.Position

    for Element in Sequence.NameList {
        let Image = UIImage(named: Element.Name)
        ImageList.append(Image!)
        if (Image!.size.height > MaxHeight) {
            MaxHeight = Image!.size.height
        }
        TotalWidth += Float(Image!.size.width)
    }

    var Spacing : Float
    if (ImageList.count > 1) {
        Spacing = (Float(View.bounds.width) - TotalWidth) /
                   Float(ImageList.count+1)
    }
    else {
        Spacing = 0.0
    }
    
    let MiddleLine = MaxHeight / 2.0
    CurrentPosition.x += CGFloat(Spacing)
    for Image in ImageList {
        let y = MiddleLine - Image.size.height/2 + CurrentPosition.y
        let ImageView = UIImageView(frame: CGRect(x: CurrentPosition.x, y: y,
                                                 width: Image.size.width, height: Image.size.height))
        ImageView.image = Image

        print(ImageView)
        View.addSubview(ImageView)
        CurrentPosition.x += Image.size.width + CGFloat(Spacing)
        print(CurrentPosition.x, CurrentPosition.y)
    }
}
