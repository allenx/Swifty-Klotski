//
//  SpringButton.swift
//  Copyright © 2015 Appsidian. All rights reserved.
//

import UIKit

/// A UIButton subclass that renders a springy animation when tapped.
/// If the damping parameters are set to 1.0, this class may be used to provide subtle feedback to buttons with no elsasticity.
/// - parameter minimumScale: The minimum scale that the button may reach while pressed. Default 0.95
/// - parameter pressSpringDamping: The damping parameter for the spring animation used when the button is pressed. Default 0.4
/// - parameter releaseSpringDamping: The damping parameter for the spring animation used when the button is released. Default 0.35
/// - parameter pressSpringDuration: The duration of the spring animation used when the button is pressed. Default 0.4
/// - parameter releaseSpringDuration: The duration of the spring animation used when the button is reloeased. Default 0.5
public class SpringButton: UIButton {
    
    public var minimumScale: CGFloat = 0.95
    public var pressSpringDamping: CGFloat = 0.4
    public var releaseSpringDamping: CGFloat = 0.35
    public var pressSpringDuration = 0.4
    public var releaseSpringDuration = 0.5
    
    public init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: self.pressSpringDuration, delay: 0, usingSpringWithDamping: self.pressSpringDamping, initialSpringVelocity: 0, options: [.curveLinear, .allowUserInteraction], animations: { () -> Void in
            self.transform = CGAffineTransform(scaleX: self.minimumScale, y: self.minimumScale)
        }, completion: nil)
    }

    
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: self.releaseSpringDuration, delay: 0, usingSpringWithDamping: self.releaseSpringDamping, initialSpringVelocity: 0, options: [.curveLinear, .allowUserInteraction], animations: { () -> Void in
            self.transform = CGAffineTransform.identity
            }, completion: nil)
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        if !self.bounds.contains(location) {
            UIView.animate(withDuration: self.releaseSpringDuration, delay: 0, usingSpringWithDamping: self.releaseSpringDamping, initialSpringVelocity: 0, options: [.curveLinear, .allowUserInteraction], animations: { () -> Void in
                self.transform = CGAffineTransform.identity
                }, completion: nil)
        }
    }
    
    override public func touchesCancelled(_ touches: Set<UITouch>?, with event: UIEvent?) {
        super.touchesCancelled(touches!, with: event)
        UIView.animate(withDuration: self.releaseSpringDuration, delay: 0, usingSpringWithDamping: self.releaseSpringDamping, initialSpringVelocity: 0, options: [.curveLinear, .allowUserInteraction], animations: { () -> Void in
            self.transform = CGAffineTransform.identity
            }, completion: nil)
    }
    
}
