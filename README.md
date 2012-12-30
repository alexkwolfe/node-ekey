A node.js driver for the TOCAnet UDP adapter for ekey fingerprint scanners.

[![Build Status](https://secure.travis-ci.org/alexkwolfe/node-tocanet.png)](http://travis-ci.org/alexkwolfe/node-tocanet)

The TOCAnet UDP adapter attaches to ekey fingerprint scanners. The adapter announces fingerprint scanner activity
via UDP messages. This driver parses those messages and emits events.


## Usage

Call the bind function to listen for fingerprint scanning events.

```javascript
var EKey = require('ekey');
var ekey = EKey.bind();
ekey.on('open', function(info) {
  // a successful fingerprint scan has occurred
  console.log({
    user: info.user,     // the user number (1-99)
    finger: info.finger, // the user's finger (0-9)
    relay: info.relay,   // the relay that will be opened
    serial: info.serial  // the fingerprint scanner's serial #
  });
})
```

## Events

An event occurs when a fingerprint scan is performed. If the scan succeeds, the `open` event is emitted. If the scan
fails, the `reject` event is emitted. For obvious reasons, the user and finger of a failed scan are unavailable.

If you have a unit that supports a digital input, then the `input` event will also be emitted.