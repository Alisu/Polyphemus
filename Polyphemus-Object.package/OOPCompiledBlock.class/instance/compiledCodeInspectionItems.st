inspection
compiledCodeInspectionItems

	^ {
		  (#hostMethod -> (self named: 'hostMethod' read: [ self hostMethodOop ])).
		  (#methodHeader -> (self named: 'methodHeader' read: [ self methodHeader ])) }
