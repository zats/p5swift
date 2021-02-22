// p5swift-sample

import UIKit
import p5swift

class SketchViewController: UIViewController {
  private let sketchType: SketchSample.Type
  private lazy var sketch = sketchType.init(size: Size(cgSize: UIScreen.main.bounds.size))
  
  init(sketch: SketchSample.Type) {
    self.sketchType = sketch
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) { fatalError() }
  
  override func loadView() {
    self.view = sketch.view    
    self.navigationItem.titleView = titleView(for: sketchType.title, author: sketchType.author)
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "info.circle"), style: .done, target: self, action: #selector(onInfoButton(_:)))
    self.edgesForExtendedLayout = [.bottom]
  }
  
  @objc private func onInfoButton(_ sender: UIBarButtonItem) {
    UIApplication.shared.open(sketchType.url ?? sketchType.authorUrl, options: [:], completionHandler: nil)
  }
  
  private func titleView(for title: String, author: String) -> UIView {
    let titleLabel = UILabel()
    titleLabel.text = title
    titleLabel.font = UIFont.preferredFont(forTextStyle: .body)
    titleLabel.textColor = .label
    titleLabel.sizeToFit()
    let authorLabel = UILabel()
    authorLabel.text = author
    authorLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
    authorLabel.textColor = .secondaryLabel
    authorLabel.sizeToFit()
    let stackView = UIStackView(arrangedSubviews: [
      titleLabel,
      authorLabel
    ])
    stackView.alignment = .center
    stackView.axis = .vertical
    return stackView
  }
}

