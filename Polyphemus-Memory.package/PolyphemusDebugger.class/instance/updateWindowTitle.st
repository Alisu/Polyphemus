updating
updateWindowTitle

	"Pharo's title for the frame, with the session's marks in front."

	super updateWindowTitle.
	self session markTitleOf: self
