//
//  ImageVC.swift
//  TweeterTags
//
//  Created by student on 24/03/2016.
//  Copyright © 2016 ryandiarm. All rights reserved.
//

import UIKit

class ImageVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
        }
    }

    @IBOutlet weak var imageView: UIImageView!
    
    var imagePath: String? {
        didSet {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                let image = TweetModel.loadImageFromString(self.imagePath!)
                dispatch_async(dispatch_get_main_queue()) {
                    self.scrollView.contentSize = (image?.size)!
                    self.imageView!.image = image
                }
            })
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
