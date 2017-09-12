//
//  MLBDDiscreteSlider.swift
//  MLBDSlider
//
//  Created by Mohammed Rokon Uddin on 9/7/17.
//  Copyright © 2017 Mohammed Rokon Uddin. All rights reserved.
//

import UIKit

public enum ComponentStyle:Int {
    case iOS = 0
    case rectangular
    case rounded
    case invisible
    case image
}


//  Interface builder hides the IBInspectable for UIControl
#if TARGET_INTERFACE_BUILDER
    public class MLBDSlider_INTERFACE_BUILDER:UIView {
    }
#else // !TARGET_INTERFACE_BUILDER
    public class MLBDSlider_INTERFACE_BUILDER:UIControl {
    }
#endif // TARGET_INTERFACE_BUILDER

@IBDesignable
public class MLBDDiscreteSlider: MLBDSlider_INTERFACE_BUILDER {


    @IBInspectable public var tickSize:CGSize = CGSize(width:1, height:4) {
        didSet {
            tickSize.width = max(0, tickSize.width)
            tickSize.height = max(0, tickSize.height)
            layoutTrack()
        }
    }

    @IBInspectable public var tickCount:Int = 11 {
        didSet {
            tickCount = max(2, tickCount)
            layoutTrack()
        }
    }

    @IBInspectable public var tickImage:UIImage? = nil {
        didSet {
            layoutTrack()
        }
    }


