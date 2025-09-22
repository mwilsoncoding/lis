const LOCAL_STORAGE_FONT_FAMILY_KEY = "lis:fontFace"

const setFontFamily = (family) => {
  localStorage.setItem(LOCAL_STORAGE_FONT_FAMILY_KEY, family)
  document.body.style.fontFamily = family;
};

window.addEventListener("storage", (e) => e.key === LOCAL_STORAGE_FONT_FAMILY_KEY && setFontFamily(e.newValue || ""));

window.addEventListener("lis:set-font-family", (event) => {
  setFontFamily(event.target.value);
});

window.addEventListener("load", () => {
  const fontFamily = localStorage.getItem(LOCAL_STORAGE_FONT_FAMILY_KEY)
  setFontFamily(fontFamily ? fontFamily : '');
});

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

window.addEventListener("load", () => {
  const fontSize = localStorage.getItem(LOCAL_STORAGE_FONT_SIZE_KEY)
  setFontSize(fontSize ? fontSize : '');
});
