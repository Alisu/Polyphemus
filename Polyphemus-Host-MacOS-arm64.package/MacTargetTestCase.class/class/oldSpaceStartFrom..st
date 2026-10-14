helpers
oldSpaceStartFrom: aLibraryPath

	"Where this very VM keeps old space, nil first: its own answer, VM 10 on (getOldSpaceStart)."

	^ self ffiCall: #( uint64 getOldSpaceStart ( ) ) module: aLibraryPath
