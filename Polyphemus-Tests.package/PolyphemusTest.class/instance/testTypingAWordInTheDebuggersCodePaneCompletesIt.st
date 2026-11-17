tests
testTypingAWordInTheDebuggersCodePaneCompletesIt

	"Completion asks the pane's class what a class answers; ours stood for the image's class and
	could not, so any word typed in the pane raised (#120)."

	| memory debugger found |
	memory := Polyphemus readImageFile: PharoImageAccessor pathToCandle64Bit.
	[
	debugger := PolyphemusTestCase inUIProcess: [ StDebugger openOn: (Polyphemus sessionOnDeepestProcessIn: memory) withFullView: true ].
	"Typed and completed by the UI process, which owns the pane (#31); an error there is raised here."
	found := PolyphemusTestCase inUIProcess: [
		         | area engine |
		         area := debugger code adapter widget textArea.
		         engine := area editor completionEngine.
		         engine setEditor: area editor.
		         #( '1 ev' 'self ev' 'ev' ) do: [ :source |
			         area setTextWith: source.
			         area selectFrom: source size + 1 to: source size.
			         engine openMenu.
			         engine context entries.
			         engine closeMenu ].
		         area setTextWith: '1 ev'.
		         area selectFrom: 5 to: 4.
		         engine openMenu.
		         engine context entries collect: [ :each | each contents ] ].
	self assert: (found includes: #even) ]
		ensure: [ debugger ifNotNil: [ PolyphemusTestCase closeWindowOf: debugger ] ]
