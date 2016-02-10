//
//  ViewController.swift
//  Spreadit
//
//  Created by Marko Hlebar on 28/10/2015.
//  Copyright © 2015 Marko Hlebar. All rights reserved.
//

import UIKit
import BIND
import TSMessages

class HistoryViewController: BNDViewController, UICollectionViewDelegate, UICollectionViewDataSource, FNTKeyboardItemCellDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var historyStack : FNTHistoryStack;
    var viewModels : [FNTKeyboardItemCellModel]? {
        didSet {
            reloadData()
        }
    }
    
    lazy var clearButtonItem : UIBarButtonItem = {
        return UIBarButtonItem(barButtonSystemItem: .Trash, target: self, action: "clear")
    }()
    
    required init(coder aDecoder: NSCoder) {
        self.historyStack = FNTHistoryStack(forGroup: "group.com.fontanakey.app")

        super.init(coder: aDecoder)!
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "reloadItems", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        self.tabBarItem = UITabBarItem(tabBarSystemItem: .History, tag: 0)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.navigationItem.title = "History"
        self.navigationItem.rightBarButtonItem = self.clearButtonItem
        
        reloadItems()
    }
    
    func reloadItems() {
        let items = self.historyStack.allItems as? [FNTItem]
        
        guard items != nil else {
            return
        }
        
        viewModels = [FNTKeyboardItemCellModel]()
        
        for item in items! {
            let viewModel = FNTKeyboardItemCellModel(model: item)
            viewModels?.append(viewModel)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let flowLayout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        var itemSize = self.view.frame.size
        itemSize.width = self.isPortrait() ? itemSize.width : itemSize.width / 2
        itemSize.height = 66
        flowLayout.itemSize = itemSize
        
        flowLayout.invalidateLayout()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clear() {
        self.historyStack.clear()
        self.viewModels = []
    }
    
    func reloadData() {
        self.collectionView.reloadData()
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
            title: "Link copied to clipboard.",
            subtitle: nil,
            image: nil,
            type: .Success,
            duration: 1.0,
            callback: nil,
            buttonTitle: nil,
            buttonCallback: nil,
            atPosition: .NavBarOverlay,
            canBeDismissedByUser: false)
    }
    
    func registerNib(cellName : String) {
        let nib = UINib(nibName: cellName, bundle: NSBundle.mainBundle())
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: cellName)
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
}

