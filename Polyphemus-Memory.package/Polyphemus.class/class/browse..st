tools
browse: aReifiedMemory

	"Every process in the memory, its stack, and the source of each frame."

	^ (SnapshotProcessBrowser on: aReifiedMemory) open
