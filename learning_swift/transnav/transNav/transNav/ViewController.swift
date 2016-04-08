//
//  ViewController.swift
//  transNav
//
//  Created by student on 29/02/2016.
//  Copyright © 2016 ryandiarm. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MapDataSource {
    
    @IBAction func tap(sender: UITapGestureRecognizer) {
        switch sender.state {
        case .Ended:
            myModel.addVertex(sender.locationInView(mapView))
            mapView.setNeedsDisplay()
        default:
            break
        }
    }
    @IBOutlet var mapView: MyMapView! {
        didSet {
            mapView.dataSource = self
        }
    }
    
    var myModel = MapModel()
    
    func drawIndices() -> [Int] {
        if myModel.indices.endIndex == 0 {
            myModel.updateIndices()
        }
        return myModel.indices
    }
    
    func vertices(bounds: CGRect) -> [CGPoint] {
        if myModel.vertices.endIndex == 0 {
            myModel.updateVertices(bounds)
        }
        return myModel.vertices
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

