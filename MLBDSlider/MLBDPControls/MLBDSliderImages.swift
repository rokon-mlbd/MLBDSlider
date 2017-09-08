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

    var tickCount: Int = 7
    var imageViews:[TickImageView] = []
    var ticksDistance: CGFloat = 0.0
    var rangOffset: Double = 0.5 {
        didSet {
            layoutTrack()
        }
    }
    var emphasizedImages:[UIImage] = [] {
        didSet {
            layoutTrack()
        }
    }
    var regularImages:[UIImage] = [] {
        didSet {
            layoutTrack()
        }
    }

    public var value:UInt = 0 {
        didSet {
            self.updateSliderForValue(Int(value))
        }
    }

    var imageOffSetX:CGFloat = 10.0 {
        didSet {
            layoutTrack()
        }
    }

    // MARK: UIView
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        layoutTrack()
    }

    private func updateSliderForValue(_ value: Int) {
        let calculatedValue = Int(round(Double(value) * rangOffset))
        for imageView in imageViews {
            if imageView.tickRange.contains(Double(value) * rangOffset) {
                imageView.image = emphasizedImages[calculatedValue]
            } else {
                imageView.image = regularImages[calculatedValue]
            }
        }
    }

    private func layoutTrack() {

        for view in imageViews  {
            view.removeFromSuperview()
        }
        imageViews.removeAll()

        let widht = self.bounds.width
        let height = self.bounds.height
        let numberOfImage = regularImages.count
        let imageViewWidth = (widht -  CGFloat((numberOfImage + 1)) * imageOffSetX) / CGFloat(numberOfImage)
        for (i, image) in regularImages.enumerated() {
            let index = CGFloat(i)
            let originX = imageOffSetX + ((imageOffSetX + imageViewWidth) * index)
            let frame = CGRect(x: originX, y: 0, width: imageViewWidth, height: height)
            let imageView = TickImageView(frame: frame)
            imageView.tickRange = ((Double(i)-rangOffset))...((Double(i)+rangOffset))
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
    fileprivate var tickRange: ClosedRange = 0.0...0.0
}

