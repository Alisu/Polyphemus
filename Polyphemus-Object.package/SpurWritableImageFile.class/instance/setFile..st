initialization
setFile: aSpurImageFile

	file := aSpurImageFile.
	bytes := file file binaryReadStreamDo: [ :stream | stream upToEnd ]
