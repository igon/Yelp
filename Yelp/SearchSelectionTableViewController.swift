//
//  SearchSelectionTableViewController.swift
//  Yelp
//
//  Created by Gonzalez, Ivan on 9/27/15.
//  Copyright © 2015 Timothy Lee. All rights reserved.
//
import UIKit


let LAST_SEARCH_TERM_VALUE = "default_search_term_value"
let LAST_DEALS_VALUE = "default_deals_value"
let LAST_DISTANCE_VALUE = "last_distance_value"
let LAST_CATEGORY_VALUE = "last_category_value"
let LAST_SORTED_VALUE = "last_sorted_value"
let LAST_RECORDED_LOCATION = "last_known_location"


struct MetaValue {
    var enumId:String
    var enumValue: String
}

// Distance
let Distance: [MetaValue] = [MetaValue(enumId: "25000", enumValue: "Auto"), MetaValue(enumId: "200", enumValue: "2 blocks"), MetaValue(enumId: "800", enumValue: "6 blocks"), MetaValue(enumId: "1600", enumValue: "1 mile"), MetaValue(enumId: "8000", enumValue: "5 mile")]

let Sorted: [MetaValue] = [MetaValue(enumId: "0", enumValue: "Best Match"), MetaValue(enumId: "1", enumValue: "Distance"), MetaValue(enumId: "2", enumValue: "Rating")]


let Categories: [MetaValue] = [MetaValue(enumId: "", enumValue: "Select"), MetaValue(enumId: "active", enumValue: "Active Life"), MetaValue(enumId: "arts", enumValue: "Arts & Entertainment"), MetaValue(enumId: "auto", enumValue: "Automotive"), MetaValue(enumId: "beautysvc", enumValue: "Beauty & Spas"), MetaValue(enumId: "education", enumValue: "Education"), MetaValue(enumId: "eventservices", enumValue: "Event Planning & Services"),  MetaValue(enumId: "financialservices", enumValue: "Financial Services "),  MetaValue(enumId: "food", enumValue: "Food"),  MetaValue(enumId: "health", enumValue: "Health & Medical"), MetaValue(enumId: "homeservices", enumValue: "Home Services"), MetaValue(enumId: "hotelstravel", enumValue: "Hotels & Travel"), MetaValue(enumId: "localflavor", enumValue: "Local Flavor"), MetaValue(enumId: "localservices", enumValue: "Local Services"), MetaValue(enumId: "massmedia", enumValue: "Mass Media"), MetaValue(enumId: "nightlife", enumValue: "Nightlife"), MetaValue(enumId: "pets", enumValue: "Pets"), MetaValue(enumId: "professional", enumValue: "Professional Services"),MetaValue(enumId: "restaurants", enumValue: "Restaurants"), MetaValue(enumId: "shopping", enumValue: "Shopping")]

protocol SearchSelectionFilterTableViewControllerDelegate {
    func triggerSearchWithValues(dealPref: Bool?, distance: String?, sortBy: String?, category: String?)
}


class SearchSelectionFilterTableViewController: UITableViewController {
    var delegate: SearchSelectionFilterTableViewControllerDelegate? = nil
    var isCollapsedSection: [Bool] = [true, true, true, true]
    var numberOfCellsInSection: [Int] = [1, Distance.count, Sorted.count, Categories.count]
    var dealPrefSelected: Bool = false
    var distanceIdSelected: MetaValue = MetaValue(enumId: Distance[0].enumId, enumValue: Distance[0].enumValue)
    var distanceRowSelected: Int = 0
    var sortPrefSelected: MetaValue = MetaValue(enumId: Sorted[0].enumId, enumValue: Sorted[0].enumValue)
    var sortRowSelected: Int = 0
    var categoryIdSelected: MetaValue = MetaValue(enumId: Categories[0].enumId, enumValue: Categories[0].enumValue)
    var categoryRowSelected: Int = 0
    
    
    var titleHeader: [String] = ["Most Popular", "Distance", "Sort by", "Category"]
    
