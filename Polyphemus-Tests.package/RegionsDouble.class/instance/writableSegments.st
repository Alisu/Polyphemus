reading
writableSegments

	^ self segments select: [ :each | writable includes: each address ]
