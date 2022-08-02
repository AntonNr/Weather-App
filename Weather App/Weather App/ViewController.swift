import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var addNewCityButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    
    var citiesArray: [String] = []
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.object(forKey: UserDefaultsKey.kCities.rawValue) == nil {
            citiesArray.append("My Location")
            UserDefaults.standard.set(citiesArray, forKey: UserDefaultsKey.kCities.rawValue)
        } else {
            citiesArray = UserDefaults.standard.object(forKey: UserDefaultsKey.kCities.rawValue) as! [String] // как безопасно преобразовать в String?
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return citiesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NavigationTableViewCell", for: indexPath) as? NavigationTableViewCell {
            
            cell.cityLabel.text = citiesArray[indexPath.row]
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc: WeatherViewController = storyBoard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        vc.selectedCity = citiesArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    @IBAction func didTapAddNewCityButton() {
        let alertNewCity = UIAlertController(title: "What city would you like to add?", message: "", preferredStyle: .alert)
        alertNewCity.addTextField()
        alertNewCity.addAction(UIAlertAction(title: "Add", style: .default, handler: {
            _ in
            let textField = alertNewCity.textFields![0]
            self.citiesArray.append(textField.text ?? "")
            UserDefaults.standard.set(self.citiesArray, forKey: UserDefaultsKey.kCities.rawValue)
            self.tableView.reloadData()
        }))
        
        alertNewCity.addAction(UIAlertAction(title: "Cancle", style: .cancel))
        
        self.present(alertNewCity, animated: true)
    }
}

enum UserDefaultsKey: String {
    case kCities = "kCities"
}
