//
//  ViewController.swift
//  Cards
//
//  Created by Ярослав Антонович on 24.11.2021.
//

import UIKit



class LaunchScreen: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        // Do any additional setup after loading the view.
    }
    


}
