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
        sliderImages.regularImages = [#imageLiteral(resourceName: "bird_1"), #imageLiteral(resourceName: "bird_2"), #imageLiteral(resourceName: "bird_3"), #imageLiteral(resourceName: "bird_4")]
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
        sliderTickers.contentMood = .top
        slider.ticksListener = [sliderTickers, sliderImages]
        slider.addTarget(self, action: #selector(ViewController.valueChanged(_:event:)), for: .valueChanged)
    }
    
    func valueChanged(_ sender: MLBDDiscreteSlider, event:UIEvent) {
        print("Value Changed: \(sender.value)")
    }
}

