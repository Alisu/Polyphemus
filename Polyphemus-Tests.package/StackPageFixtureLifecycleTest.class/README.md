Checks that the interpreted fixture survives SUnit resetting the resource.

It lives on its own because it rebuilds the fixture from scratch and so costs about
twenty seconds, which would drag the whole stack page class into the slow tier.
