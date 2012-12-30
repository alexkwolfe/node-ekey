assert = require('chai').assert
EKey = require('../ekey')
EventEmitter = require('events').EventEmitter

describe 'EKey', ->
  ekey = null
  socket = null

  beforeEach ->
    socket = new EventEmitter()
    ekey = new EKey(socket)

  it 'should emit open', (done) ->
    ekey.on 'open', (msg) ->
      assert.equal 2, msg.user
      assert.equal 1, msg.finger
      assert.equal 1, msg.relay
      assert.equal '80004404070399', msg.serial
      done()
    socket.emit 'message', '1_0002_1_80004404070399_1_1'

  it 'should emit reject', (done) ->
    ekey.on 'reject', (msg) ->
      assert.isNull msg.user
      assert.isNull msg.finger
      assert.isNull msg.relay
      assert.equal '80004404070399', msg.serial
      done()
    socket.emit 'message', '1_0000_0_80004404070399_2_-'

  it 'should ignore messages from other scanners', (done) ->
    ekey = new EKey(socket, '80004404070399')
    ekey.on 'open', ->
      assert.fail 'should not emit messages from other scanners'
    socket.emit 'message', '1_0002_1_12345678901234_1_1'
    setTimeout(done, 10)