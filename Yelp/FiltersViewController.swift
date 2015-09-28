//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Gonzalez, Ivan on 9/26/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController
        (filtersViewController: FiltersViewController,
         didUpdateFilters filters:[String:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SwitchCellDelegate{

    @IBOutlet weak var tableView: UITableView!

    var categories: [[String:String]] = []
    var distances:[[String:String]] = []
    var sortBy:[[String:String]] = []
    
    var switchStates = [Int:Bool]()
    weak var delegate: FiltersViewControllerDelegate?

    var titleHeader: [String] = ["Category","Deals", "Distance", "Sort by"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = yelpCategories()
        distances = yelpDistances()
        sortBy = yelpSortBy()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        var filters = [String : AnyObject]()
        
        var selectedCategories = [String] ()
        for (row,isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        
        if  selectedCategories.count > 0 {
            filters["categories"] = selectedCategories
        }
        
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
    }
    
    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        
      let indexPath = tableView.indexPathForCell(switchCell)!
        
        
        switchStates[indexPath.row] = value
        print("filter view controller got the switch")
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell

        
        if indexPath.section == 0 {
            cell.switchLabel.text = categories[indexPath.row]["name"]
            cell.delegate = self
            if switchStates[indexPath.row] != nil {
                cell.onSwitch.on = switchStates[indexPath.row]!
            } else {
                cell.onSwitch.on = false
            }
        }else if indexPath.section == 1 {
            cell.switchLabel.text = "Deals"
            cell.delegate = self
            //set to the proper defautl value
        } else if indexPath.section == 2 {
            cell.switchLabel.text = distances[indexPath.row]["name"]
            cell.delegate = self
            if switchStates[indexPath.row] != nil {
                cell.onSwitch.on = switchStates[indexPath.row]!
            } else {
                cell.onSwitch.on = false
            }
        } else if indexPath.section == 3 {
            cell.switchLabel.text = sortBy[indexPath.row]["name"]
            cell.delegate = self
            if switchStates[indexPath.row] != nil {
                cell.onSwitch.on = switchStates[indexPath.row]!
            } else {
                cell.onSwitch.on = false
            }
        }
    
        return cell;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleHeader[section]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return categories.count
        } else if section == 2 {
            return distances.count
        } else if section == 3 {
            return sortBy.count
        }
        
        return 1
    }
    
    func yelpSortBy () -> [[String:String]] {
        return  [
                    ["code": "0", "name": "Best Match"],
                    ["code": "1", "name": "Distance"],
                    ["code": "2", "name": "Rating"]]
    }
    
    func yelpCategories() -> [[String:String]]  {
        return
            [["code":  "", "name": "Select"],
                ["code":  "active", "name": "Active Life"],
                ["code":  "arts", "name": "Arts & Entertainment"],
                ["code":  "auto", "name": "Automotive"],
                ["code":  "beautysvc", "name": "Beauty & Spas"],
                ["code":  "education", "name": "Education"],
                ["code":  "eventservices", "name": "Event Planning & Services"],
                ["code":  "financialservices", "name": "Financial Services "],
                ["code":  "food", "name": "Food"],
                ["code":  "health", "name": "Health & Medical"],
                ["code":  "homeservices", "name": "Home Services"],
                ["code":  "hotelstravel", "name": "Hotels & Travel"],
                ["code":  "localflavor", "name": "Local Flavor"],
                ["code":  "localservices", "name": "Local Services"],
                ["code":  "massmedia", "name": "Mass Media"],
                ["code":  "nightlife", "name": "Nightlife"],
                ["code":  "pets", "name": "Pets"],
                ["code":  "professional", "name": "Professional Services"],
                ["code":  "restaurants", "name": "Restaurants"],
                ["code":  "shopping", "name": "Shopping"]]
    }
    
    func yelpDistances () ->[[String:String]] {
        return [
                ["code": "25000", "name": "Auto"],
                ["code": "200", "name": "2 blocks"],
                ["code": "800", "name": "6 blocks"],
                ["code": "1600", "name": "1 mile"],
                ["code": "8000", "name": "5 mile"]
        ]
    }
    
//    func numberOfRowsInSection(

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4;
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
