import puppeteer from 'puppeteer'
import request from 'request-promise-native'

CHROME_HEADLESS_HOST = process.env.CHROME_HEADLESS_HOST
CHROME_HEADLESS_PORT = process.env.CHROME_HEADLESS_PORT

args = process.argv.slice(2)

source = args[0]
viewportOptions = JSON.parse(args[1])
screenshotOptions = JSON.parse(args[2])
gotoOptions = JSON.parse(args[3])
httpHeaders = JSON.parse(args[4])
userAgent = args[5]
delay = args[6]

viewportOptions.width = parseInt(viewportOptions.width) if viewportOptions.width
viewportOptions.height = parseInt(viewportOptions.height) if viewportOptions.height
viewportOptions.deviceScaleFactor = parseFloat(viewportOptions.deviceScaleFactor) if viewportOptions.deviceScaleFactor

sleep = (ms) ->
  ms = (ms) ? ms : 0;
  new Promise (resolve) -> setTimeout(resolve, ms)

screenshot = ->
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
      args: [
        '--no-sandbox',
        '--disable-setuid-sandbox',
        '--disable-dev-shm-usage',
        '--hide-scrollbars'
      ]

  page = await browser.newPage()
  await page.setViewport(viewportOptions)
  await page.setExtraHTTPHeaders(httpHeaders)
  await page.setUserAgent(userAgent)

  # make sure all images lazyload immediately
  page.evaluate ->
    window.lazySizesConfig or= {}
    window.lazySizesConfig.preloadAfterLoad = true

  if source.startsWith('http')
    await page.goto(source, gotoOptions)
  else
    await page.setContent(source)

  await sleep(delay)
  await page.screenshot(screenshotOptions)

  if CHROME_HEADLESS_HOST && CHROME_HEADLESS_PORT
    await browser.disconnect()
  else
    await browser.close()

screenshot()