    @IBOutlet var searchSelectionTableView: UITableView!
    @IBOutlet weak var dealOfferSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchSelectionTableView.rowHeight = 44
        searchSelectionTableView.registerNib(UINib(nibName: "SwitchSelctionTableViewCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "com.boxtiq.SwitchSelectionTableViewCell")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if (defaults.objectForKey(LAST_DEALS_VALUE) != nil) {
            let val: AnyObject = defaults.objectForKey(LAST_DEALS_VALUE)!
            dealPrefSelected = val as! Bool
        }
        
        if (defaults.objectForKey(LAST_DISTANCE_VALUE) != nil) {
            let val: AnyObject = defaults.objectForKey(LAST_DISTANCE_VALUE)!
            distanceIdSelected = MetaValue(enumId: ((val as! String).componentsSeparatedByString(","))[0]
                , enumValue: ((val as! String).componentsSeparatedByString(","))[1])
            
            distanceRowSelected = Int((val as! String).componentsSeparatedByString(",")[2])!
        }
        
        if (defaults.objectForKey(LAST_CATEGORY_VALUE) != nil) {
            let val: AnyObject = defaults.objectForKey(LAST_CATEGORY_VALUE)!
            categoryIdSelected = MetaValue(enumId: ((val as! String).componentsSeparatedByString(":"))[0]
                , enumValue: ((val as! String).componentsSeparatedByString(":"))[1])
            categoryRowSelected = Int((val as! String).componentsSeparatedByString(":")[2])!
        }
        
        if (defaults.objectForKey(LAST_SORTED_VALUE) != nil) {
            let val: AnyObject = defaults.objectForKey(LAST_SORTED_VALUE)!
            sortPrefSelected = MetaValue(enumId: ((val as! String).componentsSeparatedByString(","))[0]
                , enumValue: ((val as! String).componentsSeparatedByString(","))[1])
            sortRowSelected = Int((val as! String).componentsSeparatedByString(",")[2])!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 4
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return numberOfCellsInSection[section]
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleHeader[section]
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.section == 0) {
            let cell: SwitchCell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            cell.switchLabel.text = "Offering a deal"
            cell.onSwitch.on = dealPrefSelected
            cell.onSwitch.addTarget(self, action: "dealOfferSwitchChanged:", forControlEvents: UIControlEvents.ValueChanged)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("LabelViewCell", forIndexPath: indexPath) as! LabelViewCell
            
            if (indexPath.section == 1) {
                cell.selectionLabel.text = Distance[indexPath.row].enumValue
                if (indexPath.row == 0) {
                    cell.selectionLabel.text = distanceIdSelected.enumValue
                    cell.selectionButton.setBackgroundImage(UIImage(named: "Select"), forState: UIControlState.Normal)
                } else {
                    if (distanceRowSelected == indexPath.row) {
                        cell.selectionButton.setBackgroundImage(UIImage(named: "Selected"), forState: UIControlState.Normal)
                    } else {
                        cell.selectionButton.setBackgroundImage(UIImage(named: "Unselected"), forState: UIControlState.Normal)
                    }
                    if (isCollapsedSection[1] == true) {
                        cell.hidden = true
                    }
                }
                
            }
            
            
            if (indexPath.section == 2) {
                cell.selectionLabel.text = Sorted[indexPath.row].enumValue
                if (indexPath.row == 0) {
                    cell.selectionLabel.text = sortPrefSelected.enumValue
                    cell.selectionButton.setBackgroundImage(UIImage(named: "Select"), forState: UIControlState.Normal)
                } else {
                    if (sortRowSelected == indexPath.row) {
                        cell.selectionButton.setBackgroundImage(UIImage(named: "Selected"), forState: UIControlState.Normal)
                    } else {
                        cell.selectionButton.setBackgroundImage(UIImage(named: "Unselected"), forState: UIControlState.Normal)
                    }
                    if (isCollapsedSection[2] == true) {
                        cell.hidden = true
                    }
                }
            }
            
            if (indexPath.section == 3) {
                cell.selectionLabel.text = Categories[indexPath.row].enumValue
                if (indexPath.row == 0) {
                    cell.selectionLabel.text = categoryIdSelected.enumValue
                    cell.selectionButton.setBackgroundImage(UIImage(named: "Select"), forState: UIControlState.Normal)
                } else {
                    if (categoryRowSelected == indexPath.row) {
                        cell.selectionButton.setBackgroundImage(UIImage(named: "Selected"), forState: UIControlState.Normal)
                    } else {
                        cell.selectionButton.setBackgroundImage(UIImage(named: "Unselected"), forState: UIControlState.Normal)
                    }
                    
                    if (isCollapsedSection[3] == true) {
                        cell.hidden = true
                    }
                }
            }
            
            
            return cell
        }
        
    }
    
