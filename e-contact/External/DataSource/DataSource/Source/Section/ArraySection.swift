
import Foundation

class ArraySection<Object> {
    
    private var _objects: [Object]
    
    // MARK: - Init
    
    init(objects: [Object]) {
        _objects = objects
    }
    
    // MARK: - Section
    
    var count: Int {
        return _objects.count
    }
    
    func objectAtIndex(index: Int) -> Object {
        return _objects[index]
    }
    
    var objects: [Object] {
        return _objects
    }
    
    subscript(index: Int) -> Object {
        get {
            return _objects[index]
        }
        
        set {
            _objects[index] = newValue
        }
    }
    
    // MARK: - Mutation
    
    func insert(object: Object, atIndex index: Int) {
        _objects.insert(object, atIndex: index)
    }
    
    func removeAtIndex(index: Int) {
        _objects.removeAtIndex(index)
    }
}

extension ArraySection where Object: Equatable {
    
    func indexOf(object: Object) -> Int? {
        return _objects.indexOf(object)
    }
}