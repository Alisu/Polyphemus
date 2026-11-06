initialization
setUpCompiledBlockClass

	"By name, the candle image's own too. Other compiled code is a method: CompiledMethod, and
	Pharo 14's FFICompiledMethod for an FFI call (#150)."

	#( 'CompiledBlock' 'PCCompiledBlock' ) do: [ :each |
		[ ^ compiledBlockClassIndex := (self preFindClassNamed: each) - 1 ] on: NotFound do: [ :e |  ] ].
	compiledBlockClassIndex := nil
