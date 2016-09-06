
import Foundation

final public class ArrayDataSource<Object>: DataSource<Object> {
    
    private let resolver: (Void -> [[Object]])?
    
    // MARK: - Init
    
    public init(resolver: Void -> [[Object]]) {
        self.resolver = resolver
    }
    
    convenience public init(objects: [Object]) {
        self.init {
            return [objects]
        }
    }
    
    override public init() {
        resolver = nil
    }
    
    // MARK: - Batch Update

    private var updating: Bool = false

    public func beginUpdate() {
        precondition(updating == false)
        updating = true

        send(.WillBeginUpdate)
    }

    public func endUpdate() {
        precondition(updating == true)
        updating = false

        send(.DidEndUpdate)
    }

    public func apply(silently: Bool = false, @noescape changes: Void -> Void) {
        if silently {
            disableEvents()
            
            defer {
                enableEvents()
            }
        }
        
        if updating {
            changes()
        } else {
            beginUpdate()
            changes()
            endUpdate()
        }
    }

    // MARK: - Invalidation

    private var invalidated: Bool = true
    
    override public func invalidate() {
        invalidated = true
        
        send(.Invalidate)
    }

    override public func reload() {
        let objects: [[Object]] = resolver?() ?? []
        reload(objects)
    }
    
    private func reload(objects: [[Object]]) {
        _sections = objects.map { return ArraySection(objects: $0) }
        invalidated = false
        
        send(.Reload)
    }

    // MARK: - Access
    
    private var _sections: [ArraySection<Object>] = []
    private var sections: [ArraySection<Object>] {
        get {
            if invalidated {
                reload()
            }
            
            return _sections
        }
        
        set {
            _sections = newValue
        }
    }
    
    override public var sectionsCount: Int {
        return sections.count
    }

    override public func numberOfObjectsInSection(section: Int) -> Int {
        return sections[section].count
    }
    
    override public func objectAtIndexPath(indexPath: NSIndexPath) -> Object {
        return sections[indexPath.section].objectAtIndex(indexPath.item)
    }
    
    // MARK: - Mutation:Objects
    
    public func appendObject(object: Object, toSection sectionIndex: Int) {
        let insertionIndex = sections[sectionIndex].objects.endIndex
        insertObject(object, atIndex: insertionIndex, toSection: sectionIndex)
    }
    
    public func appendObject(object: Object) {
        if sections.isEmpty {
            appendSection([object])
        } else {
            appendObject(object, toSection: sections.endIndex - 1)
        }
    }
    
    public func insertObject(object: Object, atIndex index: Int, toSection sectionIndex: Int) {
        apply {
            let section = sections[sectionIndex]
            section.insert(object, atIndex: index)
            
            let change = ObjectChange(type: .Insert, target: NSIndexPath(forItem: index, inSection: sectionIndex))
            send(.ObjectUpdate(change))
        }
    }
    
    public func removeObjectAtIndex(index: Int, inSection sectionIndex: Int) {
        apply {
            let section = sections[sectionIndex]
            section.removeAtIndex(index)
            
            let change = ObjectChange(type: .Delete, source: NSIndexPath(forItem: index, inSection: sectionIndex))
            send(.ObjectUpdate(change))
        }
    }
    
    public func removeObjectAtIndexPath(indexPath: NSIndexPath) {
        removeObjectAtIndex(indexPath.item, inSection: indexPath.section)
    }
    
    public func replaceObjectAtIndexPath(indexPath: NSIndexPath, withObject object: Object) {
        apply {
            let section = sections[indexPath.section]
            section[indexPath.item] = object
            
            let change = ObjectChange(type: .Update, source: indexPath)
            send(.ObjectUpdate(change))
        }
    }
    
    public func moveObjectAtIndexPath(indexPath: NSIndexPath, to toIndexPath: NSIndexPath) {
        apply {
            let sourceSection = sections[indexPath.section]
            let targetSection = sections[toIndexPath.section]

            let object = sourceSection.objects[indexPath.item]
            sourceSection.removeAtIndex(indexPath.item)
            targetSection.insert(object, atIndex: toIndexPath.item)
            
            let change = ObjectChange(type: .Move, source: indexPath, target: toIndexPath)
            send(.ObjectUpdate(change))
        }
    }
    
    // MARK: - Mutation:Sections
    
    public func appendSection(section: [Object]) {
        insertSection(section, atIndex: sections.endIndex)
    }
    
    public func insertSection(section: [Object], atIndex index: Int) {
        apply {
            sections.insert(ArraySection(objects: section), atIndex: index)

            let change = SectionChange(type: .Insert, indexes: NSIndexSet(index: index))
            send(.SectionUpdate(change))
        }
    }
    
    public func removeSectionAtIndex(index: Int) {
        apply {
            sections.removeAtIndex(index)
            
            let change = SectionChange(type: .Delete, indexes: NSIndexSet(index: index))
            send(.SectionUpdate(change))
        }
    }
    
    public func setObjects(objects: [Object]) {
        reload([objects])
    }
    
    // MARK: - Search
    
    public func indexPathOf(predicate: Object -> Bool) -> NSIndexPath? {
        for (sectionIndex, section) in sections.enumerate() {
            for (objectIndex, object) in section.objects.enumerate() {
                if predicate(object) {
                    return NSIndexPath(forItem: objectIndex, inSection: sectionIndex)
                }
            }
        }
        
        return nil
    }
}

extension ArrayDataSource where Object: Equatable {
 
    public func removeObject(object: Object) {
        if let indexPath = indexPathOf(object) {
            removeObjectAtIndexPath(indexPath)
        }
    }
    
    /**
     Complexity O(n)
     */
    public func indexPathOf(object: Object) -> NSIndexPath? {
        for index in 0..<sectionsCount {
            if let objectIndex = sections[index].indexOf(object) {
                return NSIndexPath(forItem: objectIndex, inSection: index)
            }
        }
        
        return nil
    }
}