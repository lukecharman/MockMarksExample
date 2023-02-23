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

    if Stubbie.isXCUITest {
      Stubbie.setUp()
      Stubbie.session = StubbieURLSession(stubbing: .shared)
    }

    let vm = ViewModel(urlSession: Stubbie.session ?? .shared)
    let vc = ViewController(viewModel: vm)

    let window = UIWindow(windowScene: windowScene)

    self.window = window

    window.rootViewController = vc
    window.makeKeyAndVisible()
  }
}
