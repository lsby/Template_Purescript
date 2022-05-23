var { ipcRenderer } = require("electron");

window.addEventListener("DOMContentLoaded", () => {
  window.ipcRenderer = ipcRenderer;
});
