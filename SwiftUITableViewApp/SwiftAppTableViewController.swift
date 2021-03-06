//
//  SwiftAppTableViewController.swift
//  SwiftUITableViewApp
//
//  Created by Ekaterina Krasnova on 02/11/2016.
//  Copyright © 2016 Ekaterina Krasnova. All rights reserved.
//

import UIKit
import CoreData

class SwiftAppTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    
//    var restaurantNames = ["Ogonёk Grill&Bar", "Елу", "Bonsai", "Дастархан", "Индокитай", "X.O", "Балкан Гриль", "Respublica", "Speak easy", "Morris Pub", "Вкусные истории", "Классик", "Lobe&Life", "Шок", "Бочка"]
//    
//    var restaurantImages = ["ogonek.jpg", "elu.jpg", "bonsai.jpg", "dastarhan.jpg", "indokitay.jpg", "x.o.jpg", "balkan.jpg", "respublika.jpg", "speakeasy.jpg", "morris.jpg", "istorii.jpg", "klassik.jpg", "love.jpg", "shok.jpg", "bochka.jpg"]
//
//    var restaurantIsVisited = [Bool](repeatElement(false, count: 15))
    
    var fetchResultsController:NSFetchedResultsController<Restaurant>!
    var searchController: UISearchController!
    var filteredResultArray: [Restaurant] = []
    var restaurants: [Restaurant] = []
    
    
