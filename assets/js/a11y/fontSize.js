const LOCAL_STORAGE_FONT_SIZE_KEY = "lis:fontSize"

const setFontSize = (percent) => {
  localStorage.setItem(LOCAL_STORAGE_FONT_SIZE_KEY, `${percent}`)
  document.documentElement.style.fontSize = `${percent}%`;
};

window.addEventListener("storage", (e) => {
  e.key === LOCAL_STORAGE_FONT_SIZE_KEY;
  setFontSize(e.newValue || "");
});

window.addEventListener("lis:set-font-size", (event) => {
  setFontSize(event.target.value);
});

const fontSize = localStorage.getItem(LOCAL_STORAGE_FONT_SIZE_KEY)
setFontSize(fontSize ? fontSize : '');