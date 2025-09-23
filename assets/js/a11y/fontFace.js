import {
  LOAD_ACCESSIBILITY_SELECTIONS_EVENT
} from "./constants"

const LOCAL_STORAGE_FONT_FACE_KEY = "lis:fontFace";

const setFontFace = (face) => {
  localStorage.setItem(LOCAL_STORAGE_FONT_FACE_KEY, face);
  document.body.style.fontFamily = face;
};

const loadFontFaceSelection = () => {
  const selection = localStorage.getItem(LOCAL_STORAGE_FONT_FACE_KEY);
  if (!selection) return;
  const select = document.getElementById("accessibility-modal-select-font-face");
  if (!select) return;
  select.value = selection;
};

window.addEventListener("storage", (e) => {
  e.key === LOCAL_STORAGE_FONT_FACE_KEY;
  setFontFace(e.newValue || "");
});

window.addEventListener(LOCAL_STORAGE_FONT_FACE_KEY, (event) => {
  setFontFace(event.target.value);
});

window.addEventListener(LOAD_ACCESSIBILITY_SELECTIONS_EVENT, loadFontFaceSelection);

const fontFace = localStorage.getItem(LOCAL_STORAGE_FONT_FACE_KEY);
setFontFace(fontFace ? fontFace : '');
