const LOCAL_STORAGE_FONT_FACE_KEY = "lis:fontFace";

const setFontFace = (face) => {
  localStorage.setItem(LOCAL_STORAGE_FONT_FACE_KEY, face);
  document.body.style.fontFamily = face;
};

window.addEventListener("storage", (e) => {
  e.key === LOCAL_STORAGE_FONT_FACE_KEY;
  setFontFace(e.newValue || "");
});

window.addEventListener(LOCAL_STORAGE_FONT_FACE_KEY, (event) => {
  setFontFace(event.target.value);
});

const fontFace = localStorage.getItem(LOCAL_STORAGE_FONT_FACE_KEY);
setFontFace(fontFace ? fontFace : '');
