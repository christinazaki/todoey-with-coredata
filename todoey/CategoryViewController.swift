

import UIKit
import CoreData
class CategoryViewController: UITableViewController {
    var categories = [Category]()
     var tf = UITextField ()
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
       loadCategories()
        
    }

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)

      cell.textLabel?.text = categories[indexPath.row].name

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        print("ggg")
        if let indexPath = tableView.indexPathForSelectedRow{ // indexpath
        destinationVC.selectedCategory = categories[indexPath.row]
        }
    }


    func saveCategory() {
        do{  print("load")
            
            try context.save()
        }
        catch{
            print("error")
        }
        self.tableView.reloadData()
    }
//with request : NSFetchRequest<Category> = Category.fetchRequest()
    func loadCategories()  {
    let request : NSFetchRequest<Category> = Category.fetchRequest()
        do{
            categories =  try context.fetch(request)
        }catch{
           print("error")
    }
        tableView.reloadData()
    }
    
    @IBAction func addBtn(_ sender: Any) {
        
        let alert =  UIAlertController(title: "add new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add ", style: .default ){(action)in
  let newCategory = Category(context: self.context)
            newCategory.name = self.tf.text!
            self.categories.append(newCategory)
        
            self.saveCategory()
            
        }
        alert.addAction(action)
        alert.addTextField {(field ) in
            self.tf = field
            self.tf.placeholder = "add new Category"
        }
        present(alert,animated: true,completion:nil)
    }
}
