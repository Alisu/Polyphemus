source
trapRemovalSourceIn: aDirectory

	"Taking out a trap, claimed as the trap claims itself (#137): #removed, or #firing when a process
	claimed it and has not said so yet, or #fired when it has, its file in aDirectory."

	^ '([ Smalltalk globals removeKey: #PolyphemusTrap ifAbsent: [ nil ] ] valueUnpreemptively)
	ifNil: [ (' , aDirectory asFileReference fullName printString , ' asFileReference / ''trap'') exists
			ifTrue: [ #fired ] ifFalse: [ #firing ] ]
	ifNotNil: [ :link | link uninstall. #removed ]'
