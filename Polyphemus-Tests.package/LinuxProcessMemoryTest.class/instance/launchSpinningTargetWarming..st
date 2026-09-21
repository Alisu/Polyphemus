helpers
launchSpinningTargetWarming: aBoolean

	"The pinned image, launched observable and not as our descendant, with a process spinning
	at the priority of a user's own so that it never goes idle. Answers its pid once it says
	it started."

	| shim target pidFile bang |
	shim := self repositoryDirectory / 'bin' / 'pharo-debuggable'.
	shim exists ifFalse: [ ^ self skip: 'build bin/pharo-debuggable first' ].
	target := PharoImageAccessor pathToPharo10 asFileReference.
	target exists ifFalse: [ ^ self skip: 'the pinned Pharo 10 image has not been downloaded' ].
	self spikeDirectory ensureDeleteAll.
	self spikeDirectory ensureCreateDirectory.
	(self spikeDirectory / 'target.st') writeStreamDo: [ :stream |
		stream nextPutAll: (self spinningTargetScriptWarming: aBoolean) ].
	bang := String with: (Character value: 33).
	pidFile := self spikeDirectory / 'pid'.
	LibC system: 'POLYPHEMUS_OBSERVER=any ' , shim fullName , ' ' , Smalltalk vm fullPath
		, ' --headless ' , target fullName , ' st ' , (self spikeDirectory / 'target.st') fullName
		, ' > /dev/null 2>&1 & echo $' , bang , ' > ' , pidFile fullName.
	self
		assert: (self waitFor: [ (self spikeDirectory / 'started') exists ])
		description: 'the target never started'.
	^ pidFile contents trimBoth asNumber
