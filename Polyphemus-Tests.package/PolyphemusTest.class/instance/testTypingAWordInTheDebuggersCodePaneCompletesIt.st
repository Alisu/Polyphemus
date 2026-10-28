tests
testTypingAWordInTheDebuggersCodePaneCompletesIt

	"Completion asks the pane's class what a class answers; ours stood for the image's class and
	could not, so any word typed in the pane raised (#120)."

	| memory debugger area engine |
	memory := Polyphemus readImageFile: PharoImageAccessor pathToCandle64Bit.
	[
	debugger := StDebugger openOn: (Polyphemus sessionOnDeepestProcessIn: memory) withFullView: true.
	area := debugger code adapter widget textArea.
	engine := area editor completionEngine.
	engine setEditor: area editor.
	#( '1 ev' 'self ev' 'ev' ) do: [ :source |
		area setTextWith: source.
		area selectFrom: source size + 1 to: source size.
		engine openMenu.
		self shouldnt: [ engine context entries ] raise: Error.
		engine closeMenu ].
	area setTextWith: '1 ev'.
	area selectFrom: 5 to: 4.
	engine openMenu.
	self assert: (engine context entries anySatisfy: [ :each | each contents = #even ]) ]
		ensure: [ debugger ifNotNil: [ debugger window ifNotNil: [ :window | window close ] ] ]
