import Foundation
import UIKit

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var addNewCityButton: UIBarButtonItem!
    @IBOutlet var tableView: UITableView!
    
    var citiesArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let myLocationString: String = NSLocalizedString("myLocationKey", comment: "")
        
        if UserDefaults.standard.object(forKey: UserDefaultsKey.kCities.rawValue) == nil {
            citiesArray.append(myLocationString)
            UserDefaults.standard.set(citiesArray, forKey: UserDefaultsKey.kCities.rawValue)
        } else {
            if let citiesArray = UserDefaults.standard.object(forKey: UserDefaultsKey.kCities.rawValue) as? [String] {
                self.citiesArray = citiesArray
            }
        }
        tableView.reloadData()
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
        
        let weatherVModel = WeatherViewModel()
        weatherVModel.selectedCity = citiesArray[indexPath.row]
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let weatherVC: WeatherViewController = storyBoard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
        
        weatherVC.weatherVModel = weatherVModel
        
        self.navigationController?.pushViewController(weatherVC, animated: true)
    }
    
    @IBAction func didTapAddNewCityButton() {
        let alertNewCity = UIAlertController(title: NSLocalizedString("title_add_city", comment: ""), message: "", preferredStyle: .alert)
        alertNewCity.addTextField()
        alertNewCity.addAction(UIAlertAction(title: NSLocalizedString("addButton_add_city", comment: ""), style: .default, handler: {
            _ in
            let textField = alertNewCity.textFields![0]
            self.citiesArray.append(textField.text ?? "")
            UserDefaults.standard.set(self.citiesArray, forKey: UserDefaultsKey.kCities.rawValue)
            self.tableView.reloadData()
        }))
        
        alertNewCity.addAction(UIAlertAction(title: NSLocalizedString("cancelButton_add_city", comment: ""), style: .cancel))
        
        self.present(alertNewCity, animated: true)
    }
}

enum UserDefaultsKey: String {
    case kCities = "kCities"
}
