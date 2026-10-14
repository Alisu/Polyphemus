downloading
unpack: aZipFile named: aName into: aDirectory

	"An image's zip, unpacked where no shell fetches (Windows): its files renamed aName, the
	image moved in last so one that is there is whole, as fetchCommandFrom:named:into: does."

	| work |
	work := (aDirectory / ('.fetch.' , UUID new asString)) ensureCreateDirectory.
	[
	aZipFile binaryReadStreamDo: [ :stream |
		| zip |
		zip := ZipArchive new readFrom: stream.
		#( 'changes' 'sources' 'image' ) do: [ :extension |
			| name |
			name := aName , '.' , extension.
			zip members
				detect: [ :each | each fileName endsWith: '.' , extension ]
				ifFound: [ :member |
					member extractToFileNamed: name inDirectory: work.
					(aDirectory / name) exists ifFalse: [ (work / name) moveTo: aDirectory / name ] ] ] ] ]
		ensure: [ work ensureDeleteAll ]
