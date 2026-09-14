context protocol
tempNames

	"Every name in scope in this frame, arguments included."

	^ self astScope allTempNames
