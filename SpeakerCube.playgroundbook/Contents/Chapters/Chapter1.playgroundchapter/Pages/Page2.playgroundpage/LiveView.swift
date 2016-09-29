import UIKit
import PlaygroundSupport


public class VC: UIViewController {
    let Page = Page2()
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.Page.Setup(View: view)
        self.Page.Redraw(View: self.view)
        view.backgroundColor = .black
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // call super
        super.viewWillTransition(to:size, with: coordinator)
        coordinator.animate(alongsideTransition:{
            _ in
            self.Page.Redraw(View: self.view)
        })
    }
}

public class Page2 {
    let Red : ImageSequence_t =
        ImageSequence_t( NameList: [
            ImageSequenceElement_t(Name: "BB1_blank",   Delay: 0.0),
            ImageSequenceElement_t(Name: "right_arrow", Delay: 0.5),
            ImageSequenceElement_t(Name: "red_color",   Delay: 0.5)
            ],
                         Position: CGPoint(x: 0, y: 100) )
    let Green : ImageSequence_t =
        ImageSequence_t( NameList: [
            ImageSequenceElement_t(Name: "green_color",   Delay: 0.5)
            ],
                         Position: CGPoint(x: 275, y: 250) )
    let Blue : ImageSequence_t =
        ImageSequence_t( NameList: [
            ImageSequenceElement_t(Name: "blue_color",   Delay: 0.5)
            ],
                         Position: CGPoint(x: 275, y: 400) )
    public init() {
    }

    public func Redraw(View: UIView) {
        for subView in View.subviews {
            subView.removeFromSuperview()
        }
        self.Setup(View: View)
    }

    public func Setup(View : UIView) {
        RenderSequence(View: View, Sequence: Red)
        RenderSequence(View: View, Sequence: Green)
        RenderSequence(View: View, Sequence: Blue)
    }
}

let BLE = BLEPlayground()
let View = VC()
PlaygroundPage.current.liveView = View
