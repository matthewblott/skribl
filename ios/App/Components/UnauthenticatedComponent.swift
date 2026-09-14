import HotwireNative
import UIKit

public final class UnauthenticatedComponent: BridgeComponent {
  override public nonisolated class var name: String { "unauthenticated" }
  
  override public func onReceive(message: Message) {
    guard let event = Event(rawValue: message.event) else { return }
    
    switch event {
    case .connect:
      let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
      
      if let sceneDelegate {
        Settings.userId = 0
        sceneDelegate.clear()
        sceneDelegate.switchToNavigator()
        sceneDelegate.setToRoot()
      }
      
      return
    }
  }
  
}

private extension UnauthenticatedComponent {
  enum Event: String {
    case connect
  }
}
