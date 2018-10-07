
import UIKit
import CoreData

class ViewController: UIViewController {
    
    //MARK:- Variables
    var people = [Person] ()

    //MARK:- Outlets
    
    @IBOutlet weak var myTableView: UITableView!
    
    //MARK:- Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Fetching Request
        
        let fetchRequest: NSFetchRequest <Person> = Person.fetchRequest()
        
        do {
            let people = try PresistanceServices.context.fetch(fetchRequest)
            self.people = people
            self.myTableView.reloadData()
            
        }catch {
            let nserror = error as NSError
            fatalError("Error Fetching Data \(nserror), \(nserror.userInfo)")
        }
        
    }

    @IBAction func onPlusTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Person", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Age"
            textField.keyboardType = .numberPad
        }
        
        let action = UIAlertAction(title: "Post", style: .default) { (_) in
            let userName = alert.textFields!.first!.text!
            let userAge = alert.textFields!.last!.text!
            
            //MARK:-  Saving Data in the DB
            let person = Person(context: PresistanceServices.context)
            person.name = userName
            person.age = Int16(userAge)!
           
            PresistanceServices.saveContext()
            
            self.people.append(person)
            self.myTableView.reloadData()
            
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
    
    }
    
    
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        
        cell.textLabel?.text = people[indexPath.row].name
        cell.detailTextLabel?.text = String(people[indexPath.row].age)
        
        return cell
        
    
    }
    
    
}
