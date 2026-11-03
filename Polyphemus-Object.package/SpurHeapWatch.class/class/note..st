watching
note: aRawHeap

	"Only a heap whose bytes we hold: one read from a running process could not be read once the
	test that read it has ended its process."

	aRawHeap readsARunningProcess ifTrue: [ ^ self ].
	current ifNotNil: [ :watch | watch add: aRawHeap ]
