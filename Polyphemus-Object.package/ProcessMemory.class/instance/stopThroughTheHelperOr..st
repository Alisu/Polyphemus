holding it still
stopThroughTheHelperOr: aBlock

	"Through bin/polyphemus-stop where it builds: undone if this image dies, one stop at a time per
	process (#137, #117). Else aBlock, this host's own stop. Answers whether it stopped."

	| helper |
	self usesTheStopHelper ifFalse: [ ^ aBlock value ].
	helper := StopHelper on: pid in: StopHelper directory bound: self stopBound.
	helper start ifFalse: [ ^ false ].
	stopHelper := helper.
	^ true
