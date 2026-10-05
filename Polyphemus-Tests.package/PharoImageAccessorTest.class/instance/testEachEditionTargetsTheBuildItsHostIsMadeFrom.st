tests
testEachEditionTargetsTheBuildItsHostIsMadeFrom

	"An edition's live and editing tests run on the image pinned for its version, and name its
	temporaries only where this host compiles its methods as the target's compiler did (#6),
	which the same build does. The hosts are the builds bin/ci-setup.sh installs."

	| recipe |
	recipe := (self repositoryDirectory / 'bin' / 'ci-setup.sh') contents.
	10 to: 14 do: [ :version |
		| pin |
		pin := PharoImageAccessor downloadNameForPharo: version.
		self
			assert: (recipe includesSubstring: '/' , pin , ';')
			description: 'Pharo ' , version printString , ' targets ' , pin , ', not its host''s build' ]
