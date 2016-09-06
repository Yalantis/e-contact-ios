import Foundation
import UIKit
import Observer

/**
 Utility class needed for conformation with optional part of the `UITableViewDataSource` and `UITableViewDelegate`.
 Use `CollectionViewAdapter` instead.
 */
public class _TableViewAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    override private init() {}
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        abort()
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // no-op
    }
    
    public func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        // no-op
    }
}

public class TableViewAdapter<Object>: _TableViewAdapter {
    
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
    
    public var tableView: UITableView! {
        didSet {
            oldValue?.dataSource = nil
            oldValue?.delegate = nil
            
            tableView?.dataSource = self
            tableView?.delegate = self
        }
    }
    
    // MARK: - Reloading
    
    public func reload(animated: Bool = false) {
        if animated {
            let range = NSMakeRange(0, tableView.numberOfSections)
            tableView.reloadSections(NSIndexSet(indexesInRange: range), withRowAnimation: .Automatic)
        } else {
            tableView.reloadData()
        }
    }
    
    public func reloadIndexPath(indexPath: NSIndexPath, animated: Bool) {
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: animated ? .Automatic : .None)
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
            tableView.reloadData()
            
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
            tableView.insertRowsAtIndexPaths([change.target], withRowAnimation: .Automatic)
            
        case .Delete:
            tableView.deleteRowsAtIndexPaths([change.source], withRowAnimation: .Automatic)
            
        case .Move:
            tableView.moveRowAtIndexPath(change.source, toIndexPath: change.target)
            
        case .Update:
            tableView.reloadRowsAtIndexPaths([change.source], withRowAnimation: .Automatic)
        }
    }
    
    private func applySectionChange(change: SectionChange) {
        switch change.type {
        case .Insert:
            tableView.insertSections(change.indexes, withRowAnimation: .Automatic)
            
        case .Delete:
            tableView.deleteSections(change.indexes, withRowAnimation: .Automatic)
            
        case .Move:
            abort()
            
        case .Update:
            tableView.reloadSections(change.indexes, withRowAnimation: .Automatic)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    public override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        guard let dataSource = dataSource else {
            return 0
        }
        return dataSource.sectionsCount
    }
    
    public override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.numberOfObjectsInSection(section)
    }

    public override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let object = dataSource.objectAtIndexPath(indexPath)
        guard let mapper = mapperForObject(object) else {
            fatalError("You have to provide mapper that supports \(object.dynamicType)")
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(mapper.cellIdentifier, forIndexPath: indexPath)
        mapper.mapObject(object, toCell: cell, atIndexPath: indexPath)
        
        return cell
    }

    // MARK: - UITableViewDelegate
    
    public typealias Selection = (Object, NSIndexPath) -> Void
    
    public var didSelect: Selection?
    
    public override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let object = dataSource.objectAtIndexPath(indexPath)
        didSelect?(object, indexPath)
    }
    
    public var didDeselect: Selection?
    
    public override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let object = dataSource.objectAtIndexPath(indexPath)
        didDeselect?(object, indexPath)
    }
    
    // MARK: - UIScrollViewDelegate
    
    public var didScroll: ((UIScrollView) -> Void)?
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        didScroll?(scrollView)
    }
}