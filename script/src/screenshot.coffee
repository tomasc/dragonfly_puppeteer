import puppeteer from 'puppeteer'

args = process.argv.slice(2)

source = args[0]
viewportOptions = JSON.parse(args[1])
screenshotOptions = JSON.parse(args[2])
gotoOptions = JSON.parse(args[3])
delay = args[4]

sleep = (ms) ->
  ms = (ms) ? ms : 0;
  new Promise (resolve) -> setTimeout(resolve, ms)

screenshot = ->
  browser = await puppeteer.launch
    args: ['--no-sandbox', '--disable-setuid-sandbox']

  page = await browser.newPage()
  page.setViewport(viewportOptions)

  if source.startsWith('http')
    await page.goto(source, gotoOptions)
  else
    await page.setContent(source)

  await sleep(delay)
  await page.screenshot(screenshotOptions)
  await browser.close()

screenshot()
