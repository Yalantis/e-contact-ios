
import Foundation

public protocol ObjectMappable {
    
    var cellIdentifier: String { get }
    
    func supportsObject(object: Any) -> Bool
    
    func mapObject(object: Any, toCell cell: Any, atIndexPath: NSIndexPath)
}