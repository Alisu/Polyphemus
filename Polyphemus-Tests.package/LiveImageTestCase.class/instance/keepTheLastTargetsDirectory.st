helpers
keepTheLastTargetsDirectory

	"What the last target left, its images apart, kept beside this one's until the next launch: a
	test run again after a failure launches at once, and the failed run's files say why (#164)."

	| kept |
	kept := self spikeDirectory parent / (self spikeDirectory basename , '-before').
	kept ensureDeleteAll.
	self spikeDirectory exists ifFalse: [ ^ self ].
	(self spikeDirectory files select: [ :each | #( 'image' 'changes' 'sources' ) includes: each extension ]) do: [ :each |
		each ensureDelete ].
	self spikeDirectory renameTo: kept basename
