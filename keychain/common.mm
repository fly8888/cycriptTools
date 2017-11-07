void printToStdOut(NSString *format, ...) {
    va_list args;
    va_start(args, format);
    NSString *formattedString = [[NSString alloc] initWithFormat: format arguments: args];
    va_end(args);
    [[NSFileHandle fileHandleWithStandardOutput] writeData: [formattedString dataUsingEncoding: NSNEXTSTEPStringEncoding]];
}

void printUsage()
{
    printToStdOut(@"Usage: keychain_dumper [-e]|[-h]|[-agnick]\n");
	//delete
	printToStdOut(@"-r -a : Delete All Keychain Items(Generic Passwords, Internet Passwords, Identities, Certificates, and Keys)\n");
	printToStdOut(@"-r -g [group]: Delete This Group Keychain Items\n");
	//list
	printToStdOut(@"-l -g : Show All Groups In Keychain\n");
	printToStdOut(@"-l -a : Show All Items In Keychain\n");
	//ghost || recover
	printToStdOut(@"-ghost -p [path] -g [group] : Ghost Keychain To Path\n");
	printToStdOut(@"-recover -p [path] -g [group] : Recover Keychain Item In Plist\n");


    /*
	printToStdOut(@"<no flags>: Dump Password Keychain Items (Generic Password, Internet Passwords)\n");
	printToStdOut(@"-a: Dump All Keychain Items (Generic Passwords, Internet Passwords, Identities, Certificates, and Keys)\n");
	printToStdOut(@"-e: Dump Entitlements\n");
	printToStdOut(@"-g: Dump Generic Passwords\n");
	printToStdOut(@"-n: Dump Internet Passwords\n");
	printToStdOut(@"-i: Dump Identities\n");
	printToStdOut(@"-c: Dump Certificates\n");
	printToStdOut(@"-k: Dump Keys\n");
    */
}


void printGenericPassword(NSDictionary *passwordItem) {
	printToStdOut(@"Generic Password\n");
	printToStdOut(@"----------------\n");
	printToStdOut(@"Service: %@\n", [passwordItem objectForKey:(id)kSecAttrService]);
	printToStdOut(@"Account: %@\n", [passwordItem objectForKey:(id)kSecAttrAccount]);
	printToStdOut(@"Entitlement Group: %@\n", [passwordItem objectForKey:(id)kSecAttrAccessGroup]);
	printToStdOut(@"Label: %@\n", [passwordItem objectForKey:(id)kSecAttrLabel]);
	printToStdOut(@"Generic Field: %@\n", [[passwordItem objectForKey:(id)kSecAttrGeneric] description]);
	NSData* passwordData = [passwordItem objectForKey:(id)kSecValueData];
	printToStdOut(@"Keychain Data: %@\n\n", [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding]);
}

void printInternetPassword(NSDictionary *passwordItem) {
	printToStdOut(@"Internet Password\n");
	printToStdOut(@"-----------------\n");
	printToStdOut(@"Server: %@\n", [passwordItem objectForKey:(id)kSecAttrServer]);
	printToStdOut(@"Account: %@\n", [passwordItem objectForKey:(id)kSecAttrAccount]);
	printToStdOut(@"Entitlement Group: %@\n", [passwordItem objectForKey:(id)kSecAttrAccessGroup]);
	printToStdOut(@"Label: %@\n", [passwordItem objectForKey:(id)kSecAttrLabel]);
	NSData* passwordData = [passwordItem objectForKey:(id)kSecValueData];
	printToStdOut(@"Keychain Data: %@\n\n", [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding]);
}

void printCertificate(NSDictionary *certificateItem) {
	SecCertificateRef certificate = (__bridge SecCertificateRef)[certificateItem objectForKey:(id)kSecValueRef];

	CFStringRef summary;
	summary = SecCertificateCopySubjectSummary(certificate);
	printToStdOut(@"Certificate\n");
	printToStdOut(@"-----------\n");
	printToStdOut(@"Summary: %@\n", (__bridge NSString *)summary);
	printToStdOut(@"Entitlement Group: %@\n", [certificateItem objectForKey:(id)kSecAttrAccessGroup]);
	printToStdOut(@"Label: %@\n", [certificateItem objectForKey:(id)kSecAttrLabel]);
	printToStdOut(@"Serial Number: %@\n", [certificateItem objectForKey:(id)kSecAttrSerialNumber]);
	printToStdOut(@"Subject Key ID: %@\n", [certificateItem objectForKey:(id)kSecAttrSubjectKeyID]);
	printToStdOut(@"Subject Key Hash: %@\n\n", [certificateItem objectForKey:(id)kSecAttrPublicKeyHash]);
	
}

