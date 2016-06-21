ZBarcodeScanner
====================

An cordova implementation of ZBar SDK(http://zbar.sourceforge.net/). Currently supports only camera feed scanning.

Installation
------------

```
cordova plugin add <plugin-repo-url>
```


Methods
-------
- cordova.plugins.zbarScanner.scan


cordova.plugins.zbarScanner.scan
-------------------------------------------

<pre>
<code>
  cordova.plugins.zbarScanner.scan(function(data){
    console.log(JSON.stringify(data));
    // 8394834938, canceled
  }, function(error){
    console.log(error);
  },{
    cancelText: 'Cancel'
  });
</code>
</pre>

Supported Platforms
-------------------

- IOS
- Android (Coming soon)
