import Foundation
import UIKit

class FirstView: UIView {
    
    func addCrushButton() {
        let button = UIButton(type: .roundedRect)
              button.frame = CGRect(x: 20, y: 400, width: 100, height: 30)
              button.setTitle("Test Crash", for: [])
              button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        superview!.addSubview(button) //тут проблемсы с view
    }
    
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
          let numbers = [0]
          let _ = numbers[1]
      }
}
