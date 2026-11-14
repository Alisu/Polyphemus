finding
preFindClassNamed: aString ifAbsent: aBlock

	"The class table index of the class named aString, found before the memory is initialized.
	An entry that reads as no class, or a class whose name does not read, is passed over."

	stringClassIndexes isEmpty ifTrue: [
		^ NotInTheReading signal: 'no class is found by name before the classes of its strings are known' ].
	memory classTableEntriesDo: [ :aClassTableAddress :anIndex |
		[
		((self classIsReadableAt: aClassTableAddress) and: [
			 OOPClassInstanceSideObject canHandle: aClassTableAddress memory: self ]) ifTrue: [
			| class name |
			class := OOPClassInstanceSideObject on: aClassTableAddress memory: self.
			name := class slotAt: class slotIndexForClassName.
			(self readAt: name through: [ (OOPString on: name memory: memory) asString ]) = aString ifTrue: [
				^ anIndex + 1 ] ] ]
			on: NotInTheReading
			do: [ :unreadable |  ] ].
	^ aBlock value
