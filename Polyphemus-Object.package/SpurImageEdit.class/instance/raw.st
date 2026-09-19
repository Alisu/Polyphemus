accessing
raw

	"The heap as the file holds it, to find objects in; edits are not in it."

	^ raw ifNil: [ raw := SpurRawHeap on: file ]
