testing
isSupportedHere

	"Linux only. macOS gates observation through code signing and entitlements and Windows
	through SeDebugPrivilege, and neither is this call."

	^ '/proc/self/maps' asFileReference exists
