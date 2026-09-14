debugger protocol
hasPragmaNamed: aString

	"The debugger asks this to decide whether to hide a frame. Reading pragmas out of
	another image's method is worth doing one day; answering false only means no frame
	is hidden. From the hackDebugger branch."

	^ false