//        Restaurant(name: "Ogonёk Grill&Bar", type: "ресторан", location: "Уфа", image: "ogonek.jpg", isVisited: false),
//        Restaurant(name: "Елу", type: "ресторан", location: "Уфа", image: "elu.jpg", isVisited: false),
//        Restaurant(name: "Bonsai", type: "ресторан", location: "Москва, Симферопольский бульвар 37, вход со стороны улицы", image: "bonsai.jpg", isVisited: false),
//        Restaurant(name: "Дастархан", type: "ресторан", location: "Уфа", image: "dastarhan.jpg", isVisited: false),
//        Restaurant(name: "Индокитай", type: "ресторан - клуб", location: "Москва", image: "indokitay.jpg", isVisited: false),
//        Restaurant(name: "X.O", type: "ресторан", location: "Уфа", image: "x.o.jpg", isVisited: false),
//        Restaurant(name: "Балкан Гриль", type: "ресторан", location: "Уфа", image: "balkan.jpg", isVisited: false),
//        Restaurant(name: "Respublica", type: "ресторан", location: "Уфа", image: "respublika.jpg", isVisited: false),
//        Restaurant(name: "Speak easy", type: "ресторан", location: "Уфа", image: "speakeasy.jpg", isVisited: false),
//        Restaurant(name: "Morris Pub", type: "ресторан", location: "Москва", image: "morris.jpg", isVisited: false),
//        Restaurant(name: "Вкусные истории", type: "ресторанный комплекс", location: "Уфа", image: "istorii.jpg", isVisited: false),
//        Restaurant(name: "Классик", type: "ресторан", location: "Уфа", image: "klassik.jpg", isVisited: false),
//        Restaurant(name: "Lobe&Life", type: "ресторан", location: "Уфа", image: "love.jpg", isVisited: false),
//        Restaurant(name: "Шок", type: "ресторан", location: "Уфа", image: "shok.jpg", isVisited: false),
//        Restaurant(name: "Бочка", type: "ресторан", location: "Уфа", image: "bochka.jpg", isVisited: false)
//    ]
    
    @IBAction func close(segue: UIStoryboardSegue) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.hidesBarsOnSwipe = true
    }
    
    func filterContentFor(searchText text:String) {
        filteredResultArray = restaurants.filter({ (restaurant) -> Bool in
            return (restaurant.name?.lowercased().contains(text.lowercased()))!
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        searchController.searchBar.tintColor = .white
        
        definesPresentationContext = true
        
        tableView.estimatedRowHeight = 85
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        let fetchRequest:NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultsController.delegate = self
            do {
                try fetchResultsController.performFetch()
                restaurants = fetchResultsController.fetchedObjects!
                print("Not saved")
            } catch let error as NSError {
                print("Not get data \(error), \(error.userInfo)")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = UserDefaults.standard
        let wasIntroWatched = userDefaults.bool(forKey: "wasIntroWatched")
        
        guard !wasIntroWatched else { return }
        
        if let pageVC = storyboard?.instantiateViewController(withIdentifier: "pageViewController")
            as? PageViewController {
             present(pageVC, animated: true, completion: nil)
        }
    }
    
    // MARK: - Fetch Results Controller Delegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            guard let indexPath = newIndexPath else { break }
            tableView.insertRows(at: [indexPath], with: .fade)
        case .delete:
            guard let indexPath = indexPath else { break }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .update:
            guard let indexPath = indexPath else { break }
            tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            tableView.reloadData()
        }
        restaurants = controller.fetchedObjects as! [Restaurant]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredResultArray.count
        }
        return restaurants.count
    }
    
    func restaurantToDisplayAt(indexPath: IndexPath) -> Restaurant {
        let restaurant: Restaurant
        if searchController.isActive && searchController.searchBar.text != "" {
            restaurant = filteredResultArray[indexPath.row]
        } else {
            restaurant = restaurants[indexPath.row]
        }
        return restaurant
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwiftAppTableViewCell
        
        let restaurant = restaurantToDisplayAt(indexPath: indexPath)
        
        cell.thumbnailImageView.image = UIImage(data: restaurant.image as! Data)
        cell.thumbnailImageView.layer.cornerRadius = 32.5
        cell.thumbnailImageView.clipsToBounds = true
        cell.nameLabel.text = restaurant.name
        cell.locationLabel.text = restaurant.location
        cell.typeLabel.text = restaurant.type

        cell.accessoryType = restaurant.isVisited ? .checkmark : .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //touch table view cell -> alert action
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let ac = UIAlertController(title: nil, message: "Выберите действие", preferredStyle: .actionSheet)
//        let call = UIAlertAction(title: "Call: +7(347)111-111\(indexPath.row)", style: .default, handler:
//            { (action: UIAlertAction) -> Void in
//                let alertC = UIAlertController(title: nil, message: "call impossible", preferredStyle: .alert)
//                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
//                alertC.addAction(ok)
//                self.present(alertC, animated: true, completion: nil)
//        })
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        let isVisitedTitle = self.restaurantIsVisited[indexPath.row] ? "Я не был здесь" : "Я был здесь"
//        let isVisited = UIAlertAction(title: isVisitedTitle, style: .default, handler: { action in
//            let cell = tableView.cellForRow(at: indexPath)
//            self.restaurantIsVisited[indexPath.row] = !self.restaurantIsVisited[indexPath.row]
//            cell?.accessoryType = self.restaurantIsVisited[indexPath.row] ? .checkmark : .none
//        })
//        ac.addAction(call)
//        ac.addAction(isVisited)
//        ac.addAction(cancel)
//        present(ac, animated: true, completion: nil)
//        
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
    
    //delete swipe (in table view)
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        
//        if editingStyle == .delete {
//            self.restaurantImages.remove(at: indexPath.row)
//            self.restaurantNames.remove(at: indexPath.row)
//            self.restaurantIsVisited.remove(at: indexPath.row)
//        }
////        tableView.reloadData()
//        tableView.deleteRows(at: [indexPath], with: .fade)
//    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let share = UITableViewRowAction(style: .default, title: "Share", handler: { (action, indexPath) in
            let defaultText = "I'm at the " + self.restaurants[indexPath.row].name!
            if let image = UIImage(data: self.restaurants[indexPath.row].image as! Data) {
                let activityController = UIActivityViewController(activityItems: [defaultText, image], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        })
        let delete = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            self.restaurants.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
                
                let objectToDelete = self.fetchResultsController.object(at: indexPath)
                context.delete(objectToDelete)
                
                do {
                    try context.save()
                    print("Object is deleted")
                } catch let error as NSError {
                    print("Object is not deleted \(error), \(error.userInfo)")
                }
            }
        })
        share.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        delete.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        return [delete, share]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let destinationVC = segue.destination as! DetailViewController
                destinationVC.restaurant = restaurantToDisplayAt(indexPath: indexPath)
            }
        }
    }
    
}

extension SwiftAppTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
        tableView.reloadData()
    }
}

extension SwiftAppTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            navigationController?.hidesBarsOnSwipe = false
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationController?.hidesBarsOnSwipe = true
    }
}
























