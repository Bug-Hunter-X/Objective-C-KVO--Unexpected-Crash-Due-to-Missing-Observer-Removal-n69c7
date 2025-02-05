The solution is to ensure that the observer is always removed before the observed object is deallocated.  This typically involves removing the observer in the `dealloc` method of the observer or when the observation is no longer needed.

```objectivec
@interface MyObservedObject : NSObject
@property (nonatomic, strong) NSString *observedProperty;
@end

@implementation MyObservedObject
- (void)dealloc {
    NSLog(@"MyObservedObject deallocated");
}
@end

@interface MyObserver : NSObject
@end

@implementation MyObserver
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    NSLog(@"Observed property changed: %@
", object.observedProperty);
}
- (void)dealloc {
    [self.observedObject removeObserver:self forKeyPath:@"observedProperty"];
}
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        MyObservedObject *observedObject = [[MyObservedObject alloc] init];
        observedObject.observedProperty = @"Initial Value";
        MyObserver *observer = [[MyObserver alloc] init];
        observer.observedObject = observedObject; // Add this line to avoid compiler error
        [observedObject addObserver:observer forKeyPath:@"observedProperty" options:NSKeyValueObservingOptionNew context:NULL];

        observedObject.observedProperty = @"New Value";

        observedObject = nil; // Now the dealloc methods will be called.
    }
    return 0;
}
```

This corrected code adds observer removal in the `dealloc` method of the observer class, guaranteeing that the observer is removed before the observed object is deallocated, thus preventing the crash.