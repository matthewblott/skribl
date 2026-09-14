import HotwireNative

class TabBarController: HotwireTabBarController {
  override init(navigatorDelegate: NavigatorDelegate?, lazyLoadTabs: Bool = false) {
    super.init(navigatorDelegate: navigatorDelegate, lazyLoadTabs: lazyLoadTabs)
  }
}
