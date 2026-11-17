tests
testATemporaryIsShownUnderItsOwnNameNotTheNameAtItsPlace

	"#191: the names in scope and the frame's slots are not one list in one order (a block names
	its method's temporaries too); a row showed the i-th slot under the i-th name."

	| server frame bySlot byName row |
	server := PolyphemusMCPServer new.
	frame := self frame.
	bySlot := frame receiver.
	byName := frame method.
	row := server
		       rowOfFrame: ((DefectiveReadDouble of: frame)
				        when: #tempNames answer: [ #( 'outer' 'own' ) ];
				        when: #tempAt: answer: [ :index | bySlot ];
				        when: #tempNamed: answer: [ :name | byName ];
				        yourself)
		       numbered: 1.
	self
		assert: ((row at: 'temporaries') collect: [ :each | each at: 'name' ]) asArray
		equals: #( 'outer' 'own' ).
	(row at: 'temporaries') do: [ :each |
		self assert: (each at: 'value') equals: (server describe: byName).
		self assert: (each at: 'address') equals: (server addressOf: byName) ]