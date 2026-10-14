action
fetchWithoutShellFrom: aURL named: aName into: aDirectory

	"Fetch an image's zip with Zinc and unpack it: Windows has no sh, curl or unzip to run."

	| zip |
	(aDirectory / (aName , '.image')) exists ifTrue: [ ^ self ].
	zip := aDirectory / ('.fetch.' , UUID new asString , '.zip').
	[
	ZnClient new
		url: aURL;
		downloadTo: zip.
	self class unpack: zip named: aName into: aDirectory ] ensure: [ zip ensureDelete ]
