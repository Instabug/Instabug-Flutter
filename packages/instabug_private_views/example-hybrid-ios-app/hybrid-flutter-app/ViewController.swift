//
//  ViewController.swift
//  hybrid-flutter-app
//
//  Created by Ahmed alaa on 29/10/2024.
//

import UIKit
import Flutter
class ViewController: UIViewController {

    @IBOutlet weak var flutterView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
         let appDelegate = UIApplication.shared.delegate as! AppDelegate

            
        let flutterViewController = FlutterViewController(engine: appDelegate.flutterEngine, nibName: nil, bundle: nil)
                
                addChild(flutterViewController)
                flutterViewController.view.frame = flutterView.bounds
        flutterView.addSubview(flutterViewController.view)
                flutterViewController.didMove(toParent: self)
        // Do any additional setup after loading the view.
    }


}