void printKey(NSDictionary *keyItem) {
	NSString * keyClass = @"Unknown";
	CFTypeRef _keyClass = (__bridge CFTypeRef)[keyItem objectForKey:(id)kSecAttrKeyClass];

	if ([[(__bridge id)_keyClass description] isEqual:(id)kSecAttrKeyClassPublic]) {
		keyClass = @"Public";
	}
	else if ([[(__bridge id)_keyClass description] isEqual:(id)kSecAttrKeyClassPrivate]) {
		keyClass = @"Private";
	}
	else if ([[(__bridge id)_keyClass description] isEqual:(id)kSecAttrKeyClassSymmetric]) {
		keyClass = @"Symmetric";
	}

	printToStdOut(@"Key\n");
	printToStdOut(@"---\n");
	printToStdOut(@"Entitlement Group: %@\n", [keyItem objectForKey:(id)kSecAttrAccessGroup]);
	printToStdOut(@"Label: %@\n", [keyItem objectForKey:(id)kSecAttrLabel]);
	printToStdOut(@"Application Label: %@\n", [keyItem objectForKey:(id)kSecAttrApplicationLabel]);
	printToStdOut(@"Key Class: %@\n", keyClass);
	id secAttrIsPermanent = [keyItem objectForKey:(id)kSecAttrIsPermanent];
	if(secAttrIsPermanent)printToStdOut(@"Permanent Key: %@\n", CFBooleanGetValue((CFBooleanRef)secAttrIsPermanent) == true ? @"True" : @"False");
	printToStdOut(@"Key Size: %@\n", [keyItem objectForKey:(id)kSecAttrKeySizeInBits]);
	printToStdOut(@"Effective Key Size: %@\n", [keyItem objectForKey:(id)kSecAttrEffectiveKeySize]);
	id secAttrCanEncrypt = [keyItem objectForKey:(id)kSecAttrCanEncrypt];
	if(secAttrCanEncrypt)printToStdOut(@"For Encryption: %@\n", CFBooleanGetValue((CFBooleanRef)secAttrCanEncrypt) == true ? @"True" : @"False");
	id secAttrCanDecrypt = [keyItem objectForKey:(id)kSecAttrCanDecrypt];
	if(secAttrCanDecrypt)printToStdOut(@"For Decryption: %@\n", CFBooleanGetValue((CFBooleanRef)secAttrCanDecrypt) == true ? @"True" : @"False");
	id secAttrCanDerive = [keyItem objectForKey:(id)kSecAttrCanDerive];
	if(secAttrCanDerive)printToStdOut(@"For Key Derivation: %@\n", CFBooleanGetValue((CFBooleanRef)secAttrCanDerive) == true ? @"True" : @"False");
	id secAttrCanSign = [keyItem objectForKey:(id)kSecAttrCanSign];
	if(secAttrCanSign)printToStdOut(@"For Signatures: %@\n", CFBooleanGetValue((CFBooleanRef)secAttrCanSign) == true ? @"True" : @"False");
	id secAttrCanVerify = [keyItem objectForKey:(id)kSecAttrCanVerify];
	if(secAttrCanVerify)printToStdOut(@"For Signature Verification: %@\n", CFBooleanGetValue((CFBooleanRef)secAttrCanVerify) == true ? @"True" : @"False");
	id secAttrCanWrap = [keyItem objectForKey:(id)kSecAttrCanWrap];
	if(secAttrCanWrap)printToStdOut(@"For Key Wrapping: %@\n", CFBooleanGetValue((CFBooleanRef)secAttrCanWrap) == true ? @"True" : @"False");
	id secAttrCanUnwrap = [keyItem objectForKey:(id)kSecAttrCanUnwrap];
	if(secAttrCanUnwrap)printToStdOut(@"For Key Unwrapping: %@\n\n", CFBooleanGetValue((CFBooleanRef)secAttrCanUnwrap) == true ? @"True" : @"False");

}


void printIdentity(NSDictionary *identityItem) {
	SecIdentityRef identity = (__bridge SecIdentityRef)[identityItem objectForKey:(id)kSecValueRef];
	SecCertificateRef certificate;

	SecIdentityCopyCertificate(identity, &certificate);
	NSMutableDictionary *identityItemWithCertificate = [identityItem mutableCopy];
	[identityItemWithCertificate setObject:(__bridge id)certificate forKey:(id)kSecValueRef];
	printToStdOut(@"Identity\n");
	printToStdOut(@"--------\n");
	printCertificate(identityItemWithCertificate);
	printKey(identityItemWithCertificate);
}



NSString * getEmptyKeychainItemString(CFTypeRef kSecClassType) {
	if (kSecClassType == kSecClassGenericPassword) {
		return @"No Generic Password Keychain items found.\n";
	}
	else if (kSecClassType == kSecClassInternetPassword) {
		return @"No Internet Password Keychain items found.\n";	
	} 
	else if (kSecClassType == kSecClassIdentity) {
		return @"No Identity Keychain items found.\n";
	}
	else if (kSecClassType == kSecClassCertificate) {
		return @"No Certificate Keychain items found.\n";	
	}
	else if (kSecClassType == kSecClassKey) {
		return @"No Key Keychain items found.\n";	
	}
	else {
		return @"Unknown Security Class\n";
	}
}
void printResultsForSecClass(NSArray *keychainItems, CFTypeRef kSecClassType) {
	if (keychainItems == nil) {
		printToStdOut(getEmptyKeychainItemString(kSecClassType));
		return;
	}
	for (NSDictionary * keychainItem in keychainItems) {
		if (kSecClassType == kSecClassGenericPassword) {
			printGenericPassword(keychainItem);
		}	
		else if (kSecClassType == kSecClassInternetPassword) {
			printInternetPassword(keychainItem);
		}
		else if (kSecClassType == kSecClassIdentity) {
			printIdentity(keychainItem);
		}
		else if (kSecClassType == kSecClassCertificate) {
			printCertificate(keychainItem);
		}
		else if (kSecClassType == kSecClassKey) {
			printKey(keychainItem);
		}
	}
	return;
}