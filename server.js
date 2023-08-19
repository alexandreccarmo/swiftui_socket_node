var express = require('express');
var app = express();
var server = require('http').createServer(app);
var io = require('socket.io')(server);
server.listen(process.env.PORT || 3000);

connections = [];

// serve.listen(process.env.PORT || 3000);
console.log('Sever is running ...');

// https://github.com/socketio/socket.io/issues/2192
io.on('connection', function (socket) {
	connections.push(socket);
	console.log('Connect %s socket are connected', connections.length);


	//Desconnect
	socket.on('disconnect', function(data){
		connections.splice(connections.indexOf(socket), 1);
		console.log('disconnect: %s socket are connected', connections.length);		
	})


	socket.on('NodeJs Server Port', function(data){
		console.log(data);
		socket.emit('iOS Client Port', {msg: 'Ola iOS Client!'});
	})
});

// nodejs server side 2.0.4