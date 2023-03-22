import MockMarks
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    let window = UIWindow(windowScene: windowScene)
    self.window = window

    // 1. If we're UI testing, do MockMarks's global setup.
    MockMarks.setUp()

    // 2. Set its session property to your app's URLSession instance.
    MockMarks.session = .init(mocking: .shared)

    // 3. Use the MockMarks session if it's available in your app.
    let vm = ViewModel(urlSession: MockMarks.session ?? .shared)

    // 4. Let's get going!
    window.rootViewController = ViewController(viewModel: vm)
    window.makeKeyAndVisible()
  }
}
