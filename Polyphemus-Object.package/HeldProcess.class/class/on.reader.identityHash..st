instance creation
on: aChannel reader: aProcessMemory identityHash: anInteger

	"The process with that identity hash, in the image the channel and the reader both reach."

	^ self new setChannel: aChannel reader: aProcessMemory identityHash: anInteger
