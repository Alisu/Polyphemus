"Compile the FileTree working copy into this image, then save it.

 Metacello refuses to reload a package whose version looks unchanged, so during the
 TDD loop we compile straight from the files: every *.class and *.extension directory
 of every Polyphemus package, creating classes that do not exist yet and removing
 methods whose files are gone."
| root joined ensureClass syncSide created compiled removed |
"Wherever this checkout is: Iceberg has it registered, which the test fixtures rely on too."
root := (IceRepository registeredRepositoryIncludingPackage:
	(RPackageOrganizer default packageNamed: 'Polyphemus-Object')) location.
created := compiled := removed := 0.

joined := [ :coll | String streamContents: [ :s |
	coll do: [ :each | s nextPutAll: each asString ] separatedBy: [ s space ] ] ].

"A class with no README.md has no comment, and FileTree hands a Metacello load a nil where the
 comment should be -- which stops the whole load with a message about line endings. This loader
 never reads comments, so it would never notice. Saying so here is the only warning there is."
(root allChildrenMatching: '*.class') , (root allChildrenMatching: '*.trait') do: [ :each |
	(each / 'README.md') exists ifFalse: [
		('NO COMMENT ' , each basename , ' -- a Metacello load will fail on it') traceCr ] ].

ensureClass := [ :props :packageName |
	| name |
	name := (props at: 'name') asSymbol.
	(Smalltalk includesKey: name)
		ifTrue: [
			"An instance variable added to the working copy has to reach the class, or the
			 methods using it will not compile and the loop reports errors that are not
			 in the code."
			| cls |
			cls := Smalltalk at: name.
			((props at: 'instvars') collect: [ :each | each asString ]) do: [ :ivar |
				(cls instVarNames includes: ivar) ifFalse: [
					cls addInstVarNamed: ivar.
					('IVAR ', name, '>>', ivar) traceCr ] ].
			"The category is the class's tag, which is how the browser groups it."
			(props at: 'category' ifAbsent: [ nil ]) ifNotNil: [ :wanted |
				cls category = wanted asSymbol ifFalse: [
					cls category: wanted.
					('RETAGGED ', name, ' -> ', wanted) traceCr ] ].
			cls ]
		ifFalse: [
			| superName cls |
			superName := (props at: 'super') asSymbol.
			(Smalltalk includesKey: superName)
				ifFalse: [ ('SKIP ', name, ': superclass ', superName, ' missing') traceCr. nil ]
				ifTrue: [
					cls := (Smalltalk at: superName)
						subclass: name
						instanceVariableNames: (joined value: (props at: 'instvars'))
						classVariableNames: (joined value: (props at: 'classvars'))
						package: packageName.
					(props at: 'classinstvars') ifNotEmpty: [ :civ |
						cls class instanceVariableNames: (joined value: civ) ].
					created := created + 1.
					('CREATED ', name) traceCr.
					(props at: 'category' ifAbsent: [ nil ]) ifNotNil: [ :wanted |
						cls category = wanted asSymbol ifFalse: [
							cls category: wanted.
							('RETAGGED ', name, ' -> ', wanted) traceCr ] ].
					cls ] ] ].

syncSide := [ :target :dir :packageName |
	| fileSelectors |
	fileSelectors := Set new.
	dir exists ifTrue: [
		dir files do: [ :f |
			(f basename endsWith: '.st') ifTrue: [
				[ | lines source sel |
				  lines := f contents lines.
				  source := String streamContents: [ :s |
					  lines allButFirst do: [ :l | s nextPutAll: l; cr ] ].
				  sel := target compile: source classified: lines first.
				  sel ifNotNil: [ fileSelectors add: sel ].
				  compiled := compiled + 1 ]
					on: Error
					do: [ :e | ('COMPILE ERR ', f basename, ' :: ', e messageText asString) traceCr ] ] ] ].
	"Drop methods this package used to define and no longer does. #localSelectors
	excludes methods a trait provides: removing those would silently strip the class."
	fileSelectors ifNotEmpty: [
	[ target localSelectors asArray do: [ :sel |
		| m |
		m := target >> sel.
		((fileSelectors includes: sel) not
			and: [ [ m package notNil and: [ m package name = packageName ] ]
				on: Error do: [ :e | false ] ])
			ifTrue: [ target removeSelector: sel.
				removed := removed + 1.
				('REMOVED ', target name, '>>', sel) traceCr ] ] ]
		on: Error do: [ :e | ] ] ].

(root directories select: [ :d | d basename endsWith: '.package' ]) do: [ :pkgDir |
	| packageName |
	packageName := pkgDir basename copyReplaceAll: '.package' with: ''.
	(RPackageOrganizer default includesPackageNamed: packageName) ifFalse: [
		('SKIP package ', packageName, ': not loaded in this image') traceCr ].
	(RPackageOrganizer default includesPackageNamed: packageName) ifTrue: [
	pkgDir directories do: [ :clsDir |
		((clsDir basename endsWith: '.class')
			or: [ (clsDir basename endsWith: '.extension')
			or: [ clsDir basename endsWith: '.trait' ] ]) ifTrue: [
			| cls |
			cls := (clsDir basename endsWith: '.class')
				ifTrue: [ ensureClass
						value: (STONJSON fromString: (clsDir / 'properties.json') contents)
						value: packageName ]
				ifFalse: [ | n |
					n := ((clsDir basename copyReplaceAll: '.extension' with: '')
						copyReplaceAll: '.trait' with: '') asSymbol.
					Smalltalk at: n ifAbsent: [ nil ] ].
			cls ifNotNil: [
				syncSide value: cls value: clsDir / 'instance' value: packageName.
				syncSide value: cls class value: clsDir / 'class' value: packageName ] ] ] ] ].

('SYNC ', created printString, ' classes created, ', compiled printString,
	' methods compiled, ', removed printString, ' removed') traceCr.
Smalltalk snapshot: true andQuit: true
