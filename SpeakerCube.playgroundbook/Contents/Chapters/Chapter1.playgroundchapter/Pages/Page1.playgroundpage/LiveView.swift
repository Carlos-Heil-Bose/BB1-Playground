import UIKit
import PlaygroundSupport



public class VC: UIViewController {
    let PageView = Page()
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.PageView.Setup(View: self.view)
        self.PageView.Redraw()
        view.backgroundColor = .lightGray
        NotificationCenter.default.addObserver(self, selector: #selector(PageSuccess(_:)), name: NSNotification.Name(rawValue: PageSuccessNotification), object: nil)
    }

    @objc func PageSuccess(_ notification: Notification) {
        let ImageSuccess : ImageSequence_t =
            ImageSequence_t( NameList: [
                ImageSequenceElement_t(Name: "BB1_red", Delay: 0.0)],
                             Position: CGPoint(x: 0, y: 100) )

        RenderSequence(View: self.view, Sequence: ImageSuccess)
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    override public func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // call super
        super.viewWillTransition(to:size, with: coordinator)
        coordinator.animate(alongsideTransition:{
            _ in
            self.PageView.Redraw()
        })
    }
}

public class Page {
    var View : UIView?
    let ImageSequence : ImageSequence_t =
        ImageSequence_t( NameList: [
            ImageSequenceElement_t(Name: "BB1_blank",   Delay: 0.0),
            ImageSequenceElement_t(Name: "right_arrow", Delay: 0.5),
            ImageSequenceElement_t(Name: "red_color",   Delay: 0.5)
            ],
                         Position: CGPoint(x: 0, y: 100) )
    public init() {
    }

    public func Redraw() {
        for subView in View!.subviews {
            subView.removeFromSuperview()
        }
        self.Setup()
    }

    public func Setup() {
        RenderSequence(View: self.View!, Sequence: ImageSequence)
    }
    public func Setup(View: UIView) {
        self.View = View
        RenderSequence(View: self.View!, Sequence: ImageSequence)
    }

}


let BLE = BLEPlayground()
let View = VC()
PlaygroundPage.current.liveView = View

