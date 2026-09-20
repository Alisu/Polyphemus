helpers
launch: anImage

	"Start the virtual machine running these tests on that image, not as our descendant, and
	answer its pid. Headless: it has no window to open and nothing to say."

	| pidFile bang |
	bang := String with: (Character value: 33).
	pidFile := self runDirectory / 'pid'.
	pidFile ensureDelete.
	LibC system: Smalltalk vm fullPath , ' --headless ' , anImage fullName
		, ' > /dev/null 2>&1 & echo $' , bang , ' > ' , pidFile fullName.
	self
		assert: (self waitUntil: [ pidFile exists and: [ pidFile contents trimBoth notEmpty ] ])
		description: 'nothing was started'.
	^ pidFile contents trimBoth asNumber
