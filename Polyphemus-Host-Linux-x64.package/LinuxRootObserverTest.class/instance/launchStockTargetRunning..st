helpers
launchStockTargetRunning: aScript

	"The pinned target image on the edition's VM, as anyone would start it: no launcher, and
	not our descendant once its shell is gone. Answers its pid once it has started."

	| started |
	self directory ensureDeleteAll; ensureCreateDirectory.
	(self directory / 'target.st') writeStreamDo: [ :stream |
		stream nextPutAll: aScript; nextPutAll: '.
(' , (self directory / 'started') fullName printString , ' asFileReference) ensureCreateFile.
(Delay forSeconds: 600) wait.
Smalltalk exitSuccess' ].
	LibC system: PharoImageAccessor pathToTargetVM , ' --headless ' , PharoImageAccessor pathToTargetImage
		, ' --no-default-preferences st ' , (self directory / 'target.st') fullName , ' > '
		, (self directory / 'target.log') fullName , ' 2>&1 & echo $' , (String with: (Character value: 33)) , ' > '
		, (self directory / 'pid') fullName.
	started := (1 to: 300) anySatisfy: [ :each |
		           (self directory / 'started') exists or: [ (Delay forMilliseconds: 100) wait. false ] ].
	started ifFalse: [ self fail: 'the target never started' ].
	^ (self directory / 'pid') contents trimBoth asNumber
