//
//  ListenInterfaceController.swift
//  LoginASLWatch Extension
//
//  Created by Arnav Reddy on 3/20/20.
//  Copyright © 2020 Arnav Reddy2. All rights reserved.
//

import UIKit
import WatchKit
import AVFoundation
import SoundAnalysis

@available(watchOSApplicationExtension 6.0, *)
class ListenInterfaceController: WKInterfaceController, GenderClassifierDelegate {

    @IBOutlet weak var predLabel: WKInterfaceLabel!
    private let audioEngine = AVAudioEngine()
    private var soundClassifier = MySoundClassifier_1()
    var inputFormat: AVAudioFormat!
    var analyzer: SNAudioStreamAnalyzer!
    var resultsObserver = ResultsObservers()
    let analysisQueue = DispatchQueue(label: "com.apple.AnalysisQueue")
    
    func displayPredictionResult(identifier: String, confidence: Double) {
        DispatchQueue.main.async {
            var text = ("Recognition: \(identifier)\nConfidence \(confidence)")
            self.predLabel.setText(text)
            print(text)
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
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        resultsObserver.delegate = self
        inputFormat = audioEngine.inputNode.inputFormat(forBus: 0)
        
        analyzer = SNAudioStreamAnalyzer(format: inputFormat)
        //buildUI()
    }
    override func didAppear() {
        super.didAppear()
        startAudioEngine()
    }
    
}
class ResultsObservers: NSObject, SNResultsObserving{
    var delegate: GenderClassifierDelegate?
    @available(watchOSApplicationExtension 6.0, *)
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
