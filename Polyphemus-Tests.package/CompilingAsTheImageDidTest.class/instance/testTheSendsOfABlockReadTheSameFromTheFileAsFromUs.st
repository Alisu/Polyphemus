tests
testTheSendsOfABlockReadTheSameFromTheFileAsFromUs

	"#4. The decoder reads through #initialPC, #endPC and #at:, which a reified block must
	answer as a reified method does: counting bytecodes, not raw bytes."

	| memory frame host fileSends |
	memory := Polyphemus readImageFile: PharoImageAccessor pathToPharo10.
	frame := self frameOf: memory described: 'TKTWorkerProcess>>workerLoop [block]'.
	host := memory hostBlockFor: frame in: (memory hostCompilationOf: frame).
	fileSends := (SendSequence of: frame compiledCode) selectors asArray.

	self deny: fileSends isEmpty.
	self assert: fileSends equals: (SendSequence of: host) selectors asArray
