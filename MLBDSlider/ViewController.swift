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
        sliderImages.emphasizedImages = [#imageLiteral(resourceName: "birdSelected"), #imageLiteral(resourceName: "birdSelected"), #imageLiteral(resourceName: "birdSelected"), #imageLiteral(resourceName: "birdSelected")]

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
                                       #imageLiteral(resourceName: "rulerLargeInactive")]

        sliderTickers.emphasizedImages = [ #imageLiteral(resourceName: "rulerLargeActive"),
                                          #imageLiteral(resourceName: "rulerSmallActive"),
                                          #imageLiteral(resourceName: "rulerLargeActive"),
                                          #imageLiteral(resourceName: "rulerSmallActive"),
                                          #imageLiteral(resourceName: "rulerLargeActive"),
                                          #imageLiteral(resourceName: "rulerSmallActive"),
                                          #imageLiteral(resourceName: "rulerLargeActive"),
                                          #imageLiteral(resourceName: "rulerSmallActive"),
                                          #imageLiteral(resourceName: "rulerLargeActive"),
                                          #imageLiteral(resourceName: "rulerSmallActive"),
                                          #imageLiteral(resourceName: "rulerLargeActive"),
                                          #imageLiteral(resourceName: "rulerSmallActive"),
                                          #imageLiteral(resourceName: "rulerLargeActive"),
                                          #imageLiteral(resourceName: "rulerSmallActive"),
                                          #imageLiteral(resourceName: "rulerLargeActive"),
                                          #imageLiteral(resourceName: "rulerSmallActive"),
                                          #imageLiteral(resourceName: "rulerLargeActive")]

        slider.ticksListener = [sliderTickers, sliderImages]
    }


}

