
import Foundation

public final class Disposable {
	
	var _disposed: Bool = false
	public private(set) var disposed: Bool {
		get {
			let value: Bool
			OSSpinLockLock(&lock)
			value = _disposed
			OSSpinLockUnlock(&lock)
			return value
		}
		set {
			OSSpinLockLock(&lock)
			_disposed = newValue
			OSSpinLockUnlock(&lock)
		}
	}
	
	private let action: Void -> Void
	private var lock: OSSpinLock = OS_SPINLOCK_INIT
		
	public init(action: Void -> Void) {
		self.action = action
	}
	
	public init(disposable: Disposable, action: Void -> Void) {
		self.action = {
			disposable.dispose()
			action()
		}
	}
	

	public func dispose() {
		if !disposed {
			disposed = true
			action()
		}
	}
}
