// p5swift-sample

import UIKit
import p5swift

class SketchListViewController: UITableViewController {
  private static let cellIdentifier = "cell"
  
  private var sketches: [SketchSample.Type] = []

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    sketches = [
      MySketch.self,
      ContactSketch.self,
      StrangeVibrationsSketch.self
    ]
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
    let sketch = sketches[indexPath.row]    
    navigationController!.pushViewController(SketchViewController(sketch: sketch), animated: true)
  }
}