    @IBInspectable public var trackColor:UIColor? = nil {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var trackThickness:CGFloat = 2 {
        didSet {
            trackThickness = max(0, trackThickness)
            layoutTrack()
        }
    }

    @IBInspectable public var trackBorderWidth:CGFloat = 0 {
        didSet {
            trackBorderWidth = max(0, trackBorderWidth)
            layoutTrack()
        }
    }

    @IBInspectable public var trackBorderColor:UIColor? = nil {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var thumbSize:CGSize = CGSize(width:10, height:10) {
        didSet {
            thumbSize.width = max(1, thumbSize.width)
            thumbSize.height = max(1, thumbSize.height)
            layoutTrack()
        }
    }

    @IBInspectable public var thumbTintColor:UIColor? = nil {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var thumbShadowRadius:CGFloat = 0 {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var thumbShadowOffset:CGSize = CGSize.zero {
        didSet {
            layoutTrack()
        }
    }

    @IBInspectable public var incrementValue:Int = 1 {
        didSet {
            if(0 == incrementValue) {
                incrementValue = 1;  // nonZeroIncrement
            }
            layoutTrack()
        }
    }

    // MARK: UISlider substitution
    // AKA: UISlider value (as CGFloat for compatibility with UISlider API, but expected to contain integers)

    @IBInspectable public var minimumValue:CGFloat {
        get {
            return CGFloat(intMinimumValue)
        }
        set {
            intMinimumValue = Int(newValue)
            layoutTrack()
        }
    }

    @IBInspectable public var value:CGFloat {
        get {
            return CGFloat(intValue)
        }
        set {
            intValue = Int(newValue)
            layoutTrack()
        }
    }


    // MARK: Properties

    public override var tintColor: UIColor! {
        didSet {
            layoutTrack()
        }
    }

    public override var bounds: CGRect {
        didSet {
            layoutTrack()
        }
    }

    public var ticksDistance:CGFloat {
        get {
            assert(tickCount > 1, "2 ticks minimum \(tickCount)")
            let segments = CGFloat(max(1, tickCount - 1))
            return trackRectangle.width / segments
        }
        set {}
    }

    public var ticksListener:[MLBDControlsTicksProtocol]? = nil {
        didSet {
            if let ticksListener = ticksListener {
                for listenter in ticksListener {
                    listenter.mlbdTicksDistanceChanged(ticksDistance: ticksDistance,
                                                       sender: self)
                }
            }
        }
    }

    var intValue:Int = 0
    var intMinimumValue = -5

    var ticksAbscisses:[CGPoint] = []
    var thumbAbscisse:CGFloat = 0
    var thumbLayer = CALayer()
    var trackLayer = CALayer()
    var ticksLayer = CALayer()
    var trackRectangle = CGRect.zero
    var touchedInside = false

    let iOSThumbShadowRadius:CGFloat = 4
    let iOSThumbShadowOffset = CGSize(width:0, height:3)

    // MARK: UIControl

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initProperties()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        initProperties()
    }

    public override func draw(_ rect: CGRect) {
        drawTrack()
        drawThumb()
    }

    func sendActionsForControlEvents() {
        // Automatic UIControlEventValueChanged notification
        if let ticksListener = ticksListener {
            for listener in ticksListener {
                listener.mlbdValueChanged(value: UInt(value))
            }
        }
    }

    // MARK: MLBDDiscreteSlider

    func initProperties() {
        // Track is a clear clipping layer, and left + right sublayers, which brings in free animation
        trackLayer.masksToBounds = true
        layer.addSublayer(trackLayer)

        // Ticks in between track and thumb
        layer.addSublayer(ticksLayer)

        // The thumb is its own CALayer, which brings in free animation
        layer.addSublayer(thumbLayer)

        isMultipleTouchEnabled = false
        layoutTrack()
    }

    func drawTicks() {
        ticksLayer.frame = bounds
        if let backgroundColor = tintColor {
            ticksLayer.backgroundColor = backgroundColor.cgColor
        }

        let path = UIBezierPath()

        let maskLayer = CAShapeLayer()
        maskLayer.frame = trackLayer.bounds
        maskLayer.path = path.cgPath
        ticksLayer.mask = maskLayer
    }

    func drawTrack() {
        trackLayer.frame =  CGRect(x: 0,
                                   y: trackRectangle.origin.y,
                                   width: frame.width,
                                   height: trackRectangle.height)
        trackLayer.cornerRadius = trackRectangle.height/2
    }

    func drawThumb() {
        if( value >= minimumValue) {  // Feature: hide the thumb when below range

            let thumbSizeForStyle = thumbSizeIncludingShadow()
            let thumbWidth = thumbSizeForStyle.width
            let thumbHeight = thumbSizeForStyle.height
            let rectangle = CGRect(x:thumbAbscisse - (thumbWidth / 2),
                                   y: (frame.height - thumbHeight)/2,
                                   width: thumbWidth,
                                   height: thumbHeight)

            let shadowRadius =  thumbShadowRadius
            let shadowOffset =  thumbShadowOffset

            thumbLayer.frame = ((shadowRadius != 0.0)  // Ignore offset if there is no shadow
                ? rectangle.insetBy(dx: shadowRadius + shadowOffset.width,
                                    dy: shadowRadius + shadowOffset.height)
                : rectangle.insetBy(dx: shadowRadius,
                                    dy: shadowRadius))

            thumbLayer.backgroundColor = (thumbTintColor ?? UIColor.lightGray).cgColor
            thumbLayer.borderColor = UIColor.clear.cgColor
            thumbLayer.borderWidth = 0.0
            thumbLayer.cornerRadius = thumbLayer.frame.height/2
            thumbLayer.allowsEdgeAntialiasing = true

            // Shadow
            if(shadowRadius != 0.0) {
                #if TARGET_INTERFACE_BUILDER
                    thumbLayer.shadowOffset = CGSize(width: shadowOffset.width,
                                                     height: -shadowOffset.height)
                #else // !TARGET_INTERFACE_BUILDER
                    thumbLayer.shadowOffset = shadowOffset
                #endif // TARGET_INTERFACE_BUILDER

                thumbLayer.shadowRadius = shadowRadius
                thumbLayer.shadowColor = UIColor.black.cgColor
                thumbLayer.shadowOpacity = 0.15
            } else {
                thumbLayer.shadowRadius = 0.0
                thumbLayer.shadowOffset = CGSize.zero
                thumbLayer.shadowColor = UIColor.clear.cgColor
                thumbLayer.shadowOpacity = 0.0
            }
        }
    }

    func layoutTrack() {
        assert(tickCount > 1, "2 ticks minimum \(tickCount)")
        let segments = max(1, tickCount - 1)
        let thumbWidth = thumbSizeIncludingShadow().width

        // Calculate the track ticks positions
        let trackHeight = trackThickness
        let trackSize = CGSize(width: frame.width - thumbWidth,
                               height: trackHeight)


        trackLayer.backgroundColor = trackColor?.cgColor
        trackLayer.borderColor = trackBorderColor?.cgColor
        trackLayer.borderWidth = trackBorderWidth

        trackRectangle = CGRect(x: (frame.width - trackSize.width)/2,
                                y: (frame.height - trackSize.height)/2,
                                width: trackSize.width,
                                height: trackSize.height)
        let trackY = frame.height / 2
        ticksAbscisses = []
        for iterate in 0 ... segments {
            let ratio = Double(iterate) / Double(segments)
            let originX = trackRectangle.origin.x + (CGFloat)(trackSize.width * CGFloat(ratio))
            ticksAbscisses.append(CGPoint(x: originX, y: trackY))
        }
        layoutThumb()

        if let ticksListener = ticksListener {
            for listener in ticksListener {
                listener.mlbdTicksDistanceChanged(ticksDistance:ticksDistance, sender:self)
            }

        }
        setNeedsDisplay()
    }

    func layoutThumb() {
        assert(tickCount > 1, "2 ticks minimum \(tickCount)")
        let segments = max(1, tickCount - 1)

        // Calculate the thumb position
        let nonZeroIncrement = ((0 == incrementValue) ? 1 : incrementValue)
        var thumbRatio = Double(value - minimumValue) / Double(segments * nonZeroIncrement)
        thumbRatio = max(0.0, min(thumbRatio, 1.0)) // Normalized
        thumbAbscisse = trackRectangle.origin.x + (CGFloat)(trackRectangle.width * CGFloat(thumbRatio))
    }

    func thumbSizeIncludingShadow() -> CGSize {
        return ((thumbShadowRadius != 0.0)
            ? CGSize(width:thumbSize.width
                + (thumbShadowRadius * 2)
                + (thumbShadowOffset.width * 2),
                     height: thumbSize.height
                        + (thumbShadowRadius * 2)
                        + (thumbShadowOffset.height * 2))
            : thumbSize)
    }

    // MARK: UIResponder
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchedInside = true

        touchDown(touches, animationDuration: 0.1)
        sendActionForControlEvent(controlEvent: .valueChanged, with: event)
        sendActionForControlEvent(controlEvent: .touchDown, with:event)

        if let touch = touches.first {
            if touch.tapCount > 1 {
                sendActionForControlEvent(controlEvent: .touchDownRepeat, with: event)
            }
        }
    }

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchDown(touches, animationDuration:0)

        let inside = touchesAreInside(touches)
        sendActionForControlEvent(controlEvent: .valueChanged, with: event)

        if inside != touchedInside { // Crossing boundary
            sendActionForControlEvent(controlEvent: (inside) ? .touchDragEnter : .touchDragExit,
                                      with: event)
            touchedInside = inside
        }
        // Drag
        sendActionForControlEvent(controlEvent: (inside) ? .touchDragInside : .touchDragOutside,
                                  with: event)
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchUp(touches)

        sendActionForControlEvent(controlEvent: .valueChanged, with: event)
        sendActionForControlEvent(controlEvent: (touchesAreInside(touches)) ? .touchUpInside : .touchUpOutside,
                                  with: event)
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchUp(touches)

        sendActionForControlEvent(controlEvent: .valueChanged, with:event)
        sendActionForControlEvent(controlEvent: .touchCancel, with:event)
    }


    // MARK: Touches
    func touchDown(_ touches: Set<UITouch>, animationDuration duration:TimeInterval) {
        if let touch = touches.first {
            let location = touch.location(in: touch.view)
            moveThumbTo(abscisse: location.x, animationDuration: duration)
        }
    }

    func touchUp(_ touches: Set<UITouch>) {
        if let touch = touches.first {
            let location = touch.location(in: touch.view)
            let tick = pickTickFromSliderPosition(abscisse: location.x)
            moveThumbToTick(tick: tick)
        }
    }

    func touchesAreInside(_ touches: Set<UITouch>) -> Bool {
        var inside = false
        if let touch = touches.first {
            let location = touch.location(in: touch.view)
            if let bounds = touch.view?.bounds {
                inside = bounds.contains(location)
            }
        }
        return inside
    }

    // MARK: Notifications
    func moveThumbToTick(tick: UInt) {
        let nonZeroIncrement = ((0 == incrementValue) ? 1 : incrementValue)
        let intValue = Int(minimumValue) + (Int(tick) * nonZeroIncrement)
        if intValue != self.intValue {
            self.intValue = intValue
            sendActionsForControlEvents()
        }

        layoutThumb()
        setNeedsDisplay()
    }

    func moveThumbTo(abscisse:CGFloat, animationDuration duration:TimeInterval) {
        let leftMost = trackRectangle.minX
        let rightMost = trackRectangle.maxX

        thumbAbscisse = max(leftMost, min(abscisse, rightMost))
        CATransaction.setAnimationDuration(duration)

        let tick = pickTickFromSliderPosition(abscisse: thumbAbscisse)
        let nonZeroIncrement = ((0 == incrementValue) ? 1 : incrementValue)
        let intValue = Int(minimumValue) + (Int(tick) * nonZeroIncrement)
        if intValue != self.intValue {
            self.intValue = intValue
            sendActionsForControlEvents()
        }

        setNeedsDisplay()
    }

    func pickTickFromSliderPosition(abscisse: CGFloat) -> UInt {
        let leftMost = trackRectangle.minX
        let rightMost = trackRectangle.maxX
        let clampedAbscisse = max(leftMost, min(abscisse, rightMost))
        let ratio = Double(clampedAbscisse - leftMost) / Double(rightMost - leftMost)
        let segments = max(1, tickCount - 1)
        return UInt(round( Double(segments) * ratio))
    }

    func sendActionForControlEvent(controlEvent:UIControlEvents, with event:UIEvent?) {
        for target in allTargets {
            if let caActions = actions(forTarget: target, forControlEvent: controlEvent) {
                for actionName in caActions {
                    sendAction(NSSelectorFromString(actionName), to: target, for: event)
                }
            }
        }
    }

    #if TARGET_INTERFACE_BUILDER
    // MARK: TARGET_INTERFACE_BUILDER stub
    //       Interface builder hides the IBInspectable for UIControl
    
    let allTargets: Set<AnyHashable> = Set()
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {}
    func actions(forTarget target: Any?, forControlEvent controlEvent: UIControlEvents) -> [String]? { return nil }
    func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {}
    #endif // TARGET_INTERFACE_BUILDER    
}
