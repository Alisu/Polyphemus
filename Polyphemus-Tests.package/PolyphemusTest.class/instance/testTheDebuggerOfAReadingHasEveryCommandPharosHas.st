tests
testTheDebuggerOfAReadingHasEveryCommandPharosHas

	"#151: a debugger on a reading is made ours once built, to keep its title's marks; Pharo builds
	its menus again from its class, and must find every command it found on StDebugger."

	| memory debugger |
	memory := Polyphemus readImageFile: PharoImageAccessor pathToCandle64Bit.
	[
	debugger := StDebugger openOn: (Polyphemus sessionOnDeepestProcessIn: memory) withFullView: true.
	PolyphemusTestCase drawWindowOf: debugger.
	self
		assert: (debugger rootCommandsGroup allCommands collect: [ :each | each name ]) asSet
		equals: ((StDebugger buildRootCommandsGroupFor: debugger) allCommands collect: [ :each | each name ]) asSet ] ensure: [
		debugger ifNotNil: [ debugger window ifNotNil: [ :window | window close ] ] ]
