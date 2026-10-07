tests
testAlmostEverythingHasAPackage

	"A class with no package of its own is rare; a metaclass goes with its class."

	| footprint |
	footprint := self footprint.
	self assert: (footprint bytesOf: '(no package)') < (footprint ownedBytes / 100).
	self assert: footprint lines first bytes >= footprint lines last bytes
