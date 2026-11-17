accessing
holdsTheClassesOf: aDumpedMemory

	"Whether this copy has that one's classes where that one had them: the same mapping, or that
	one grown, the special objects array unmoved, and the class table saying the same class at
	every index (#163): a collection that moved one, or a class made or redefined, changes an entry."

	^ raw mappingStart = aDumpedMemory raw mappingStart and: [
		  raw mappingLimit >= aDumpedMemory raw mappingLimit and: [
			  raw specialObjectsOop = aDumpedMemory raw specialObjectsOop and: [
				  self classTablePages = aDumpedMemory classTablePages and: [
					  self classTableContents = aDumpedMemory classTableContents ] ] ] ]