    @IBAction func dealOfferSwitchChanged(sender: AnyObject) {
        print("deal offer selected")
        dealPrefSelected = (sender as! UISwitch).on
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func searchButtonPressed(sender: AnyObject) {
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(dealPrefSelected, forKey: LAST_DEALS_VALUE)
        defaults.setObject("\(distanceIdSelected.enumId),\(distanceIdSelected.enumValue),\(distanceRowSelected)",  forKey: LAST_DISTANCE_VALUE)
        defaults.setObject("\(sortPrefSelected.enumId),\(sortPrefSelected.enumValue),\(sortRowSelected)", forKey: LAST_SORTED_VALUE)
        defaults.setObject("\(categoryIdSelected.enumId):\(categoryIdSelected.enumValue):\(categoryRowSelected)", forKey: LAST_CATEGORY_VALUE)
        defaults.synchronize()
        
        delegate?.triggerSearchWithValues(dealPrefSelected, distance: distanceIdSelected.enumId, sortBy: sortPrefSelected.enumId, category: categoryIdSelected.enumId)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var prevRowSelected = 0
        
        if (indexPath.section > 0 && indexPath.row == 0) {
            if (isCollapsedSection[indexPath.section] == true) {
                hideUnhideCells(indexPath.section, hidden: false)
                isCollapsedSection[indexPath.section] = false
                
                let cell: LabelViewCell? = self.searchSelectionTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: indexPath.section)) as? LabelViewCell
                
                
                if (indexPath.section == 1) {
                    cell?.selectionLabel.text = Distance[0].enumValue
                } else if (indexPath.section == 2) {
                    cell?.selectionLabel.text = Sorted[0].enumValue
                } else if (indexPath.section == 3) {
                    cell?.selectionLabel.text = Categories[0].enumValue
                }
                
            }   else {
                
                if (indexPath.section == 1) {
                    prevRowSelected = distanceRowSelected
                    distanceIdSelected = Distance[indexPath.row]
                    distanceRowSelected = indexPath.row
                } else if (indexPath.section == 2) {
                    prevRowSelected = sortRowSelected
                    sortPrefSelected = Sorted[indexPath.row]
                    sortRowSelected = indexPath.row
                } else if (indexPath.section == 3) {
                    prevRowSelected = categoryRowSelected
                    categoryIdSelected = Categories[indexPath.row]
                    categoryRowSelected = indexPath.row
                }
                
                setImages(prevRowSelected, currentRow: indexPath.row,  currentSection: indexPath.section)
                hideUnhideCells(indexPath.section, hidden: true)
                isCollapsedSection[indexPath.section] = true
            }
        } else {
            if (indexPath.section > 0) {
                if (indexPath.section == 1) {
                    prevRowSelected = distanceRowSelected
                    distanceRowSelected = indexPath.row
                    distanceIdSelected = Distance[indexPath.row]
                    let cell: LabelViewCell? = self.searchSelectionTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 1)) as? LabelViewCell
                    
                    setImages(prevRowSelected, currentRow: indexPath.row, currentSection: 1)
                    
                    if (cell != nil) {
                        cell?.selectionLabel.text = distanceIdSelected.enumValue
                    }
                    
                    
                } else if (indexPath.section == 2) {
                    prevRowSelected = sortRowSelected
                    sortRowSelected = indexPath.row
                    sortPrefSelected = Sorted[indexPath.row]
                    let cell: LabelViewCell? = self.searchSelectionTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 2)) as? LabelViewCell
                    
                    setImages(prevRowSelected, currentRow: indexPath.row, currentSection: 2)
                    
                    if (cell != nil) {
                        cell?.selectionLabel.text = sortPrefSelected.enumValue
                    }
                } else if (indexPath.section == 3) {
                    prevRowSelected = categoryRowSelected
                    categoryRowSelected = indexPath.row
                    categoryIdSelected = Categories[indexPath.row]
                    
                    let cell: LabelViewCell? = self.searchSelectionTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 3)) as? LabelViewCell
                    
                    setImages(prevRowSelected, currentRow: indexPath.row, currentSection: 3)
                    
                    if (cell != nil) {
                        cell?.selectionLabel.text = categoryIdSelected.enumValue
                    }
                }
                
                hideUnhideCells(indexPath.section, hidden: true)
                isCollapsedSection[indexPath.section] = true
            }
        }
        
        if (indexPath.section > 0) {
            self.searchSelectionTableView.beginUpdates()
            self.searchSelectionTableView.endUpdates()
        }
        
        
        searchSelectionTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section > 0 && indexPath.row > 0 && isCollapsedSection[indexPath.section] == true) {
            return 1
        }
        
        return searchSelectionTableView.rowHeight
    }
    
    
    func hideUnhideCells(section: Int, hidden: Bool) {
        for index in 1...(numberOfCellsInSection[section] - 1) {
            searchSelectionTableView.cellForRowAtIndexPath(NSIndexPath(forRow: index, inSection: section))?.hidden = hidden
        }
    }
    
    
    func setImages(prevRowSelected: Int, currentRow: Int,  currentSection: Int) {
        if (prevRowSelected != 0) {
            let cellP: LabelViewCell? = self.searchSelectionTableView.cellForRowAtIndexPath(NSIndexPath(forRow: prevRowSelected, inSection: currentSection)) as? LabelViewCell
            if (cellP != nil) {
                cellP?.selectionButton.setBackgroundImage(UIImage(named: "Unselected"), forState: UIControlState.Normal)
            }
        }
        
        if (currentRow != 0) {
            let cell: LabelViewCell? = self.searchSelectionTableView.cellForRowAtIndexPath(NSIndexPath(forRow: currentRow, inSection: currentSection)) as? LabelViewCell
            if (cell != nil) {
                cell?.selectionButton.setBackgroundImage(UIImage(named: "Selected"), forState: UIControlState.Normal)
            }
        }
    }
    
}
