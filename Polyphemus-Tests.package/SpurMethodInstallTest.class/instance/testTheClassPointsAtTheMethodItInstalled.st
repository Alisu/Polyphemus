tests
testTheClassPointsAtTheMethodItInstalled

	"A method dictionary holds one pointer to each method: after installing, it is the new
	one, and the old object is left where it was for whoever still names it."

	| found install oop methods integer |
	found := self aMethodThatCanBeLengthenedIn: (reading oopClassNamed: 'Integer').
	found ifNil: [ ^ self fail: 'no method of Integer takes a statement that does nothing' ].
	integer := reading oopClassNamed: 'Integer'.
	install := SpurMethodInstall on: reading.

	oop := install
		       install: found third
		       as: found first
		       of: integer
		       insteadOf: found second.

	methods := (integer reifiedSlotAt: 2) reifiedSlotAt: 2.
	self
		assert: ((1 to: methods oopNumberOfSlots) anySatisfy: [ :each |
				 [ (methods reifiedSlotAt: each) address = oop ] on: Error do: [ :e | false ] ]).
	self
		deny: ((1 to: methods oopNumberOfSlots) anySatisfy: [ :each |
				 [ (methods reifiedSlotAt: each) address = found first address ]
					 on: Error
					 do: [ :e | false ] ])
