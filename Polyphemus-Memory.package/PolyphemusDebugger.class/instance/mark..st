telling
mark: aString

	"Said in front of the title until the debugger closes."

	self session mark: aString.
	self session markTitleOf: self
