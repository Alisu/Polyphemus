highlighting
bytesOfHost: aCompiledCode

	^ ((aCompiledCode initialPC to: aCompiledCode endPC) collect: [ :each |
		   aCompiledCode at: each ]) asArray
