var express = require('express');
var mysql = require('mysql');
var app = express();

app.get('/', function(req, res) {
    var connection = mysql.createConnection({
      host     : "xxx-aisi2122-db",
      user     : "xxx-aisi2122",
      password : "12345",
      database : "xxx-aisi2122-database"
    });

    var url = req.protocol + '://' + req.get('host') + req.originalUrl;

    connection.connect(function(err) {
	var msg = '<h2><u>GEI AISI 2021/2022: Node.js+Express+MariaDB</u>\n<p>URL: ' +url+ '\n<p>MariaDB connection from user ' +connection.config.user+ ': ';

        if(!err) {
	    res.type('text/html').send(msg+ '<span style="color: green;">PASSED</span>\n');
        } else {
            res.type('text/html').send(msg+ '<span style="color: red;">FAILED</span>\n<p>'+err+'\n');
        }
        connection.end();
    });
});

app.listen(80, function () {
    console.log('Node.js app listening on port 80!');
});


