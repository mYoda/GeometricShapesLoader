//
//  ViewController.swift
//  GeometricShapesLoader
//
//  Created by Anton Nechayuk on 21.07.18.
//  Copyright © 2018 Anton Nechayuk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(GeometricShapesSceneView(frame: view.frame))
    }
}

