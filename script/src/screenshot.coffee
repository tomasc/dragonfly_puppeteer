import puppeteer from 'puppeteer'

test = =>
  browser = await puppeteer.launch()
  console.log await browser.version()
  await browser.close()

test()
