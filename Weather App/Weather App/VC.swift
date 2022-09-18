//import UIKit
//
//class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
//
//    @IBOutlet var addNewCityButton: UIBarButtonItem!
//    @IBOutlet var tableView: UITableView!
//
//    var citiesArray: [String] = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        let button = UIButton(type: .roundedRect)
//              button.frame = CGRect(x: 20, y: 400, width: 100, height: 30)
//              button.setTitle("Test Crash", for: [])
//              button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
//              view.addSubview(button)
//
//        tableView.delegate = self
//        tableView.dataSource = self
//    }
//
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//
//        let myLocationString: String = NSLocalizedString("myLocationKey", comment: "")
//
//        if UserDefaults.standard.object(forKey: UserDefaultsKey.kCities.rawValue) == nil {
//            citiesArray.append(myLocationString)
//            UserDefaults.standard.set(citiesArray, forKey: UserDefaultsKey.kCities.rawValue)
//        } else {
//            if let citiesArray = UserDefaults.standard.object(forKey: UserDefaultsKey.kCities.rawValue) as? [String] {
//                self.citiesArray = citiesArray
//            }
//        }
//        tableView.reloadData()
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return citiesArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "NavigationTableViewCell", for: indexPath) as? NavigationTableViewCell {
//
//            cell.cityLabel.text = citiesArray[indexPath.row]
//
//            return cell
//        }
//        return UITableViewCell()
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc: WeatherViewController = storyBoard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
//        vc.selectedCity = citiesArray[indexPath.row]
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//
//    @IBAction func didTapAddNewCityButton() {
//        let alertNewCity = UIAlertController(title: NSLocalizedString("title_add_city", comment: ""), message: "", preferredStyle: .alert)
//        alertNewCity.addTextField()
//        alertNewCity.addAction(UIAlertAction(title: NSLocalizedString("addButton_add_city", comment: ""), style: .default, handler: {
//            _ in
//            let textField = alertNewCity.textFields![0]
//            self.citiesArray.append(textField.text ?? "")
//            UserDefaults.standard.set(self.citiesArray, forKey: UserDefaultsKey.kCities.rawValue)
//            self.tableView.reloadData()
//        }))
//
//        alertNewCity.addAction(UIAlertAction(title: NSLocalizedString("cancelButton_add_city", comment: ""), style: .cancel))
//
//        self.present(alertNewCity, animated: true)
//    }
//
//    @IBAction func crashButtonTapped(_ sender: AnyObject) {
//          let numbers = [0]
//          let _ = numbers[1]
//      }
//
//}
//
//
