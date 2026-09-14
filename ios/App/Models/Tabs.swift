import HotwireNative
import UIKit

enum Tabs {
  static func all(for userId: Int) -> [HotwireTab] {
    let base = Endpoint.baseURL!
    return [
      HotwireTab(
        title: "Notes",
        image: UIImage(named: "Notes")!,
        url: base.appending(path: "\(userId)/notes")
      ),
      HotwireTab(
        title: "New Note",
        image: UIImage(named: "Note")!,
        url: base.appending(path: "\(userId)/notes/new")
      ),
      HotwireTab(
        title: "Settings",
        image: UIImage(systemName: "gearshape.fill")!,
        url: base.appending(path: "\(userId)/account")
      ),
    ]
  }
}
