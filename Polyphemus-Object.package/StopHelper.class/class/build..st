private
build: aSourceFile

	"The helper beside aSourceFile, built when missing or older: under a name of its own, then
	renamed into place, so that an image starting beside this one never runs it half written (#31).
	nil without cc."

	| built fresh |
	built := aSourceFile parent / 'polyphemus-stop'.
	(built exists and: [ built modificationTime >= aSourceFile modificationTime ]) ifFalse: [
		fresh := aSourceFile parent / ('polyphemus-stop.' , UUID new asString).
		LibC system: 'cc -O2 -o ''' , fresh fullName , ''' ''' , aSourceFile fullName , ''' 2>/dev/null && mv -f '''
			, fresh fullName , ''' ''' , built fullName , ''''.
		fresh ensureDelete ].
	^ built exists ifTrue: [ built ]
