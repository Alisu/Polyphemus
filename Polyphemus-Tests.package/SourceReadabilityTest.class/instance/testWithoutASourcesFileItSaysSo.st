tests
testWithoutASourcesFileItSaysSo

	| memory |
	memory := self class memory.

	self deny: (memory sourceReadability canRead: #source).
	self assert: (memory sourceReadability whyNot: #source) equals: #noSourcesFile
