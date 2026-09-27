tests
testTheHostsCompilerDefaultsDoNotChangeWhatWeCompile

	"#7. Switching on the defaults Pharo 11 adds must not change how many frames compile back
	to the file's bytes."

	| usual withPharo11Defaults saved |
	usual := self faithfulFramesOf: self memory.
	saved := self optionsPharo11AddsHere collect: [ :each |
		         each -> (self compilationContextClass perform: each) ].
	[
	self optionsPharo11AddsHere do: [ :each |
		self compilationContextClass perform: (each , ':') asSymbol with: true ].
	withPharo11Defaults := self faithfulFramesOf: (self memory forgetWhatWasRead; yourself) ]
		ensure: [
			saved do: [ :each |
				self compilationContextClass perform: (each key , ':') asSymbol with: each value ] ].

	self assert: withPharo11Defaults equals: usual
