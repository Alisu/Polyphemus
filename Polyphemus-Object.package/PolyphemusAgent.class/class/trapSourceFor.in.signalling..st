source
trapSourceFor: aMethodSource in: aDirectory signalling: anIndex

	"For the held image to install itself: a MetaLink before that method, kept in Smalltalk at:
	#PolyphemusTrap. The first process not ours to claim that global takes it out and, while the
	trap is still wanted (its file), says who it is and signals our watcher (#48, #137, #161, #181)."

	^ '| link dir agent |
dir := ' , aDirectory asFileReference fullName printString , ' asFileReference.
agent := self at: #agent.
link := MetaLink new.
link
	metaObject: [
		(Processor activeProcess ~~ agent and: [ Processor activeProcess name ~= ' , self requestProcessName printString , ' and: [
			 [ Smalltalk globals removeKey: #PolyphemusTrap ifAbsent: [ nil ] ] valueUnpreemptively
				 notNil ] ]) ifTrue: [
			link uninstall.
			(dir / ''trap-wanted'') exists ifTrue: [
				(dir / ''trap.tmp'')
					ensureDelete;
					writeStreamDo: [ :stream | stream print: Processor activeProcess basicIdentityHash ].
				(dir / ''trap.tmp'') renameTo: ''trap''.
				' , (self semaphoreAt: anIndex) , ' signal ] ] ];
	selector: #value;
	control: #before.
(' , aMethodSource , ') ast link: link.
Smalltalk globals at: #PolyphemusTrap put: link.
nil'
