import Stubbie
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    // 1. If we're UI testing, do Stubbie's global setup.
    // 2. Set its session property to your app's URLSession instance.
    if Stubbie.isXCUITest {
      Stubbie.setUp()
      Stubbie.session = StubbieURLSession(stubbing: .shared)
    }

    // 3. Use the Stubbie session if it's available in your app.
    let vm = ViewModel(urlSession: Stubbie.session ?? .shared)
    let vc = ViewController(viewModel: vm)

    let window = UIWindow(windowScene: windowScene)
    self.window = window

    window.rootViewController = vc
    window.makeKeyAndVisible()
  }
}
