!function(e,t){"object"==typeof exports&&"object"==typeof module?module.exports=t():"function"==typeof define&&define.amd?define("@tomasc/dragonfly_puppeteer",[],t):"object"==typeof exports?exports["@tomasc/dragonfly_puppeteer"]=t():e["@tomasc/dragonfly_puppeteer"]=t()}(global,function(){return function(e){var t={};function r(n){if(t[n])return t[n].exports;var o=t[n]={i:n,l:!1,exports:{}};return e[n].call(o.exports,o,o.exports,r),o.l=!0,o.exports}return r.m=e,r.c=t,r.d=function(e,t,n){r.o(e,t)||Object.defineProperty(e,t,{enumerable:!0,get:n})},r.r=function(e){"undefined"!=typeof Symbol&&Symbol.toStringTag&&Object.defineProperty(e,Symbol.toStringTag,{value:"Module"}),Object.defineProperty(e,"__esModule",{value:!0})},r.t=function(e,t){if(1&t&&(e=r(e)),8&t)return e;if(4&t&&"object"==typeof e&&e&&e.__esModule)return e;var n=Object.create(null);if(r.r(n),Object.defineProperty(n,"default",{enumerable:!0,value:e}),2&t&&"string"!=typeof e)for(var o in e)r.d(n,o,function(t){return e[t]}.bind(null,o));return n},r.n=function(e){var t=e&&e.__esModule?function(){return e.default}:function(){return e};return r.d(t,"a",t),t},r.o=function(e,t){return Object.prototype.hasOwnProperty.call(e,t)},r.p="",r(r.s=2)}([function(e,t){e.exports=require("request-promise-native")},function(e,t){e.exports=require("puppeteer")},function(e,t,r){"use strict";var n,o,a,i,u,s,c,l,p,f,d,w=g(r(1)),b=g(r(0));function g(e){return e&&e.__esModule?e:{default:e}}n=process.env.CHROME_HEADLESS_HOST,o=process.env.CHROME_HEADLESS_PORT,a=process.argv.slice(2),p=a[0],d=JSON.parse(a[1]),c=JSON.parse(a[2]),u=JSON.parse(a[3]),s=JSON.parse(a[4]),f=a[5],i=a[6],d.width&&(d.width=parseInt(d.width)),d.height&&(d.height=parseInt(d.height)),d.deviceScaleFactor&&(d.deviceScaleFactor=parseFloat(d.deviceScaleFactor)),l=function(e){var t;return e=null!=(t=e)?t:{ms:0},new Promise(function(t){return setTimeout(t,e)})},async function(){var e,t,r;n&&o?(r=(await(0,b.default)({json:!0,resolveWithFullResponse:!0,uri:"http://"+n+":"+o+"/json/version"})).body.webSocketDebuggerUrl,e=await w.default.connect({browserWSEndpoint:r})):e=await w.default.launch({args:["--no-sandbox","--disable-setuid-sandbox","--disable-dev-shm-usage","--hide-scrollbars"]}),t=await e.newPage(),await t.setViewport(d),await t.setExtraHTTPHeaders(s),await t.setUserAgent(f),t.evaluate(function(){return window.lazySizesConfig||(window.lazySizesConfig={}),window.lazySizesConfig.preloadAfterLoad=!0}),p.startsWith("http")?await t.goto(p,u):await t.goto("data:text/html,"+p,u),await l(i),await t.screenshot(c),n&&o?await e.disconnect():await e.close()}()}])});