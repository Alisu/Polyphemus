accessing
server

	"A server with the damaged copy of the pinned image opened once for the class."

	^ Server ifNil: [
		  Server := PolyphemusMCPServer new.
		  Handle := (((self call: 'open_image' with: (Dictionary new
					              at: 'path' put: DamagedPharoImageResource damagedImagePath;
					              yourself)) at: 'structuredContent') at: 'handle').
		  Server ]
