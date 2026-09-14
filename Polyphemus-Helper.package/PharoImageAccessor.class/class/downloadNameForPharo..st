downloading
downloadNameForPharo: aNumber

	"files.pharo.org publishes versioned artefacts for the full images only, so pin
	one instead of following 'latest-64', which moves under the tests: the fixture
	had silently become a 2025 Pharo 11 build while these tests were written against
	a 2023 one.

	The fixture must also match the simulator. We run VMMaker v10.0.0, and
	interpreting a Pharo 11 image with it fails the inverse pc mapping assertion in
	StackInterpreter>>contextInstructionPointer:frame: as soon as the interpreter
	returns out of a base frame."

	aNumber = 10 ifTrue: [ ^ 'Pharo10.0.1-0.build.527.sha.0542643.arch.64bit' ].
	^ 'latest-64'
