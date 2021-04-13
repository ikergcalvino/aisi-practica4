var express = require('express');
var mysql = require('mysql');
var app = express();

app.get('/', function(req, res){
    var connection = mysql.createConnection({
      host     : "xxx-aisi2021-db",
      user     : "xxx-aisi2021",
      password : "12345",
      database : "database"
    });

    connection.connect(function(err){
        if(!err) {
            res.send("MariaDB connection status from user "+connection.config.user+": PASSED\n");
        } else {
            res.send("MariaDB connection status from user "+connection.config.user+": FAILED\n");
        }
        connection.end();
    });
});

app.listen(80, function () {
    console.log('Node.js app listening on port 80!');
});


