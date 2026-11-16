tests
testADefectReadingASlotIsNotASlotShownUnreadable

	"#118: a bug of our own reading an object's slot, or saying where its value is, gave a slot
	said unreadable or a value without its address."

	| server process |
	server := PolyphemusMCPServer new.
	process := self process.
	self
		should: [ server slot: 1 of: (self defective: process in: #reifiedSlotAt:) named: 'nextLink' ]
		raise: ZeroDivide
		description: 'a defect reading the slot'.
	self
		should: [
			server
				slot: 1
				of: ((DefectiveReadDouble of: process)
						 when: #reifiedSlotAt:
						 answer: [ self defective: process in: #isImmediateOop ])
				named: 'nextLink' ]
		raise: ZeroDivide
		description: 'a defect saying where its value is'
