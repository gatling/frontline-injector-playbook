// Smoke test of the browser runtime installed by remote-script/05-browser-setup.sh: launches Chrome Headless Shell
// through Playwright, with the installed Node.js and browser, as the Playwright driver of gatling-browser does.
// Usage: "$PLAYWRIGHT_NODEJS_PATH" browser-smoke.js <playwright-core package directory>

const assert = require("assert");
const { chromium } = require(process.argv[2]);

(async () => {
  const browser = await chromium.launch({ headless: true });
  console.log(`Chrome Headless Shell ${browser.version()}`);
  const page = await browser.newPage();

  // fonts: the families must resolve to different fonts, a missing fontconfig configuration maps them all to one
  await page.setContent(`
    <span id="sans" style="font-family: sans-serif; font-size: 40px">Gatling browser</span>
    <span id="mono" style="font-family: monospace; font-size: 40px">Gatling browser</span>
    <canvas id="webgl"></canvas>`);
  const sansWidth = await page.locator("#sans").evaluate((element) => element.getBoundingClientRect().width);
  const monoWidth = await page.locator("#mono").evaluate((element) => element.getBoundingClientRect().width);
  console.log(`Text widths: sans-serif ${sansWidth}px, monospace ${monoWidth}px`);
  assert.ok(sansWidth > 0 && Math.abs(sansWidth - monoWidth) > 1, "sans-serif and monospace must use different fonts");

  // WebGL, through the bundled SwiftShader
  assert.ok(await page.evaluate(() => !!document.getElementById("webgl").getContext("webgl")), "WebGL must be available");

  // HTTPS, which needs the NSS modules
  const response = await page.goto("https://example.com/", { timeout: 60000 });
  assert.strictEqual(response.status(), 200);
  console.log(`Loaded ${page.url()}: ${await page.title()}`);

  await browser.close();
  console.log("Browser smoke test OK");
})().catch((error) => {
  console.error(error);
  process.exit(1);
});
