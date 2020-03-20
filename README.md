# WKLocalStyle
Demonstrate an issue with WKWebView loading styles with custom URL schemes on a remote page. This app will use WKWebview load `https://tomhamming.github.io/index.html` and, after page load, attempt to inject a reference to a local CSS file in the app bundle that will turn the text red and set the font to a custom bundled font, referenced via a CSS `@font-face` declaration. The CSS file is referenced via a custom URL scheme, `myfile://`, implemented with `WKURLSchemeHandler`. It also injects an image loaded via the same mechanism to demonstrate that the mechanism itself works.

## Steps
 - Run the sample app. Note that the image shows up but the text is black and uses a serif-font.
 - In ViewController.m, comment out the line that loads the remote URL and uncomment the block of code that downloads the page and loads it from a local file.
 - Run the app again. Notice the red text and sans-serif font.