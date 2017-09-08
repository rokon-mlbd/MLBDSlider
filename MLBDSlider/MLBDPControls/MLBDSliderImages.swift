//
//  MLBDSliderImages.swift
//  MLBDSlider
//
//  Created by Mohammed Rokon Uddin on 9/7/17.
//  Copyright © 2017 Mohammed Rokon Uddin. All rights reserved.
//

import UIKit

//@IBDesignable
class MLBDSliderImages: UIControl {

    @IBInspectable public var tickCount: Int = 0

    var emphasizedImages:[UIImage] = [#imageLiteral(resourceName: "birdSelected"), #imageLiteral(resourceName: "birdSelected"), #imageLiteral(resourceName: "birdSelected"), #imageLiteral(resourceName: "birdSelected")]
    var regularImages:[UIImage] = [#imageLiteral(resourceName: "bird"), #imageLiteral(resourceName: "bird"), #imageLiteral(resourceName: "bird"), #imageLiteral(resourceName: "bird")]
    var imageViews:[TickImageView] = []
    var ticksDistance: CGFloat = 10.0
    var numberOfTicks: Int = 7
    public var value:UInt = 0 {
        didSet {
            self.updateSliderForValue(Int(value))
        }
    }

    public var offSetX:CGFloat = 10.0 {
        didSet {
            //            dockEffect(duration: animationDuration)
        }
    }


    // Private
    private var lastValue = NSNotFound

    // MARK: UIView

    override init(frame: CGRect) {
        self.tickCount = 10
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.tickCount = 10
        super.init(coder: aDecoder)
        layoutTrack()
    }

    private func updateSliderForValue(_ value: Int) {
        let calculatedValue = Int(round(Double(value) * 0.5))
        for imageView in imageViews {
            if imageView.tickRange.contains(Double(value) * 0.5) {
                imageView.image = emphasizedImages[calculatedValue]
            } else {
                imageView.image = regularImages[calculatedValue]
            }
        }
    }
    
    private func layoutTrack() {
        
        let widht = self.bounds.width
        let height = self.bounds.height
        let numberOfImage = regularImages.count
        let imageViewWidth = (widht -  CGFloat((numberOfImage + 1)) * offSetX) / CGFloat(numberOfImage)
        for (i, image) in regularImages.enumerated() {
            let index = CGFloat(i)
            let originX = offSetX + ((offSetX + imageViewWidth) * index)
            let frame = CGRect(x: originX, y: 0, width: imageViewWidth, height: height)
            let imageView = TickImageView(frame: frame)
            imageView.tickRange = ((Double(i)-0.5))...((Double(i)+0.5))
            imageView.image = image
            imageView.tag = i
            self.addSubview(imageView)
            imageViews.append(imageView)
        }
    }
}

extension MLBDSliderImages : MLBDControlsTicksProtocol {
    public func mlbdTicksDistanceChanged(ticksDistance: CGFloat, sender: AnyObject) {
        self.ticksDistance = ticksDistance
    }

    public func mlbdValueChanged(value: UInt) {
        self.value = value
    }
}

class TickImageView: UIImageView {
    var tickRange: ClosedRange = 0.0...0.0
}

