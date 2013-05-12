var host = 'http://localhost:8000/';
var links = [
    // '',
    'main.html',
    'about.html'
];
var names = [
    // 'index.png',
    'main.png',
    'about.png'
];
var casper = require('casper').create({
    loadImages: true,
    // loadPlugins: true,
    verbose: true,
    logLevel: 'info',
    // clientScripts: [
    //    'jquery-1.7.1.min.js',
    // ],
    viewportSize: {
        width:  1280,
        height: 1024
    },
    pageSettings: {
        javascriptEnabled: true
    }
});

casper.on('load.failed', function() {
    console.log('Could not load webpage.');
    this.exit();
});
casper.on('error', function(msg, backtrace) {
    console.log('Error: ' + msg);
    this.exit();
});
casper.on('timeout', function() {
    console.log('The webpage timed out.');
    this.exit();
});
casper.on('page.error', function(msg, backtrace) {
    console.log('There was an error loading the webpage.');
    this.exit();
});

casper.start(host+links[0]);

for (var i = 1; i < links.length; i++) {
    (function(j) {
        var link = host + links[j];
        casper.thenOpen(link);
    }(i));
}

var index=0;
var date = new Date();
var folderName = date.toGMTString().replace(/:/g,'.');
casper.on('load.finished', function() {
    this.captureSelector(folderName+'/'+names[index], 'html');
    index++;
});

casper.run();
