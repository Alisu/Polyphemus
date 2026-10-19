helpers
launchStockTargetRunning: aScript

	"The pinned target as anyone would start it: no launcher, not our descendant, and under sudo
	as its own user (observeeUser), in a directory of that user's, watch directory included.
	Answers its pid once it has started."

	| started command user |
	self directory ensureDeleteAll; ensureCreateDirectory.
	(self directory / 'watch') ensureCreateDirectory.
	(self directory / 'target.st') writeStreamDo: [ :stream |
		stream nextPutAll: aScript; nextPutAll: '.
(' , (self directory / 'started') fullName printString , ' asFileReference) ensureCreateFile.
(Delay forSeconds: 600) wait.
Smalltalk exitSuccess' ].
	command := PharoImageAccessor pathToTargetVM , ' --headless ' , PharoImageAccessor pathToTargetImage
		, ' --no-default-preferences st ' , (self directory / 'target.st') fullName , ' > '
		, (self directory / 'target.log') fullName , ' 2>&1 & echo $' , (String with: (Character value: 33)) , ' > '
		, (self directory / 'pid') fullName.
	user := self observeeUser.
	user ifNotNil: [
		LibC system: 'chown -R ' , user , ' ' , self directory fullName.
		command := 'sudo -u ' , user , ' sh -c ''' , command , '''' ].
	LibC system: command.
	started := (1 to: 300) anySatisfy: [ :each |
		           (self directory / 'started') exists or: [ (Delay forMilliseconds: 100) wait. false ] ].
	started ifFalse: [ self fail: 'the target never started' ].
	^ (self directory / 'pid') contents trimBoth asNumber
