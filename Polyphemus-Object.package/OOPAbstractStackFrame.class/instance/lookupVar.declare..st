context protocol
lookupVar: aName declare: aBoolean

	"The source pane resolves names through the activation, and asks with this selector.
	Nothing is ever declared into an image being read: it is a file, and we only read it."

	^ self lookupVar: aName
