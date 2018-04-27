import puppeteer from 'puppeteer'

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
  browser = await puppeteer.launch
    args: ['--no-sandbox', '--disable-setuid-sandbox']

  page = await browser.newPage()
  await page.setExtraHTTPHeaders(httpHeaders)
  await page.emulateMedia(mediaType)

  if source.startsWith('http')
    await page.goto(source, gotoOptions)
  else
    await page.setContent(source)

  await sleep(delay)
  await page.pdf(pdfOptions)
  await browser.close()

pdf()
