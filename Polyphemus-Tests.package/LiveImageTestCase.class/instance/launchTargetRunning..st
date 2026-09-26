helpers
launchTargetRunning: aScript

	"The pinned image, launched observable and not as our descendant, running aScript, which
	must leave a file named started in the spike directory. Answers the pid once it has."

	| shim target pidFile bang |
	shim := self repositoryDirectory / 'bin' / 'pharo-debuggable'.
	shim exists ifFalse: [ ^ self skip: 'build bin/pharo-debuggable first' ].
	target := PharoImageAccessor pathToPharo10 asFileReference.
	target exists ifFalse: [ ^ self skip: 'the pinned Pharo 10 image has not been downloaded' ].
	self spikeDirectory ensureDeleteAll.
	self spikeDirectory ensureCreateDirectory.
	(self spikeDirectory / 'target.st') writeStreamDo: [ :stream |
		stream nextPutAll: aScript ].
	bang := String with: (Character value: 33).
	pidFile := self spikeDirectory / 'pid'.
	LibC system: 'POLYPHEMUS_OBSERVER=any ' , shim fullName , ' ' , Smalltalk vm fullPath
		, ' --headless ' , target fullName , ' st ' , (self spikeDirectory / 'target.st') fullName
		, ' > ' , (self spikeDirectory / 'target.log') fullName , ' 2>&1 & echo $' , bang , ' > ' , pidFile fullName.
	self
		assert: (self waitFor: [ (self spikeDirectory / 'started') exists ])
		description: 'the target never started'.
	^ pidFile contents trimBoth asNumber
