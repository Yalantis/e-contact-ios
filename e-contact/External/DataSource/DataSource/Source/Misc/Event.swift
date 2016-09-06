
import Foundation

public enum ChangeType {
    
    case Insert, Delete, Move, Update
}

public struct SectionChange {

    var type: ChangeType
    var indexes: NSIndexSet
}

public struct ObjectChange {
    
    var type: ChangeType
    var source: NSIndexPath!
    var target: NSIndexPath!
    
    public init(type: ChangeType, source: NSIndexPath) {
        self.type = type
        self.source = source
    }
    
    public init(type: ChangeType, target: NSIndexPath) {
        self.type = type
        self.target = target
    }
    
    public init(type: ChangeType, source: NSIndexPath, target: NSIndexPath) {
        self.type = type
        self.source = source
        self.target = target
    }
}

public enum Event {

    case Invalidate, Reload, WillBeginUpdate, DidEndUpdate
    
    case SectionUpdate(SectionChange)
    case ObjectUpdate(ObjectChange)
}