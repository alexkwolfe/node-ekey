EventEmitter = require('events').EventEmitter
dgram = require('dgram')

class Ekey extends EventEmitter
  constructor: (@socket, @serial) ->
    @socket.on 'message', (msg) =>
      @handleMessage(msg)

  regex = /1_(\d{4})_(\d|-)_(\d{14})_(\d)_(\d|-)/
  actions =
    '1': 'open'
    '2': 'reject'
    '8': 'input'

  handleMessage: (msg) ->
    match = msg.toString().match(regex)
    if match
      user = @intOrNull(match[1])
      finger = if user then @intOrNull(match[2], 0) else null
      serial = match[3]
      action = actions[match[4]] ? 'unknown'
      relay = @intOrNull(match[5])

      if !@serial or (@serial and @serial == serial)
        @emit action, { user: user, finger: finger, relay: relay, serial: serial }

  intOrNull: (num, min = 1) ->
    return null if num == '-'
    num = parseInt(num, 10)
    if num >= min then num else null

  @bind: (serial) ->
    socket = dgram.createSocket('udp4')
    socket.bind(58104)
    new EKey(socket, serial)


module.exports = Ekey

