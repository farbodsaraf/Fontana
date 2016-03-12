//
//  ViewController.swift
//  Spreadit
//
//  Created by Marko Hlebar on 28/10/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

import UIKit
import BIND
import iRate

class HistoryViewController: BNDViewController, UICollectionViewDelegate, UICollectionViewDataSource, FNTKeyboardItemCellDelegate, FNTUsageTutorialViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView?
    
    var historyStack : FNTHistoryStack;
    var viewModels : [FNTKeyboardItemCellModel]? {
        didSet {
            reloadData()
            
            if viewModels!.count == 0 {
                showNoDataMessage()
            }
            else {
                removeNoDataMessageIfNeeded()
            }
        }
    }
    
    lazy var noDataView: FNTUsageTutorialView? = {
        let view = FNTUsageTutorialView()
        view.text = self.historyViewModel().welcomeString
        view.frame = self.view.frame
        view.delegate = self;
        view.start()
        return view
    }()
    
    lazy var clearButtonItem : UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "showClearDialog")
    }()
    
    required init(coder aDecoder: NSCoder) {
        self.historyStack = FNTHistoryStack(forGroup: "group.com.fontanakey.app")
        
        super.init(coder: aDecoder)!
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refresh", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "rateMyApp", name: UIApplicationDidBecomeActiveNotification, object: nil)
        
        self.tabBarItem = UITabBarItem(tabBarSystemItem: .History, tag: 0)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func showRateMyAppIfNecessary(eventCount: UInt) {
        guard eventCount > 0 else {
            return
        }
        
        iRate.sharedInstance().eventCount = eventCount - 1
        iRate.sharedInstance().logEvent(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = "History"
        
        self.viewModel = HistoryViewModel()        
    }
    
    override func viewWillAppear(animated: Bool) {
        refresh()
    }
    
    func historyViewModel() -> HistoryViewModel {
        return self.viewModel as! HistoryViewModel
    }
    
    func reloadItems() -> [FNTKeyboardItemCellModel] {
        let items = self.historyStack.allItems as? [FNTItem]
        
        var viewModels = [FNTKeyboardItemCellModel]()

        guard items != nil else {
            return viewModels
        }
        
        for item in items! {
            let viewModel = FNTKeyboardItemCellModel(model: item)
            viewModels.append(viewModel)
        }
        
        return viewModels
    }
    
    func refresh() {
        self.viewModels = reloadItems()
        self.navigationItem.rightBarButtonItem = viewModels!.count > 0 ? self.clearButtonItem : nil
    }
    
    func rateMyApp() {
        showRateMyAppIfNecessary(UInt(self.historyStack.allItems.count))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if let flowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            var itemSize = self.view.frame.size
            itemSize.width = self.isPortrait() ? itemSize.width : itemSize.width / 2
            itemSize.height = 66
            flowLayout.itemSize = itemSize
            
            flowLayout.invalidateLayout()
        }
    }
    
    func showClearDialog() {
        let alertController = UIAlertController(title: "Delete History",
            message: "Are you sure you want to delete history?",
            preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
        }
        alertController.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "Delete", style: .Destructive) { (action) in
            self.clear()
        }
        alertController.addAction(okAction)
        
        presentViewController(alertController, animated: true, completion: nil)
        
        FNTAppTracker.trackEvent(FNTAppTrackerActionEvent,
            withTags: [FNTAppTrackerScreenViewEvent: "History - Delete"])
    }
    
    func clear() {
        self.historyStack.clear()
        self.viewModels = []
        
        FNTAppTracker.trackEvent(FNTAppTrackerActionEvent,
            withTags: [FNTAppTrackerEventActionTag : "History - didDeleteAll"])
    }
    
    func reloadData() {
        self.collectionView?.reloadData()
    }
    
    func showNoDataMessage() {
        self.view.addSubview(self.noDataView!)
        
        FNTAppTracker.trackEvent(FNTAppTrackerScreenViewEvent, withTags: [FNTAppTrackerScreenNameTag : "History - Tutorial"])
    }
    
    func removeNoDataMessageIfNeeded() {
        if noDataView != nil {
            self.noDataView!.removeFromSuperview()
        }
        
        FNTAppTracker.trackEvent(FNTAppTrackerScreenViewEvent, withTags: [FNTAppTrackerScreenNameTag : "History"])
    }
    
    func showTutorial() {
        self.performSegueWithIdentifier("PresentTutorial", sender: self)
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let nibName = "FNTKeyboardItemPlainCell"
        registerNib(nibName)
        
        let cell : FNTKeyboardItemCell = collectionView.dequeueReusableCellWithReuseIdentifier(nibName, forIndexPath: indexPath) as! FNTKeyboardItemCell

        cell.viewModel = viewModels![indexPath.item] 
        cell.delegate = self
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let viewModel = viewModels![indexPath.item]
        copyURLToPasteboard(viewModel.url)
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
    }
    
    func copyURLToPasteboard(url : NSURL) {
        UIPasteboard.generalPasteboard().URL = url;
        TSMessage.showNotificationInViewController(self.navigationController,
            title: "\u{1F44D}\u{1F3FE} Link copied to pasteboard. \u{1F44D}\u{1F3FE}",
            subtitle: nil,
            image: nil,
            type: .Success,
            duration: 1.0,
            callback: nil,
            buttonTitle: nil,
            buttonCallback: nil,
            atPosition: .NavBarOverlay,
            canBeDismissedByUser: false)
        
        FNTAppTracker.trackEvent(FNTAppTrackerActionEvent,
            withTags: [FNTAppTrackerEventActionTag : "History - copyToPasteboard"])
    }
    
    func registerNib(cellName : String) {
        let nib = UINib(nibName: cellName, bundle: NSBundle.mainBundle())
        self.collectionView?.registerNib(nib, forCellWithReuseIdentifier: cellName)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (viewModels?.count)!
    }
    
    func textViewDidChange(textView: UITextView) {
        reloadData()
    }
    
    func isPortrait() -> Bool {
        let boundsSize : CGSize = UIScreen.mainScreen().bounds.size
        return Float(self.view.frame.size.width) == fminf(Float(boundsSize.width), Float(boundsSize.height))
    }
    
    func sender(sender: AnyObject!, wantsToOpenURL url: NSURL!) {
        UIApplication.sharedApplication().openURL(url)
    }
    
    func tutorial(tutorialView: FNTUsageTutorialView!, willOpenURL url: NSURL!) {
        let videoViewController = UIViewController.loadFromStoryboard("VideoViewController") as! VideoViewController
        videoViewController.selectedIndex = url.absoluteString.isEqual("fontanakey://usage") ? 1 : 0
        self.navigationController?.pushViewController(videoViewController, animated: true)
        
        FNTAppTracker.trackEvent(FNTAppTrackerActionEvent,
            withTags: [FNTAppTrackerEventActionTag : "History - openInternalUrl - " + url.absoluteString])
    }
}

