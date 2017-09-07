//
//  MLBDControlsTicksProtocol.swift
//  MLBDSlider
//
//  Created by Mohammed Rokon Uddin on 9/7/17.
//  Copyright © 2017 Mohammed Rokon Uddin. All rights reserved.
//

import UIKit

public protocol MLBDControlsTicksProtocol {
    func mlbdTicksDistanceChanged(ticksDistance: CGFloat, sender: AnyObject)
    func mlbdValueChanged(value:UInt)
}
