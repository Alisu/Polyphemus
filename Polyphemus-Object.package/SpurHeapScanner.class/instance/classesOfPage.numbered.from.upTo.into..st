reading the class table
classesOfPage: aPage numbered: aPageNumber from: anAddress upTo: aLimit into: aCollection

	"Every entry of a page is nil or a class (fixed fields, inside the heap). A bad one is
	reported by its class index -- page number and offset, ten bits each."

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
