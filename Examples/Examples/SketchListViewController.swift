// p5swift-sample

import UIKit
import p5swift

class SketchListViewController: UITableViewController {
  private static let cellIdentifier = "cell"
  
  private var sketches: [SketchSample.Type] = []
  
  lazy var sketchIndex = Int(ProcessInfo.processInfo.environment["OPEN_SKETCH_INDEX", default: ""])

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    sketches = [
      MySketch.self,
      ContactSketch.self,
      StrangeVibrationsSketch.self,
      TilesSketch.self,
      PleasingTraiangleSketch.self
    ]
    
    autoNavigateToSketch()
  }
  
  private func autoNavigateToSketch() {
    if let sketchIndex = sketchIndex {
      var index: Int
      if sketchIndex == -1 {
        // open last one
        index = sketches.count - 1
      } else if sketchIndex >= 0 && sketchIndex < sketches.count {
        index = sketchIndex
      } else {
        return
      }
      navigateToSketch(at: index)
      self.sketchIndex = nil
    }
  }
  
  override func viewDidLoad() {
    self.title = "Examples"
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return sketches.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: SketchListViewController.cellIdentifier, for: indexPath)
    let sketch = sketches[indexPath.row]
    cell.textLabel!.text = sketch.title
    cell.detailTextLabel!.text = sketch.author
    return cell 
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    navigateToSketch(at: indexPath.row)
  }
  
  private func navigateToSketch(at index: Int) {
    let sketch = sketches[index]
    navigationController!.pushViewController(SketchViewController(sketch: sketch), animated: true)
  }
}
