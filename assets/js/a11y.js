const LOCAL_STORAGE_FONT_FACE_KEY = "lis:fontFace"

const setfontFace = (face) => {
  localStorage.setItem(LOCAL_STORAGE_FONT_FACE_KEY, face)
  document.body.style.fontFace = face;
};

window.addEventListener("storage", (e) => {
  e.key === LOCAL_STORAGE_FONT_FACE_KEY;
  setfontFace(e.newValue || "");
});

window.addEventListener("lis:set-font-face", (event) => {
  setfontFace(event.target.value);
});

window.addEventListener("load", () => {
  const fontFace = localStorage.getItem(LOCAL_STORAGE_FONT_FACE_KEY)
  setfontFace(fontFace ? fontFace : '');
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
