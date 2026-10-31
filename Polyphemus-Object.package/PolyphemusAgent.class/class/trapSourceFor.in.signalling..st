source
trapSourceFor: aMethodSource in: aDirectory signalling: anIndex

	"For the held image to install itself: a MetaLink before that method, kept in Smalltalk at:
	#PolyphemusTrap. The first other process to claim that global takes it out, says who it is and
	signals our watcher, holding the image there; any other passes, as our agent does (#48, #137)."

	^ '| link dir agent |
dir := ' , aDirectory asFileReference fullName printString , ' asFileReference.
agent := Processor activeProcess.
link := MetaLink new.
link
	metaObject: [
		(Processor activeProcess ~~ agent and: [
			 [ Smalltalk globals removeKey: #PolyphemusTrap ifAbsent: [ nil ] ] valueUnpreemptively
				 notNil ]) ifTrue: [
			link uninstall.
			(dir / ''trap.tmp'')
				ensureDelete;
				writeStreamDo: [ :stream | stream print: Processor activeProcess basicIdentityHash ].
			(dir / ''trap.tmp'') renameTo: ''trap''.
			' , (self semaphoreAt: anIndex) , ' signal ] ];
	selector: #value;
	control: #before.
(' , aMethodSource , ') ast link: link.
Smalltalk globals at: #PolyphemusTrap put: link.
nil'
