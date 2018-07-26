import puppeteer from 'puppeteer'
import request from 'request-promise-native'

CHROME_HEADLESS_HOST = process.env.CHROME_HEADLESS_HOST
CHROME_HEADLESS_PORT = process.env.CHROME_HEADLESS_PORT

args = process.argv.slice(2)

source = args[0]
pdfOptions = JSON.parse(args[1])
gotoOptions = JSON.parse(args[2])
mediaType = args[3]
httpHeaders = JSON.parse(args[4])
delay = args[5]

unless mediaType in ['screen', 'print']
  mediaType = null

sleep = (ms) ->
  ms = (ms) ? ms : 0;
  new Promise (resolve) -> setTimeout(resolve, ms)

pdf = ->
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

  # make sure all images lazyload immediately
  page.evaluate ->
    window.lazySizesConfig or= {}
    window.lazySizesConfig.preloadAfterLoad = true

  if source.startsWith('http')
    await page.goto(source, gotoOptions)
  else
    await page.setContent(source)

  await sleep(delay)
  await page.pdf(pdfOptions)

  if CHROME_HEADLESS_HOST && CHROME_HEADLESS_PORT
    await browser.disconnect()
  else
    await browser.close()

pdf()
