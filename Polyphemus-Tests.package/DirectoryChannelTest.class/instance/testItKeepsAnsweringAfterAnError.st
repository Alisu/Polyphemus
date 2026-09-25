tests
testItKeepsAnsweringAfterAnError

	[ channel ask: '1 / 0' ] on: PolyphemusChannelError do: [ :error | ].
	self assert: (channel ask: '''still'' , '' here''') equals: '''still here'''
