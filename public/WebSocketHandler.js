// WebSocket port handler

/* Install it with:

    WebSocketHandler.subscribe(cmdPort, subPort)

Supports three messages, through the cmdPort:

    { tag: 'open', args: { key: <string>, message: <url> } }
    { tag: 'close', args: { key: <string> } }
    { tag: 'send', args: { key: <string>, message: <string> } }

The key for the 'open' command may be omitted, and the url will be used as key.

Sends back the following messages:

    { tag: 'error', args: { key: <string>, message: <string> } }
    { tag: 'connected', args: { key: <string>, message: <string> } }
    { tag: 'received', args: { key: <string>, message: <string> } }
    { tag: 'closed', args: { key: <string>, message: <string> } }

*/

var WebSocketHandler = {};

(function() {
  var sockets = {};
  var send;

  WebSocketHandler.subscribe = subscribe;
  WebSocketHandler.dispatch = dispatch; // for debugging

  function subscribe(cmdPort, subPort) {
    if (subPort) {
      send = subPort.send;
    } else {
      // Debugging
      send = function(v) { console.log(v); }
    }
    if (cmdPort) {
      cmdPort.subscribe(function(command) {
        if (typeof(command) == 'object') {
          var tag = command.tag;
          var args = command.args;
          dispatch(tag, args);
        }
      });
    }
  }

  function returnObject(tag, key, message) {
    send({tag: tag, args: { key: key, message: message} });
  }

  function returnError(key, err) {
    returnObject('error', key, err);
  }

  function dispatch(tag, args) {
    if (tag == 'open') {
      doOpen(args.key, args.message);
    } else if (tag == 'close') {
      doClose(args.key);
    } else if (tag == 'send') {
      doSend(args.key, args.message);
    } else {
      returnError('', 'Unknown tag: ' + tag);
    }
  }

  function doOpen(key, url) {
    if (!key) key = url;
    if (sockets[key]) {
      return returnError(key, 'Socket already open.');
    }
    try {
	  var socket = new WebSocket(url);
      sockets[key] = socket;
    }
    catch(err) {
      // The old code returned BadSecurity if err.name was 'SecurityError'
      // or BadArgs otherwise.
      return returnError(key, "open: can't create socket for URL: " + url + ', ' + err.name);
    }
    socket.addEventListener('open', function(event) {
      console.log('Socket connected for URL: ' + url);
      returnObject('connected', key, 'Socket connected for url: ' + url);
    });
    socket.addEventListener('message', function(event) {
      var message = event.data;
      console.log('Received for "' + key + '": ' + message);
      returnObject('received', key, message);
    });
    socket.addEventListener('close', function(event) {
	  console.log('"' + key + '" closed');
      delete sockets[key];        // for open errors
      returnObject('closed', key, 'Socket closed unexpectedly.');
    });
  } 

  function doSend(key, message) {
    var socket = sockets[key];
    if (!socket) {
      returnError(key, 'send, socket not open.');
    }
    console.log('Sending message for key: ' + key + ', ' + message);
    try {
	  socket.send(message);
    } catch(err) {
      returnError(key, 'Send error: ' + err.name);
    }
  } 

  function doClose(key) {
    var socket = sockets[key];
    if (!socket) {
      returnError(key, 'close, socket not open.');
    }
    try {
      delete sockets[key];
      socket.close();
      returnObject('closed', key, 'Socket closed.');
    } catch(err) {
      returnError(key, 'Close error: ' + err.name);
    }
  } 

})();
