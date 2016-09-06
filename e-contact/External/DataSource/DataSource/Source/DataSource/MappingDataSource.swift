
import Foundation
import Observer

final public class MappingDataSource<RawObject, Object>: DataSource<Object> {
    
    public typealias Map = RawObject -> Object
    private let map: Map
    
    private var disposable: Disposable?
    public let origin: DataSource<RawObject>
    
    // MARK: - Init
    
    deinit {
        disposable?.dispose()
    }
    
    public init(origin: DataSource<RawObject>, map: Map) {
        self.origin = origin
        self.map = map
        
        super.init()
        
        disposable = origin.observe { [unowned self] event in
            self.handleEvent(event)
        }
    }
    
    // MARK: - Sections
    
    private var _sections: [MappingSection<RawObject, Object>] = []
    private var sections: [MappingSection<RawObject, Object>] {
        get {
            if invalidated {
                reload()
            } else {
                reindexSectionsIfNeeded()
            }
            
            return _sections
        }
        
        set {
            _sections = sections
        }
    }
    
    // MARK: - Access

    override public var sectionsCount: Int {
        return sections.count
    }
    
    override public func numberOfObjectsInSection(section: Int) -> Int {
        return sections[section].count
    }
    
    override public func objectAtIndexPath(indexPath: NSIndexPath) -> Object {
        return sections[indexPath.section].objectAtIndex(indexPath.item)
    }
    
    // MARK: - Reload
    
    private var invalidated = true
    override public func invalidate() {
        invalidated = true
        
        send(.Invalidate)
    }
    
    // to prevent double reloading when MappingDataSource cause Origin to reload
    private var reloading = true
    
    override public func reload() {
        reloading = true
        
        _sections = (0..<origin.sectionsCount).map { return MappingSection(origin: self.origin, originIndex: $0, map: self.map) }

        invalidated = false
        reloading = false
        sectionsIndexInvalid = false

        send(.Reload)
    }
    
    public func reloadObjectAtIndexPath(indexPath: NSIndexPath) {
        let section = sections[indexPath.section]
        section.invalidateObjectAtIndex(indexPath.item)
        
        let change = ObjectChange(type: .Update, source: indexPath)
        send(.ObjectUpdate(change))
    }
    
    private var sectionsIndexInvalid = true
    
    private func setNeedsSectionReindex() {
        sectionsIndexInvalid = true
    }
    
    private func reindexSectionsIfNeeded() {
        if sectionsIndexInvalid {
            for (index, section) in _sections.enumerate() {
                section.originIndex = index
            }
        }
        
        sectionsIndexInvalid = false
    }
    
    // MARK: - Events Handling
    
    private func handleEvent(event: Event) {
        switch event {
        case .Invalidate:
            invalidate()
            
        case .Reload where reloading:
            break
            
        case .Reload:
            reload()
            
        case .SectionUpdate(let change):
            setNeedsSectionReindex()
            applySectionChange(change)
            
            send(event)
            
        case .ObjectUpdate(let change):
            applyObjectChange(change)
            
            send(event)
            
        case .WillBeginUpdate, .DidEndUpdate:
            send(event)
        }
    }
    
    private func applyObjectChange(change: ObjectChange) {
        switch change.type {
        case .Insert:
            sections[change.target.section].insert(nil, atIndex: change.target.item)
            
        case .Delete:
            sections[change.source.section].removeObjectAtIndex(change.source.item)
            
        case .Move:
            let object = sections[change.source.section].removeObjectAtIndex(change.source.item)
            sections[change.target.section].insert(object, atIndex: change.target.item)
            
        case .Update:
            sections[change.source.section].invalidateObjectAtIndex(change.source.item)
        }
    }
    
    private func applySectionChange(change: SectionChange) {
        switch change.type {
        case .Insert:
            for index in change.indexes {
                sections.insert(MappingSection(origin: origin, originIndex: index, map: map), atIndex: index)
            }
        
        case .Delete:
            for index in change.indexes {
                sections.removeAtIndex(index)
            }
            
        case .Move:
            abort()
            
        case .Update:
            for index in change.indexes {
                sections[index].invalidateObjects()
            }
        }
    }
    
    // MARK: - Search
    
    public func indexPathOf(predicate: Object -> Bool) -> NSIndexPath? {
        for (sectionIndex, section) in sections.enumerate() {
            for objectIndex in 0..<numberOfObjectsInSection(sectionIndex) {
                if predicate(section.objectAtIndex(objectIndex)) {
                    return NSIndexPath(forItem: objectIndex, inSection: sectionIndex)
                }
            }
        }
        
        return nil
    }
}