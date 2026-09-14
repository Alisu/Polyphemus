instanciation
newFrom: aCogStackPage for: anAddress on: aPreReifiedMemory

	"Reify the frames of a page that is not the active one. Such a page keeps its
	own saved head frame pointer and stack pointer, so we start from those rather
	than from the interpreter's registers, which describe the active page only."

	^ self
		  newTopFrameFrom: aCogStackPage
		  startingAt: aCogStackPage headFP
		  endingAt: aCogStackPage headSP
		  on: aPreReifiedMemory
