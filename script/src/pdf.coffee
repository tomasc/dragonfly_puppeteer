import puppeteer from 'puppeteer'
import request from 'request-promise-native'
import url from 'url'

CHROME_HEADLESS_HOST = process.env.CHROME_HEADLESS_HOST
CHROME_HEADLESS_PORT = process.env.CHROME_HEADLESS_PORT

args = process.argv.slice(2)

source = args[0]
pdfOptions = JSON.parse(args[1])
gotoOptions = JSON.parse(args[2])
mediaType = args[3]
httpHeaders = JSON.parse(args[4])
userAgent = args[5]
delay = args[6]

unless mediaType in ['screen', 'print']
  mediaType = null

sleep = (ms) ->
  ms = (ms) ? ms : 0;
  new Promise (resolve) -> setTimeout(resolve, ms)

lookupAsync = require('util').promisify(require('dns').lookup)

changeUrlHostToUseIp = (urlString) ->
  urlParsed = url.parse(urlString)
  { address: hostIp } = await lookupAsync(urlParsed.hostname)
  delete urlParsed.host
  urlParsed.hostname = hostIp
  url.format(urlParsed)

pdf = ->
  endPoint = await changeUrlHostToUseIp("http://#{CHROME_HEADLESS_HOST}:#{CHROME_HEADLESS_PORT}/json/version")

  if CHROME_HEADLESS_HOST && CHROME_HEADLESS_PORT
    res = await request(
      json: true,
      resolveWithFullResponse: true
      uri: "http://#{CHROME_HEADLESS_HOST}:#{CHROME_HEADLESS_PORT}/json/version"
    )

    webSocket = res.body.webSocketDebuggerUrl

    browser = await puppeteer.connect
      browserWSEndpoint: webSocket

  else
    browser = await puppeteer.launch
      args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage']

  page = await browser.newPage()
  await page.setExtraHTTPHeaders(httpHeaders)
  await page.emulateMedia(mediaType)
  await page.setUserAgent(userAgent)

  # make sure all images lazyload immediately
  page.evaluate ->
    window.lazySizesConfig or= {}
    window.lazySizesConfig.preloadAfterLoad = true

  if source.startsWith('http')
    await page.goto(source, gotoOptions)
  else
    # await page.setContent(source)
    # @see https://github.com/GoogleChrome/puppeteer/issues/728#issuecomment-409247948
    await page.goto("data:text/html,#{source}", gotoOptions)

  await sleep(delay)
  await page.pdf(pdfOptions)

  if CHROME_HEADLESS_HOST && CHROME_HEADLESS_PORT
    await browser.disconnect()
  else
    await browser.close()

pdf()
