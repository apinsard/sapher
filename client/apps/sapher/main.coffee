require.config
  paths:
    'angular': '//static.sapher.dev:3000/lib/angular'
    'angular-route': '//static.sapher.dev:3000/lib/angular-route'
    'domReady': '//static.sapher.dev:3000/lib/domReady'
  shim:
    'angular':
      exports: 'angular'
    'angular-route':
      deps: ['angular']
  deps: ['./bootstrap']
