import "rsuite/styles/index.less"

require("./output/Web/index.js").main()

if (module.hot) {
  var ws = new WebSocket("ws://localhost:1234/")
  ws.onmessage = function () {
    window.location.href = window.location.href
  }
}
