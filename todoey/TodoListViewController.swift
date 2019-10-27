

import UIKit
import CoreData
class TodoListViewController: UITableViewController , UISearchBarDelegate,UIPickerViewDelegate,UIImagePickerControllerDelegate{
 var itemArray = [Item]()
    var selectedCategory : Category?{
        didSet{
           loadItems() // load data ellli 5asa b category dh
        }
    }
   // let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
     //   .first?.appendingPathComponent("items.plist")// lel documention
    let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //ll coreData
   // let defaults = UserDefaults.standard
    // dh ll 7agat el basita m4 object
   var tf = UITextField()
    var tf2 = UITextField()

    override func viewDidLoad() {
        
        super.viewDidLoad()
       // searchBar.delegate = self
    
        loadItems()
        //print(self.dataFilePath)
//         let newItem = item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//        let newItem2 = item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem2)
//        let newItem3 = item()
//        newItem3.title = "Destory Demogoron"
//        itemArray.append(newItem3)
//      if let items = defaults.array(forKey:  "TodoListArray") as? [item]{
//           itemArray = items
//        }
    }
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = editAction(at:indexPath)
        let delete = deleteAction(at:indexPath)
        return UISwipeActionsConfiguration(actions: [delete,edit])
    }
    func editAction(at indexPath:IndexPath) -> UIContextualAction {
       
        let action = UIContextualAction(style: .normal, title: "edit"){
            (action,view,completion )in
          
           self.itemArray[indexPath.row].setValue("self.tf2", forKey: "title")
            
            self.saveItem()
            completion(true)
        }
        action.image = UIImage (named: "edit")
        action.backgroundColor = .green
        return action
    }
    func deleteAction(at indexPath:IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete"){
            (action,view,completion )in
          
            self.context.delete(self.itemArray[indexPath.row])//mohm gdn ashilo mn context el awel
              self.itemArray.remove(at: indexPath.row)
            self.saveItem()
            completion(true)
        }
        action.image = UIImage (named: "delete")
        action.backgroundColor = .red
        return action
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        if itemArray[indexPath.row].done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        print("ll")
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        if itemArray[indexPath.row].done == false {
            itemArray[indexPath.row].done = true
        } else {
            itemArray[indexPath.row].done = false
        }
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        }
//        else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
      
        self.saveItem()
       // tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addbutton(_ sender: UIBarButtonItem) {
        let alert =  UIAlertController(title: "add new todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default ){(action)in
            
          //  let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            let newItem = Item(context: self.context)
            newItem.title = self.tf.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory // dih bydif relation elli bano w ban el item
            self.itemArray.append( newItem)
            self.saveItem()
//            let encoder = PropertyListEncoder()
//            do{
//                let data = try encoder.encode(self.itemArray)
//                try data.write(to:self.dataFilePath!)
//            }
//            catch{
//                print("error")
//            }
            
           // self.itemArray.append(self.tf.text!)
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            //self.tableView.reloadData()
        }
        alert.addTextField{(alertTextField)in
            alertTextField.placeholder = "create new item"
            self.tf =  alertTextField
        }
        alert.addAction(action)
        present (alert, animated: true,completion: nil)
    }
    func saveItem()  {
       
       
        do{
            
          try context.save()
        }
        catch{
            print("error")
        }
         self.tableView.reloadData()
    }
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate : NSPredicate? = nil){ //read data mn Coredata
        // el code eli gai 34an lma ydos 3la category ytal3 el item bt3to mn 3'iro hytl3 kol item
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let addtionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,addtionalPredicate]) // load data elli mawgoda w elli htadaf
        }else{
             request.predicate = categoryPredicate // load data elli mawgoda
        }
        
     
       
       // let request : NSFetchRequest<Item> = Item.fetchRequest()
        do{
           itemArray =  try context.fetch(request) // bagib data mn context
        }catch{
            print("error")
        }
        tableView.reloadData()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {//  dh search
        let request :  NSFetchRequest<Item> = Item.fetchRequest()
     
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request,predicate: predicate)
       tableView.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {//34an lma myob2a4 fih 7arf f search
            loadItems()
            tableView.reloadData()
            DispatchQueue.main.async { // satr dh 34an el cursur y5tafi
                
              searchBar.resignFirstResponder()
                
            }        }
    }
}

