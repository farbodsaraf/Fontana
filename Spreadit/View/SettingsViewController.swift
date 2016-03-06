//
//  SettingsViewController.swift
//  Spreadit
//
//  Created by Marko Hlebar on 31/01/2016.
//  Copyright © 2016 Marko Hlebar. All rights reserved.
//

import UIKit
import BIND

class SettingsViewController: BNDViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var tableView: UITableView?
    
    lazy var viewModels: [TableRowViewModel] = {
        return [
            DonateCellModel(model: "Donate", navigationController:self.navigationController!),
            NavigationCellModel(model: "How do I use this app?"),
            NavigationCellModel(model: "Future development board"),
        ]
    }()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tabBarItem = UITabBarItem(tabBarSystemItem:.More, tag: 1)
        self.navigationItem.title = "More"
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Action,
            target: self, action: "presentShareViewController")
        
        subscribeToNotifications()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func subscribeToNotifications() {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        notificationCenter.addObserver(self, selector: "updateDonationCell", name: DonationStoreDidUpdateProductsNotification, object: nil)
    }
    
    func updateDonationCell() {
        guard let tableView = self.tableView where tableView.numberOfRowsInSection(0) > 0 else {
            return
        }
        
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        self.tableView?.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.tableFooterView = UIView()
        
        self.viewModel = SettingsViewModel()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        FNTAppTracker.trackEvent(FNTAppTrackerScreenViewEvent, withTags: [FNTAppTrackerScreenNameTag : "More"])
    }
    
    func settingsViewModel() -> SettingsViewModel {
        return self.viewModel as! SettingsViewModel
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row] as TableRowViewModel
        var cell = tableView.dequeueReusableCellWithIdentifier(viewModel.identifier()) as? BNDTableViewCell
        if (cell == nil) {
            cell = UIView.loadFromNib(viewModel.identifier()) as? BNDTableViewCell
        }
        cell!.viewModel = viewModel
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row == 1 {
            if let viewController = UIViewController.loadFromStoryboard("VideoViewController") {
                self.navigationController?.pushViewController(viewController,
                    animated: true)
            }
            
            FNTAppTracker.trackEvent(FNTAppTrackerActionEvent,
                withTags: [FNTAppTrackerEventActionTag: "More - onViewTutorial"])
        }
        else if indexPath.row == 2 {
            if let viewController  = UIViewController.loadFromStoryboard("WebViewController") as? BNDViewController {
                viewController.viewModel = WebViewModel.viewModelWithModel("https://trello.com/b/ebULNqww/fontana-future")
                viewController.navigationItem.title = "Future Development"
                self.navigationController?.pushViewController(viewController,
                    animated: true)
            }
            
            FNTAppTracker.trackEvent(FNTAppTrackerActionEvent,
                withTags: [FNTAppTrackerEventActionTag: "More - onViewFutureBoard"])
        }
    }
    
    func presentShareViewController() {
        let activityViewController = UIActivityViewController(activityItems: [self.settingsViewModel()],
            applicationActivities: nil)
        
        activityViewController.excludedActivityTypes = [
            UIActivityTypePrint,
            UIActivityTypeAssignToContact,
            UIActivityTypeSaveToCameraRoll,
            UIActivityTypeAddToReadingList,
        ]
        
        navigationController?.presentViewController(activityViewController, animated: true, completion: nil)
        
        FNTAppTracker.trackEvent(FNTAppTrackerActionEvent,
            withTags: [FNTAppTrackerEventActionTag: "More - onShare"])
    }

    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let viewModel = viewModels[indexPath.row]
        return viewModel.cellHeight()
    }
}
