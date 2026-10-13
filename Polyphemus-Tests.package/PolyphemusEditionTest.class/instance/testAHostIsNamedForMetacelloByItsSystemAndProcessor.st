tests
testAHostIsNamedForMetacelloByItsSystemAndProcessor

	self assert: (PolyphemusHost pharo: 13 os: 'MacOS' cpu: 'arm64') metacelloAttribute equals: #'macos-arm64'.
	self assert: (PolyphemusHost pharo: 10 os: 'Linux' cpu: 'x64') metacelloAttribute equals: #'linux-x64'
