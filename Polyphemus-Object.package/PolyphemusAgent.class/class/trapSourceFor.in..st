source
trapSourceFor: aMethodSource in: aDirectory

	"For the held image to install itself: a MetaLink before that method which takes itself out,
	says which process reached it, and wakes our watcher -- holding the image right there. Kept
	in Smalltalk at: #PolyphemusTrap until it fires. Our agent, which installs it, passes (#48)."

	^ '| link dir agent |
dir := ' , aDirectory asFileReference fullName printString , ' asFileReference.
agent := Processor activeProcess.
link := MetaLink new.
link
	metaObject: [
		Processor activeProcess == agent ifFalse: [
			link uninstall.
			Smalltalk globals removeKey: #PolyphemusTrap ifAbsent: [ ].
			(dir / ''trap.tmp'')
				ensureDelete;
				writeStreamDo: [ :stream | stream print: Processor activeProcess basicIdentityHash ].
			(dir / ''trap.tmp'') renameTo: ''trap''.
			(Smalltalk specialObjectsArray at: 31) signal ] ];
	selector: #value;
	control: #before.
(' , aMethodSource , ') ast link: link.
Smalltalk globals at: #PolyphemusTrap put: link.
nil'
