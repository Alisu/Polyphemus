private
buildTheHelper

	"Built beside its source when missing or older, as bin/pharo-debuggable is; nil without cc."

	| source built |
	source := self sourceFile.
	(source isNil or: [ source exists not ]) ifTrue: [ ^ nil ].
	built := source parent / 'polyphemus-stop'.
	(built exists and: [ built modificationTime >= source modificationTime ]) ifFalse: [
		LibC system: 'cc -O2 -o ''' , built fullName , ''' ''' , source fullName , ''' 2>/dev/null' ].
	^ built exists ifTrue: [ built ]
