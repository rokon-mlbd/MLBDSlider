//
//  MLBDSliderImages.swift
//  MLBDSlider
//
//  Created by Mohammed Rokon Uddin on 9/7/17.
//  Copyright © 2017 Mohammed Rokon Uddin. All rights reserved.
//

import UIKit

// 1. Add Components
// 2. Layout Components

// setNeedsDispay
// setNeedsLayout

//@IBDesignable
class MLBDSliderImages: UIControl {

    var tickCount: Int = 7
    var imageViews:[TickImageView] = []
    var ticksDistance: CGFloat = 0.0
    var rangOffset: Double = 0.5 {
        didSet {
            setNeedsLayout()
        }
    }
    var regularImages:[UIImage] = [] {
        didSet {
            updateComponents()
        }
    }

    public var value:UInt = 0 {
        didSet {
            self.updateSliderForValue(Int(value))
        }
    }

    var imageOffSetX:CGFloat = 10.0 {
        didSet {
            setNeedsLayout()
        }
    }

    var contentMood: UIViewContentMode = .bottom {
        didSet {
            setNeedsLayout()
        }
    }

    // MARK: UIView
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func updateSliderForValue(_ value: Int) {
        for imageView in imageViews {
            if imageView.tickRange.contains(Double(value) * rangOffset) {
                imageView.tintColor = .black
            } else {
                imageView.tintColor = .lightGray
            }
        }
    }

    func updateComponents() {
        // FIXME: Handle if set for multiple time. Should re-use in that case
        for (i, image) in regularImages.enumerated() {
            let imageView = TickImageView(frame: .zero)
            imageView.tickRange = ((Double(i)-rangOffset))...((Double(i)+rangOffset))
            imageView.image = image
            imageView.contentMode = contentMood
            imageView.tintColor = .lightGray
            self.addSubview(imageView)
            imageViews.append(imageView)
        }

        setNeedsLayout()
    }

    private func layoutTrack() {
        let width = self.bounds.width
        let height = self.bounds.height
        let numberOfImage = regularImages.count
        let imageViewWidth = (width -  CGFloat((numberOfImage + 1)) * imageOffSetX) / CGFloat(numberOfImage)
        for (i, imageView) in imageViews.enumerated() {
            let originX = imageOffSetX + ((imageOffSetX + imageViewWidth) *  CGFloat(i))
            imageView.frame = CGRect(x: originX, y: 0, width: imageViewWidth, height: height)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layoutTrack()
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

