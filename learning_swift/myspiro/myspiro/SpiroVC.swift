//
//  SpiroVC.swift
//  myspiro
//
//  Created by student on 27/02/2016.
//  Copyright © 2016 ryandiarm. All rights reserved.
//

import UIKit

class SpiroVC: UIViewController, SpiroDataSource {
    
    var circleRadius:CGFloat = 20
    
    var spiroModel = SpiroModel()
    
    @IBOutlet var mySpiroView: SpiroView!{
        didSet {
            mySpiroView.dataSource = self
            mySpiroView.addGestureRecognizer(UIPinchGestureRecognizer(target: mySpiroView, action: "calculateZoom:"))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
