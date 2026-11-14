running
frame: aFrame withMethod: aMethod

	"aFrame as it reads, but answering aMethod as its home method."

	^ (DefectiveReadDouble of: aFrame) when: #homeMethod answer: [ aMethod ]
