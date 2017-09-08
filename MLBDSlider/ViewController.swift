//
//  ViewController.swift
//  MLBDSlider
//
//  Created by Mohammed Rokon Uddin on 9/7/17.
//  Copyright © 2017 Mohammed Rokon Uddin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var sliderImages: MLBDSliderImages!
    @IBOutlet weak var slider: MLBDDiscreteSlider!
    @IBOutlet weak var sliderTickers: MLBDSliderImages!


    override func viewDidLoad() {
        super.viewDidLoad()
        sliderImages.regularImages = [#imageLiteral(resourceName: "bird"), #imageLiteral(resourceName: "bird"), #imageLiteral(resourceName: "bird"), #imageLiteral(resourceName: "bird")]
        sliderTickers.regularImages = [#imageLiteral(resourceName: "rulerLargeInactive"),
                                       #imageLiteral(resourceName: "rulerSmallInactive"),
                                       #imageLiteral(resourceName: "rulerLargeInactive"),
                                       #imageLiteral(resourceName: "rulerSmallInactive"),
                                       #imageLiteral(resourceName: "rulerLargeInactive"),
                                       #imageLiteral(resourceName: "rulerSmallInactive"),
                                       #imageLiteral(resourceName: "rulerLargeInactive"),
                                       #imageLiteral(resourceName: "rulerSmallInactive"),
                                       #imageLiteral(resourceName: "rulerLargeInactive"),
                                       #imageLiteral(resourceName: "rulerSmallInactive"),
                                       #imageLiteral(resourceName: "rulerLargeInactive"),
                                       #imageLiteral(resourceName: "rulerSmallInactive"),
                                       #imageLiteral(resourceName: "rulerLargeInactive"),
                                       #imageLiteral(resourceName: "rulerSmallInactive"),
                                       #imageLiteral(resourceName: "rulerLargeInactive"),
                                       #imageLiteral(resourceName: "rulerSmallInactive"),
                                       #imageLiteral(resourceName: "rulerLargeInactive"),
                                       #imageLiteral(resourceName: "rulerSmallInactive"),
                                       #imageLiteral(resourceName: "rulerLargeInactive")]


        sliderTickers.rangOffset = 18/6
        slider.ticksListener = [sliderTickers, sliderImages]
    }


}

