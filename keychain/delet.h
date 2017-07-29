
extern void deleteKeychainObjectsForSecClass(CFTypeRef kSecClassType);
extern BOOL deleteKeychainObjectsForSecClassWithGroup(CFTypeRef kSecClassType, NSString * group);
extern BOOL deleteKeychainObjectsForGroup(NSString * group);
extern void deleteAllKeychainObjects();
