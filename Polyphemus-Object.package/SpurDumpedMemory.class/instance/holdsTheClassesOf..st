accessing
holdsTheClassesOf: aDumpedMemory

	"Whether this copy has that one's classes where that one had them: same mapping, and the
	class table's pages and the special objects array unmoved -- which a compacting GC moves."

	^ raw mappingStart = aDumpedMemory raw mappingStart and: [
		  raw mappingLimit = aDumpedMemory raw mappingLimit and: [
			  raw specialObjectsOop = aDumpedMemory raw specialObjectsOop and: [
				  self classTablePages = aDumpedMemory classTablePages ] ] ]
