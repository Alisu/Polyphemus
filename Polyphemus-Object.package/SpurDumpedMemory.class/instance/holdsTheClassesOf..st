accessing
holdsTheClassesOf: aDumpedMemory

	"Whether this copy has that one's classes where that one had them: the same mapping, or that
	one grown, the special objects array and the class table's pages unmoved, and every class
	that one's table named still named at its index (#163). A class it gained since is none of them."

	^ raw mappingStart = aDumpedMemory raw mappingStart and: [
		  raw mappingLimit >= aDumpedMemory raw mappingLimit and: [
			  raw specialObjectsOop = aDumpedMemory raw specialObjectsOop and: [
				  self classTablePages = aDumpedMemory classTablePages and: [ self namesEveryClassOf: aDumpedMemory ] ] ] ]
