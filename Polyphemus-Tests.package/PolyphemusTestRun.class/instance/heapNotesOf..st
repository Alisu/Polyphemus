accessing
heapNotesOf: aSelector

	"What was found wrong in the heaps that test read (#141)."

	^ heapNotes at: aSelector ifAbsent: [ #(  ) ]
