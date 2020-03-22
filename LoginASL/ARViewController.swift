//
//  ARViewController.swift
//  LoginASL
//
//  Created by Arnav Reddy on 3/16/20.
//  Copyright © 2020 Arnav Reddy2. All rights reserved.
//

import UIKit
import RealityKit

class ARViewController: UIViewController {

    
    @IBOutlet weak var arView: ARView!
    override func viewDidLoad() {
        super.viewDidLoad()
        //guard let anchor = try? Experience.loadMyGreatScene() else { return }
        //guard let anchor = try? TestingYes.loadYesScene() else { return }
        guard let anchor = try? TestingYes.loadYesScene() else { return }
        arView.scene.anchors.append(anchor)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
