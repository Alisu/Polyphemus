tests
testWithoutASourcesFileItSaysSo

	| memory |
	memory := Polyphemus readImageFile: self pinnedImageAlone.

	self deny: (memory sourceReadability canRead: #source).
	self assert: (memory sourceReadability whyNot: #source) equals: #noSourcesFile
