//
//  EateryDetailViewController.swift
//  Eateries
//
//  Created by Ivan Akulov on 01/10/2016.
//  Copyright © 2016 Ivan Akulov. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var rateButton: UIButton!
  @IBOutlet weak var mapButton: UIButton!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var imageView: UIImageView!
  var restaurant: Restaurant?
  
  @IBAction func unwindSegue(segue: UIStoryboardSegue) {
    guard let svc = segue.source as? RateViewController else { return }
    guard let rating = svc.restRating else { return }
    rateButton.setImage(UIImage(named:rating), for: .normal)
    restaurant?.rating = rating
  }
  
  override func viewWillAppear(_ animated: Bool) {
    navigationController?.hidesBarsOnSwipe = false
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    let buttons = [rateButton, mapButton]
    for button in buttons {
      guard let button = button else { break }
      button.layer.cornerRadius = 5
      button.layer.borderWidth = 1
      button.layer.borderColor = UIColor.white.cgColor
    }
    
    rateButton.setImage(UIImage(named:(restaurant?.rating)!), for: .normal)
    
    tableView.estimatedRowHeight = 38
    tableView.rowHeight = UITableViewAutomaticDimension
    
    imageView.image = UIImage(data: restaurant!.image as! Data)
    
//    tableView.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
//    tableView.separatorColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
    tableView.tableFooterView = UIView(frame: CGRect.zero)
    title = restaurant!.name
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetailTableViewCell
    
    switch indexPath.row {
    case 0:
      cell.keyLabel.text = "Name"
      cell.valueLabel.text = restaurant!.name
    case 1:
      cell.keyLabel.text = "Type"
      cell.valueLabel.text = restaurant!.type
    case 2:
      cell.keyLabel.text = "Location"
      cell.valueLabel.text = restaurant!.location
    case 3:
      cell.keyLabel.text = "Were you there?"
      cell.valueLabel.text = restaurant!.isVisited ? "Yes" : "No"
    default:
      break
    }
    
    cell.backgroundColor = UIColor.clear
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "mapSegue" {
      let dvc = segue.destination as! MapViewController
      dvc.restaurant = self.restaurant
    }
  }
  
  
  
  
  
  
  
}
