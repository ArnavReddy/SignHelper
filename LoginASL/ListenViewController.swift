//
//  ListenViewController.swift
//  LoginASL
//
//  Created by Arnav Reddy on 3/20/20.
//  Copyright © 2020 Arnav Reddy2. All rights reserved.
//

import UIKit
import AVFoundation
import SoundAnalysis
import Foundation

class ListenViewController: UIViewController, GenderClassifierDelegate {
    
    @IBOutlet weak var predLabel: UILabel!
    
    private let audioEngine = AVAudioEngine()
    private var soundClassifier = MySoundClassifier_1()
    var inputFormat: AVAudioFormat!
    var analyzer: SNAudioStreamAnalyzer!
    var resultsObserver = ResultsObserver()
    let analysisQueue = DispatchQueue(label: "com.apple.AnalysisQueue")
    override func viewDidLoad() {
        super.viewDidLoad()
        resultsObserver.delegate = self
        inputFormat = audioEngine.inputNode.inputFormat(forBus: 0)
        analyzer = SNAudioStreamAnalyzer(format: inputFormat)
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAudioEngine()
    }
    
    func displayPredictionResult(identifier: String, confidence: Double) {
        DispatchQueue.main.async {
            var text = ("Recognition: \(identifier)\nConfidence \(confidence)")
            self.predLabel.text? = text
            //print(text)
        }
    }
    private func startAudioEngine() {
        do {
            let request = try SNClassifySoundRequest(mlModel: soundClassifier.model)
            try analyzer.add(request, withObserver: resultsObserver)
        } catch {
            print("Unable to prepare request: \(error.localizedDescription)")
            return
        }
       
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 8000, format: inputFormat) { buffer, time in
                self.analysisQueue.async {
                    self.analyzer.analyze(buffer, atAudioFramePosition: time.sampleTime)
                }
        }
        
        do{
        try audioEngine.start()
        }catch( _){
            print("error in starting the Audio Engin")
        }
    }
    
}

class ResultsObserver: NSObject, SNResultsObserving {
    var delegate: GenderClassifierDelegate?
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult,
            let classification = result.classifications.first else { return }
        
        let confidence = classification.confidence * 100.0
        
        if confidence > 60 {
            delegate?.displayPredictionResult(identifier: classification.identifier, confidence: confidence)
        }
    }
}
protocol GenderClassifierDelegate {
    func displayPredictionResult(identifier: String, confidence: Double)
}
