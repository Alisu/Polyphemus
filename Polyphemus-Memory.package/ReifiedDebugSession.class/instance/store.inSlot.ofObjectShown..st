editing
store: aValue inSlot: anIndex ofObjectShown: aReifiedObject

	"Set one slot, counting from one as an inspector does, of an object the debugger shows, in
	the image held; the debugger is then shown memory as it is."

	held ifNil: [ ^ self error: 'this image is open for reading only' ].
	held store: aValue inSlot: anIndex ofObjectShown: aReifiedObject.
	self updateContextTo: held context
