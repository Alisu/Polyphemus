tests
testAMethodOneOfWhoseLiteralsPointsNowhereShowsItInItsPlaceInspectedAndDisassembled

	"#206: one literal that does not read cost the inspector every literal of the method."

	| method literals |
	method := ((reifiedMemory contextsOfProcess:
		            (DamagedPharoImageResource process: 'DelaySemaphoreScheduler>>suspendAtTimingPriority' in: reifiedMemory))
		           detect: [ :each | each isBlockContext ]) homeMethod.

	literals := method inspectionItems select: [ :each | each key isString and: [ each key beginsWith: 'literal ' ] ].
	self assert: literals size equals: method numberOfLiterals.
	self assert: literals first value isUnreadableSlot.
	self deny: literals second value isUnreadableSlot.
	self assert: method allSymbolicBytecodes notEmpty
