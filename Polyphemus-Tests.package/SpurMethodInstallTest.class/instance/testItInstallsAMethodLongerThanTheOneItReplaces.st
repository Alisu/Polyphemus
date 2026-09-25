tests
testItInstallsAMethodLongerThanTheOneItReplaces

	"Rung 2 of #25: the new code does not fit where the old sat, so VMMaker's own allocator
	makes room in the memory it loaded the image into, and the class is pointed at the new
	method. The image is written by VMMaker's writer and reads back whole."

	| found install oop memory installed |
	found := self aMethodThatCanBeLengthenedIn: (reading oopClassNamed: 'Integer').
	found ifNil: [ ^ self fail: 'no method of Integer takes a statement that does nothing' ].
	install := SpurMethodInstall on: reading.
	memory := reading memoryManager.

	oop := install
		       install: found third
		       as: found first
		       of: (reading oopClassNamed: 'Integer')
		       insteadOf: found second.

	self assert: oop ~= found first address.
	installed := (1 to: (install codeOf: found third) size) collect: [ :each |
		             memory
			             byteAt: oop + 8 + (found third numLiterals + 1 * 8) + each - 1 ].
	self assert: installed equals: (install codeOf: found third).
	self assert: installed size > (install codeOf: found second) size.

	install memory writeTo: written.
	self assert: (Polyphemus readabilityOfImageFile: written) refusals asArray equals: #(  ).
	self assert: (Polyphemus readabilityOfImageFile: written) isFullyReadable
