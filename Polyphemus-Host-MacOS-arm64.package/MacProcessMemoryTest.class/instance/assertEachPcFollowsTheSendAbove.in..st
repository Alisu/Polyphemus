helpers
assertEachPcFollowsTheSendAbove: aStack in: aMemory

	"Every frame under the newest has a pc just after the send of the frame above it (as
	MachineCodeCoreTest checks on Linux); answers how many machine code frames were checked."

	| checked |
	checked := 0.
	2 to: aStack size do: [ :index |
		| frame callee sent |
		frame := aStack at: index.
		callee := aStack at: index - 1.
		(frame isStackFrame and: [ callee isStackFrame ]) ifTrue: [
			self assert: frame pc notNil.
			frame isMachineCodeFrame ifTrue: [ checked := checked + 1 ].
			sent := MachineCodeCoreTest new selectorSentJustBefore: frame in: aMemory.
			self
				assert: (callee isBlockContext
						 ifTrue: [ sent notNil and: [ sent beginsWith: 'value' ] ]
						 ifFalse: [ sent = callee selector or: [ sent notNil and: [ sent beginsWith: 'perform' ] ] ])
				description: [
					frame printString , ' (pc ' , frame pc printString , ', machine code '
					, frame isMachineCodeFrame printString , ') sent ' , sent printString , ', above it '
					, callee printString ] ] ].
	^ checked
