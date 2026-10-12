tests
testANotificationIsNotAnswered

	self assert: (self answer: (Dictionary new
				  at: 'jsonrpc' put: '2.0';
				  at: 'method' put: 'notifications/initialized';
				  yourself)) isNil
