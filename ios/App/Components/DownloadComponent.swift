import HotwireNative
import UIKit
import WebKit

public final class DownloadComponent: BridgeComponent {
  override public nonisolated class var name: String { "download" }

  private var viewController: UIViewController? {
    delegate?.destination as? UIViewController
  }
  
  private var window: UIWindow? {
    viewController?.view.window as? UIWindow
  }
  
  var currentWebView: WKWebView? {
    (viewController as? VisitableViewController)?.visitableView.webView
  }
  
  override public func onReceive(message: Message) {
    guard let event = Event(rawValue: message.event) else { return }
    switch event {
    case .connect:
      guard let data: MessageData = message.data() else { return }
      Task { await syncCookiesAndDownload(csrfToken: data.token ) }
    }
  }
  
  private func syncCookiesAndDownload(csrfToken: String) async {
    guard let webView = currentWebView else {
      assertionFailure("No webView available")
      return
    }
    
    let cookies = await webView.configuration.websiteDataStore.httpCookieStore.allCookies()
    cookies.forEach { HTTPCookieStorage.shared.setCookie($0) }
    
    do {
      let downloadService = ZipDownloadService()
      let destination = try await downloadService.downloadZip(csrfToken: csrfToken, filename: "skribl.zip")
      await MainActor.run { self.presentSavePicker(for: destination) }
    } catch {
      // see point 4 below on reporting this back to JS
    }
  }
  
  func presentSavePicker(for fileURL: URL) {
    let picker = UIDocumentPickerViewController(
      forExporting: [fileURL],
      asCopy: true
    )
    
    picker.modalPresentationStyle = .formSheet
    viewController?.present(picker, animated: true)
  }
  
}

private extension DownloadComponent {
  enum Event: String {
    case connect
  }
}

private extension DownloadComponent {
  struct MessageData: Decodable {
    let token: String
    
    enum CodingKeys: String, CodingKey {
      case token
    }
  }
}
