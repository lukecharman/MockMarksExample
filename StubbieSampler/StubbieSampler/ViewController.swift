import UIKit

class ViewController: UIViewController {

  private let viewModel: ViewModel

  init(viewModel: ViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    view.backgroundColor = .white
    view.addSubview(label)

    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      label.topAnchor.constraint(equalTo: view.topAnchor),
      label.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])

    viewModel.fetchString { [weak label] result in
      DispatchQueue.main.async {
        switch result {
        case .success(let string):
          label?.text = string
        case .failure(let error):
          label?.text = error.localizedDescription
        }
      }
    }
  }

  private lazy var label: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
}
