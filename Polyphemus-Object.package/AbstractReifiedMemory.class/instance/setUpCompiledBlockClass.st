initialization
setUpCompiledBlockClass

	"By name, the candle image's own too. Other compiled code is a method: CompiledMethod, and
	Pharo 14's FFICompiledMethod for an FFI call (#150)."

	#( 'CompiledBlock' 'PCCompiledBlock' ) do: [ :each |
		(self preFindClassNamed: each ifAbsent: [ nil ]) ifNotNil: [ :index |
			^ compiledBlockClassIndex := index - 1 ] ].
	compiledBlockClassIndex := nil
