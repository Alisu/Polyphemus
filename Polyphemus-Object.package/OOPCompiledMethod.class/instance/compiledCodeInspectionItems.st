inspection
compiledCodeInspectionItems

	^ {
		  (#selector -> (self named: 'selector' read: [ self oopSelector ])).
		  (#methodClass -> (self named: 'methodClass' read: [ self oopMethodClass ])) }
