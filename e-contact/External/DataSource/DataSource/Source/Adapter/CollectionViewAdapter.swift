
import Foundation
import UIKit
import Observer

/**
 Utility class needed for conformation with optional part of the `UICollectionViewDataSource` and `UICollectionViewDelegate`.
 Use `CollectionViewAdapter` instead.
*/
public class _CollectionViewAdapter: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    override private init() {}
    
    public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 0
    }
    
    public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        abort()
    }
    
    public func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    public func collectionView(collectionView: UICollectionView, shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // no-op
    }
    
    public func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        // no-op
    }
}

public class CollectionViewAdapter<Object>: _CollectionViewAdapter {
    
    // MARK: - Init

    deinit {
        disposable?.dispose()
    }
    
    public override init() {}
    
    // MARK: - DataSource

    private var disposable: Disposable?
    
    public var dataSource: DataSource<Object>! {
        didSet {
            disposable?.dispose()
            disposable = dataSource?.observe { [unowned self] event in
                self.handleEvent(event)
            }
        }
    }
    
    // MARK: - CollectionView 
    
    public var collectionView: UICollectionView! {
        didSet {
            oldValue?.dataSource = nil
            oldValue?.delegate = nil
            
            collectionView?.dataSource = self
            collectionView?.delegate = self
        }
    }
    
    // MARK: - Reloading
    
    public func reload(animated: Bool = false) {
        if animated {
            let range = NSMakeRange(0, collectionView.numberOfSections())
            collectionView.reloadSections(NSIndexSet(indexesInRange: range))
        } else {
            collectionView.reloadData()
        }
    }
    
    // MARK: - Mapping
  
    private var registeredMappers: [ObjectMappable] = []
    
    public func registerMapper(mapper: ObjectMappable) {
        registeredMappers.append(mapper)
    }
    
    private func mapperForObject(object: Object) -> ObjectMappable? {
        if let index = registeredMappers.indexOf({ $0.supportsObject(object) }) {
            return registeredMappers[index]
        }
        
        return nil
    }
    
    // MARK: - Event Handling
    
    private var pendingEvents: [Event] = []
    private var collectUpdateEvents = false
    
    private func handleEvent(event: Event) {
        switch event {
        case .Invalidate:
            // no-op
            break
            
        case .Reload:
            collectionView.reloadData()
          
        case .WillBeginUpdate:
            collectUpdateEvents = true
            
        case .DidEndUpdate:
            collectUpdateEvents = false
            applyEvents(pendingEvents)
            pendingEvents.removeAll()
            
        case .ObjectUpdate(let change):
            if collectUpdateEvents {
                pendingEvents.append(event)
            } else {
                applyObjectChange(change)
            }

        case .SectionUpdate(let change):
            if collectUpdateEvents {
                pendingEvents.append(event)
            } else {
                applySectionChange(change)
            }
        }
    }
    
    private func applyEvents(events: [Event]) {
        for event in events {
            switch event {
            case .ObjectUpdate(let change):
                applyObjectChange(change)
                
            case .SectionUpdate(let change):
                applySectionChange(change)
                
            default:
                break
            }
        }
    }
    
    private func applyObjectChange(change: ObjectChange) {
        switch change.type {
        case .Insert:
            collectionView.insertItemsAtIndexPaths([change.target])
            
        case .Delete:
            collectionView.deleteItemsAtIndexPaths([change.source])
            
        case .Move:
            collectionView.moveItemAtIndexPath(change.source, toIndexPath: change.target)
            
        case .Update:
            collectionView.reloadItemsAtIndexPaths([change.source])
        }
    }
    
    private func applySectionChange(change: SectionChange) {
        switch change.type {
        case .Insert:
            collectionView.insertSections(change.indexes)
    
        case .Delete:
            collectionView.deleteSections(change.indexes)
            
        case .Move:
            abort()
            
        case .Update:
            collectionView.reloadSections(change.indexes)
        }
    }
    
    // MARK: - UICollectionViewDataSource

    override public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        guard let dataSource = dataSource else {
            return 0
        }
        return dataSource.sectionsCount
    }
  
    override public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.numberOfObjectsInSection(section)
    }
    
    override public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let object = dataSource.objectAtIndexPath(indexPath)
        guard let mapper = mapperForObject(object) else {
            fatalError("You have to provide mapper that supports \(object.dynamicType)")
        }
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(mapper.cellIdentifier, forIndexPath: indexPath)
        mapper.mapObject(object, toCell: cell, atIndexPath: indexPath)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    public typealias Confirmation = (Object, NSIndexPath) -> Bool
    
    public var shouldSelect: Confirmation?

    override public func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        let object = dataSource.objectAtIndexPath(indexPath)
        return shouldSelect?(object, indexPath) ?? true
    }
    
    public var shouldDeselect: Confirmation?
    
    override public func collectionView(collectionView: UICollectionView, shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        let object = dataSource.objectAtIndexPath(indexPath)
        return shouldDeselect?(object, indexPath) ?? true
    }
    
    public typealias Selection = (Object, NSIndexPath) -> Void
    
    public var didSelect: Selection?
    
    override public func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let object = dataSource.objectAtIndexPath(indexPath)
        didSelect?(object, indexPath)
    }
    
    public var didDeselect: Selection?
    
    override public func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let object = dataSource.objectAtIndexPath(indexPath)
        didDeselect?(object, indexPath)
    }
    
    // MARK: - UIScrollViewDelegate
    
    public var didScroll: (UIScrollView -> Void)?
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        didScroll?(scrollView)
    }
}