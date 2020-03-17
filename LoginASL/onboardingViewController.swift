//
//  onboardingViewController.swift
//  LoginASL
//
//  Created by Arnav Reddy on 3/14/20.
//  Copyright © 2020 Arnav Reddy2. All rights reserved.
//

import Foundation
import UIKit
import paper_onboarding

@IBDesignable
class onboardingViewController: UIViewController, PaperOnboardingDelegate, PaperOnboardingDataSource {
    var currIndex = 0
    @IBOutlet weak var getStartedButton: UIButton!
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardingItem( at index: Int) -> OnboardingItemInfo {
        
        let bgColorOne = UIColor(red: 80/255, green: 170/255, blue: 194/255, alpha: 1)
        let bgColorTwo = UIColor(red: 106/255, green: 166/255, blue: 211/255, alpha: 1)
        let bgColorThree = UIColor(red: 68/255, green: 122/255, blue: 201/255, alpha: 1)
        
        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
        let descriptionFont = UIFont(name: "AvenirNext-Regular", size: 18)!
    
        
        return [OnboardingItemInfo(informationImage: UIImage(named: "rocket")!,
        title: "What is Sign Helper?",
        description: "Sign Helper is an app aimed towards bridging the gap between people with hearing or speech " +
            "impairments and those who don't. We are aware that this community often feels isolated due to their unfortunate " +
            "circumstances and we wanted to eliminate that feeling. By accurately translating sign langauge Sign Helper " +
            "created a messaging service for complete communication",
        pageIcon: UIImage()//UIImage(named: "blank")!,
        ,color: bgColorOne,
        titleColor: UIColor.white,
        descriptionColor: UIColor.white,
        titleFont: titleFont,
        descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "notification")!,
        title: "Sensor Translation",
        description: "All the user with speech or hearing impairments needs is the corresponding Apple Watch app which uses " +
            "gyroscrope and accelerometer data to accurately map the movement of a wrist and predict the most similar action " +
            "ASL. Sign Helper uses the Apple Watch since images and videos are too inaccurate and the Apple Watch is not an " +
            "awkward and clunky piece of technology",
        pageIcon: UIImage(),
        color: bgColorTwo,
        titleColor: UIColor.white,
        descriptionColor: UIColor.white,
        titleFont: titleFont,
        descriptionFont: descriptionFont),
        
        OnboardingItemInfo(informationImage: UIImage(named: "brush")!,
        title: "Augmented Reality Training",
        description: "For the user without any impairments, Sign Helper realizes that simply texting the other user " +
            "doesn't allow for complete inclusivity and that's why we try to teach the user American Sign Langauge. Sign " +
            "does this by using Augmented Reality to mimic a real hand performing an action in ASL so that the user can " +
            "replicate this action",
        pageIcon: UIImage(),
        color: bgColorThree,
        titleColor: UIColor.white,
        descriptionColor: UIColor.white,
        titleFont: titleFont,
        descriptionFont: descriptionFont)][index]
    }
    
    func onboardingConfigurationItem( item: OnboardingContentViewItem, index: Int) {
        
    }
    func onboardingWillTransitonToIndex(index: Int) {
        print("1")
        
    }
    
    func onboardingDidTransitonToIndex(index: Int) {
       }
    
    @IBOutlet weak var onboardingView: OnboardingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modalPresentationStyle = .overFullScreen
        onboardingView.delegate = self
        onboardingView.dataSource = self
        
        }
    }
