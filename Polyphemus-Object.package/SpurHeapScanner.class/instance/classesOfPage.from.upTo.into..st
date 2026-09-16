reading the class table
classesOfPage: aPage from: anAddress upTo: aLimit into: aCollection

	"Every entry of one page is either nil, or a class: an object of fixed fields, inside
	the heap. Anything else there would be handed back as some object's class."

	1 to: self classTablePageSize do: [ :index |
		| entry |
		entry := self slotOf: aPage at: index.
		(entry = anAddress or: [ entry = 0 or: [ entry isNil ] ]) ifFalse: [
			aCollection size < 50 ifTrue: [
				(entry between: anAddress and: aLimit)
					ifFalse: [ aCollection add: #classOutsideTheHeap -> entry ]
					ifTrue: [
						| header |
						header := self headerAt: entry.
						(header notNil and: [ (self formatIn: header) = 1 ]) ifFalse: [
							aCollection add: #classTableHoldsSomethingThatIsNotAClass -> entry ] ] ] ] ]
