var argscheck = require('cordova/argscheck'),
  utils = require('cordova/utils'),
  exec = require('cordova/exec');

var zbarScanner = function() {}

zbarScanner.prototype = {
  scan: function(successCallback, errorCallback, options) {
    options = options || {};
    options.cancelText = options.cancelText || "Cancel";
    cordova.exec(successCallback, errorCallback, "ZBarScanner", "startScanning", [options]);
  }
}

module.exports = new zbarScanner();
