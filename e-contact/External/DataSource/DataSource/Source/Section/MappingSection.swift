
import Foundation

final class MappingSection<RawObject, Object> {
    
    let origin: DataSource<RawObject>
    let map: RawObject -> Object
    
    var originIndex: Int
    
    private var objects: [Object?] = []
    
    // MARK: - Init
    
    init(origin: DataSource<RawObject>, originIndex: Int, map: RawObject -> Object) {
        self.origin = origin
        self.originIndex = originIndex
        self.map = map
        
        objects = Array(count: origin.numberOfObjectsInSection(originIndex), repeatedValue: nil)
    }
    
    // MARK: - Access
    
    var count: Int {
        return objects.count
    }
    
    func objectAtIndex(index: Int) -> Object {
        if let object = objects[index] {
            return object
        }
        
        let object = map(origin.objectAtIndexPath(NSIndexPath(forItem: index, inSection: originIndex)))
        objects[index] = object
        
        return object
    }

    // MARK: - Mutation
    
    func insert(object: Object?, atIndex index: Int) {
        objects.insert(object, atIndex: index)
    }

    func removeObjectAtIndex(index: Int) -> Object? {
        return objects.removeAtIndex(index)
    }
    
    func invalidateObjectAtIndex(index: Int) {
        objects[index] = nil
    }
    
    func invalidateObjects() {
        objects = Array(count: origin.numberOfObjectsInSection(originIndex), repeatedValue: nil)
    }
    
}
