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
    self.navigationItem.titleView = titleView(for: sketchType)
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                                             style: .done,
                                                             target: self,
                                                             action: #selector(onAccessoryButton(_:)))
  }
  
  @objc private func onAccessoryButton(_ sender: UIBarButtonItem) {
    let image = UIGraphicsImageRenderer(bounds: view.bounds).image { context in
      view.layer.draw(in: context.cgContext)
    }
    let activityViewController = UIActivityViewController(activityItems: [ image ], applicationActivities: nil)
    activityViewController.popoverPresentationController?.sourceView = self.view
    self.present(activityViewController, animated: true, completion: nil)
  }
  
  private func titleView(for sketchType: SketchSample.Type) -> UIView {
    let titleLabel = UIButton(primaryAction: UIAction(handler: { _ in
      UIApplication.shared.open(sketchType.url ?? sketchType.authorUrl, options: [:], completionHandler: nil)
    }))
    titleLabel.setTitle(sketchType.title, for: .normal)
    titleLabel.titleLabel!.font = UIFont.preferredFont(forTextStyle: .body)
    titleLabel.setTitleColor(.label, for: .normal)
    titleLabel.sizeToFit()
    let authorLabel = UIButton(primaryAction: UIAction(handler: { _ in
      UIApplication.shared.open(sketchType.authorUrl, options: [:], completionHandler: nil)
    }))
    authorLabel.setTitle(sketchType.author, for: .normal)
    authorLabel.titleLabel!.font = UIFont.preferredFont(forTextStyle: .footnote)
    authorLabel.setTitleColor(.secondaryLabel, for: .normal)
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

