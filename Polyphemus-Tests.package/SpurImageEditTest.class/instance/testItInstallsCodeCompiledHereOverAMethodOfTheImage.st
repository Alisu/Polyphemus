tests
testItInstallsCodeCompiledHereOverAMethodOfTheImage

	"The fix a debugger makes: source edited here, compiled here, written into the image. A
	comparison swapped for one of the same length, so the literal frame and the room the code
	has stay as they were -- rung 1 of #25."

	| reading edit integer found file installed |
	reading := Polyphemus readImageFile: PharoImageAccessor pathToPharo10.
	edit := (SpurImageEdit on: PharoImageAccessor pathToPharo10) reading: reading.
	integer := reading oopClassNamed: 'Integer'.
	found := self aMethodWhoseComparisonCanBeSwappedIn: integer of: reading.
	found ifNil: [ ^ self fail: 'no method of Integer recompiles here and holds a comparison' ].

	edit
		replaceCodeOfMethodShown: found first
		from: found second
		to: found third.
	edit writeTo: written.

	file := SpurImageFile on: written.
	installed := (1 to: (edit codeOf: found third) size) collect: [ :each |
		             file
			             unsignedAt: (edit addressInFileOf: found first) + 8
				             + (found second initialPC - 1) + each - 1
			             size: 1 ].
	file close.
	self assert: installed equals: (edit codeOf: found third).
	self assert: installed ~= (edit codeOf: found second).
	self assert: (Polyphemus readabilityOfImageFile: written) isFullyReadable
