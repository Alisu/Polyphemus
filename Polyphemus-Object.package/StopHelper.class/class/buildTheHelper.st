private
buildTheHelper

	"Built beside its source when missing or older, as bin/pharo-debuggable is; nil without cc."

	| source |
	source := self sourceFile.
	(source isNil or: [ source exists not ]) ifTrue: [ ^ nil ].
	^ self build: source
