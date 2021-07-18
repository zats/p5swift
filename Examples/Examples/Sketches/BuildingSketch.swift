// Examples

import Foundation
import p5swift

class Appartment {
  
  var frame: Rectangle {
    var rect = rooms.first!.frame
    rooms.dropFirst().forEach {
      rect = rect.union(with: $0.frame)
    }
    return rect
  }
  
  var rooms: [Room] = []
  var doors: [Door] = []
}

class Room {
  var frame: Rectangle
  var next: Room?
  var commonEdges: Set<Rectangle.Edge> = []
  
  init(frame: Rectangle) {
    self.frame = frame
  }
}

struct Door {
  enum Kind: CaseIterable {
    case single
    case double
    case biFold
    case revolving
  }
  
  var room1: Room
  var position: Point
  var kind: Kind
  var edge: Rectangle.Edge
}

extension Room {
  var allRooms: [Room] {
    var result: [Room] = [self]
    var current = self
    while let room = current.next {
      result.append(room)
      current = room
    }
    return result
  }
}


class BuildingSktch: Sketch, SketchSample {
  static var title = "Building"
  static var author = "Sash Zats"
  static var authorUrl = URL(string: "https://twitter.com/zats")!
  static var url: URL? = nil
    
  private let appartment = Appartment()
  
  private let roomSizeRange: ClosedRange<Float> = 20...80
  
  private func generateRoom(from: (room: Room, edge: Rectangle.Edge)?) -> Room {
    guard let from = from else {
      let frame = Rectangle(origin: .zero,
                            size: Size(width: random(min: roomSizeRange.lowerBound, max: roomSizeRange.upperBound),
                                       height: random(min: roomSizeRange.lowerBound, max: roomSizeRange.upperBound)))
      return Room(frame: frame)
    }
    
    let (root, randomEdge) = from
    let size: Size
    let origin: Point
    switch randomEdge {
    case .minX:
      size = Size(width: random(min: roomSizeRange.lowerBound, max: roomSizeRange.upperBound), height: root.frame.height)
      origin = Point(x: root.frame.x - size.width, y: root.frame.y)
    case .minY:
      size = Size(width: root.frame.width, height: random(min: roomSizeRange.lowerBound, max: roomSizeRange.upperBound))
      origin = Point(x: root.frame.x, y: root.frame.y - size.height)
    case .maxX:
      size = Size(width: random(min: roomSizeRange.lowerBound, max: roomSizeRange.upperBound), height: root.frame.height)
      origin = Point(x: root.frame.maxX, y: root.frame.y)
    case .maxY:
      size = Size(width: root.frame.width, height: random(min: roomSizeRange.lowerBound, max: roomSizeRange.upperBound))
      origin = Point(x: root.frame.x, y: root.frame.maxY)
    }
    return Room(frame: Rectangle(origin: origin, size: size))
  }
  
  private var commonWalls: [Line] = []
    
  override func setup() {
    let root = generateRoom(from: nil)
    var room = root
    
    for _ in 0..<20 {
      let edgesToTry = Rectangle.Edge.allCases.shuffled()
      var nextRoom: Room?
      for edge in edgesToTry {
        var roomIntersectsAnother = false
        let maybeNextRoom = generateRoom(from: (room: room, edge: edge))
        for room in root.allRooms {
          if room.frame.intersects(maybeNextRoom.frame) {
            roomIntersectsAnother = true
            break
          }
        }
        if !roomIntersectsAnother {
          nextRoom = maybeNextRoom
          break
        } else if edgesToTry[edgesToTry.count - 1] == edge {
          // no more edges to try
          nextRoom = nil
        }
      }
      guard let nextRoom = nextRoom else {
        break
      }
      room.next = nextRoom
      room = nextRoom
    }
    appartment.rooms = root.allRooms
        
    let allRooms = root.allRooms
    for room in allRooms {
      for another in allRooms {
        if room === another {
          continue
        }
        if let (edge, line) = commonEdgeBetween(room.frame, another.frame) {
          commonWalls.append(line)
          room.commonEdges.insert(edge)
        }
      }
    }
    
    let allEdges = Set(Rectangle.Edge.allCases)
    for room in allRooms {
      let notAdjescentEdges = allEdges.subtracting(room.commonEdges)
      if let edge = notAdjescentEdges.randomElement() {
        let wall = room.frame.line(at: edge)
        let doorPosition = lerp(start: wall.a, stop: wall.b, amount: random())
        appartment.doors.append(Door(room1: room,
                                     position: doorPosition,
                                     kind: Door.Kind.allCases.randomElement()!,
                                     edge: edge))
      }
    }
  }
  
  func commonEdgeBetween(_ a: Rectangle, _ b: Rectangle) -> (Rectangle.Edge, Line)? {
    let pairings: [(a: Rectangle.Edge, b: Rectangle.Edge)] = [
      (.maxX, .minX),
      (.minX, .maxX),
      (.maxY, .minY),
      (.minY, .maxY)
    ]
    for pairing in pairings {
      if let i = a.line(at: pairing.a).intersection(with: b.line(at: pairing.b)) {
        switch i {
        case .point:
          // we are only interested in segments
          continue
        case let .segment(line):
          return (pairing.a, line)
        }
      }
    }
    return nil
  }
  
  let colors: [Color] = [
    .red, .yellow, .green, .purple, .grey
  ]
  
  override func draw() {
    background(.white)
    
    let rect = appartment.frame
    translate(by: Point(x: (width - rect.width) / 2 - rect.x,
                        y: (height - rect.height)/2 - rect.y))
    strokeJoin(.round)
    strokeWeight(4)
    stroke(with: .black)
    var _current = appartment.rooms.first
    while let current = _current {
      // do my stuff
      rectangle(current.frame)
      _current = current.next
    }

    strokeJoin(.miter)
    strokeWeight(4)
    for (idx, wall) in commonWalls.enumerated() {
      stroke(with: colors[idx % colors.count])
      line(Line(a: lerp(start: wall.a, stop: wall.b, amount: 0.2),
                b: lerp(start: wall.b, stop: wall.a, amount: 0.2)))
    }
    
    stroke(with: .black)
    for door in appartment.doors {
      let wall = appartment.frame.line(at: door.edge)
      
//      switch door.kind {
//      case .biFold:
//        beginShape()
//        let t = Triangle.equilateral(center: door.position, radius: 5)
//        vertex(t.a)
//        vertex(t.b)
//        vertex(t.c)
//        endShape(.close)
//      case .single:
//        arc(Arc(center: door.position, radius: 5, start: 0, stop: .pi/4))
//      case .double:
//        let s1 = (door.position - wall.a).normalize() * 5
//        let s2 = (door.position - wall.b).normalize() * 5
//        circle(center: s1, radius: 5)
//        circle(center: s2, radius: 5)
//      case .revolving:
        circle(center: door.position, radius: 4)
//      }
      
    }
  }
}
