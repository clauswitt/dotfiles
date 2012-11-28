var fs = require('fs');
var arguments = process.argv.splice(2);
var dirCount = parseInt(arguments[0]);
var numberOfCharacters = arguments[1];
function pad(num, size) {
    var s = num+"";
    while (s.length < size) s = "0" + s;
    return s;
}

var dirName = ''; 
for(var i=0;i < dirCount;i++) {
  dirName = pad(i+1, numberOfCharacters);
  fs.mkdir(dirName);
}

