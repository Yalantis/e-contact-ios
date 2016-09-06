
import Foundation

final class ObserverInfo<T>: Hashable {
	
	private let observer: T -> Void
	
	private init(_ observer: T -> Void) {
		self.observer = observer
	}
	
	var hashValue: Int { return unsafeAddressOf(self).hashValue }
}

func == <T>(lhs: ObserverInfo<T>, rhs: ObserverInfo<T>) -> Bool {
	return lhs.hashValue == rhs.hashValue
}

public class ObserverSet<T> {
	
	private var lock: OSSpinLock = OS_SPINLOCK_INIT
	private var descriptors: Set<ObserverInfo<T>> = []
	
	public var notificationQueue: dispatch_queue_t?
	
	public init() {}
	
	public func add(observer: T -> Void) -> Disposable {
		let descriptor = ObserverInfo(observer)
		
		OSSpinLockLock(&lock)
		descriptors.insert(descriptor)
		OSSpinLockUnlock(&lock)
		
		let disposable = Disposable { [weak self, weak descriptor] in
			if let _self = self, descriptor = descriptor {
				OSSpinLockLock(&_self.lock)
				_self.descriptors.remove(descriptor)
				OSSpinLockUnlock(&_self.lock)
			}
		}
		
		return disposable
	}
	
	public func send(value: T) {
		OSSpinLockLock(&lock)
		let usedDescriptors = descriptors
		OSSpinLockUnlock(&lock)
		
		if let queue = notificationQueue {
			dispatch_async(queue) {
				for descriptor in usedDescriptors {
					descriptor.observer(value)
				}
			}
		} else {			
			for descriptor in usedDescriptors {
				descriptor.observer(value)
			}
		}
	}
	
	public func disposeAll() {
		OSSpinLockLock(&lock)
		descriptors.removeAll()
		OSSpinLockUnlock(&lock)
	}
}