//
//  VideoViewController.swift
//  Spreadit
//
//  Created by Marko Hlebar on 24/01/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit
import BIND
import MediaPlayer

class VideoViewController: BNDViewController {

    @IBOutlet weak var videoContainerView: UIView!
    
    lazy var moviePlayerController: MPMoviePlayerController = {
        let moviePlayerController = MPMoviePlayerController()
        self.videoContainerView.addSubview(moviePlayerController.view)
        moviePlayerController.repeatMode = .One
        moviePlayerController.backgroundView.backgroundColor = UIColor.whiteColor()
        moviePlayerController.controlStyle = .None
        moviePlayerController.view.hidden = true
        
        let movieView = moviePlayerController.view
        movieView.translatesAutoresizingMaskIntoConstraints = false
        
        let horizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[movieView]-0-|",
            options: .DirectionLeadingToTrailing,
            metrics: nil,
            views: ["movieView": movieView])
        self.videoContainerView.addConstraints(horizontalConstraints)
        
        let verticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[movieView]-0-|",
            options: .DirectionLeadingToTrailing,
            metrics: nil,
            views: ["movieView": movieView])
        self.videoContainerView.addConstraints(verticalConstraints)
        return moviePlayerController
    }()
    
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Installation", "Usage"])
        segmentedControl.addTarget(self, action: "onSegmentedControl:", forControlEvents: .ValueChanged)
        return segmentedControl
    }()
    
    lazy var videoNames : [String] = {
        return ["enabling_keyboard_720", "using_keyboard_720"]
    }()
    
    var selectedIndex: Int? {
        didSet {
            if selectedIndex != NSNotFound {
                self.segmentedControl.selectedSegmentIndex = selectedIndex!
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.selectedIndex = NSNotFound
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "moviePlayerStateDidChange:",
            name: MPMovieNaturalSizeAvailableNotification,
            object: nil)
    }
    
    func moviePlayerStateDidChange(notification: NSNotification) {
        self.moviePlayerController.view.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = self.segmentedControl
        
        if self.selectedIndex == NSNotFound {
            self.selectedIndex = 0
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.onSegmentedControl(self.segmentedControl)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.moviePlayerController.stop()
    }
    
    func onSegmentedControl(control : UISegmentedControl) {
        self.playVideoNamed(self.videoNames[control.selectedSegmentIndex])
    }
    
    func playVideoNamed(name: String) {
        if let videoURL = NSBundle.mainBundle().URLForResource(name, withExtension: "mov") {
            playVideo(videoURL)
        }
    }
    
    func playVideo(videoURL: NSURL) {
        self.moviePlayerController.contentURL = videoURL
        self.moviePlayerController.prepareToPlay()
        self.moviePlayerController.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
