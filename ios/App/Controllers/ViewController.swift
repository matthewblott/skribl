import HotwireNative
import UIKit
import WebKit

class ViewController : HotwireWebViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let location = self.bridgeDelegate.location
    
    if(location.contains("privacy") || location.contains("terms")) {
      self.navigationItem.hidesBackButton = false
    }
    else if(location.contains("notes")) {
      self.navigationItem.hidesBackButton = true
    }
  }
}
