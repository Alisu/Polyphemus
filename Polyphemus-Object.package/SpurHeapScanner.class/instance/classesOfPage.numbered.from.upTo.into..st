reading the class table
classesOfPage: aPage numbered: aPageNumber from: anAddress upTo: aLimit into: aCollection

	"Every entry of one page is either nil, or a class: an object of fixed fields, inside
	the heap. Anything else would be handed back as some object's class.

	A class index is the page number and the offset within it, ten bits each, so a bad entry
	is reported by the index it answers to rather than by where it sits."

	1 to: self classTablePageSize do: [ :offset |
		| entry |
		entry := self slotOf: aPage at: offset.
		(entry = anAddress or: [ entry = 0 or: [ entry isNil ] ]) ifFalse: [
			aCollection size < 50 ifTrue: [
				| index header |
				index := aPageNumber * self classTablePageSize + offset - 1.
				(entry between: anAddress and: aLimit)
					ifFalse: [ aCollection add: #classOutsideTheHeap -> index ]
					ifTrue: [
						header := self headerAt: entry.
						(header notNil and: [ (self formatIn: header) = 1 ]) ifFalse: [
							aCollection add: #classTableHoldsSomethingThatIsNotAClass -> index ] ] ] ] ]
