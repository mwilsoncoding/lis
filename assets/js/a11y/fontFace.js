import {
  LOAD_ACCESSIBILITY_SELECTIONS_EVENT,
  STORAGE_EVENT
} from "./constants"

const DEFAULT_FONT_FACE = "System"
const FONT_FACE_SELECT_ELEMENT_ID = "accessibility-modal-select-font-face";
const LOCAL_STORAGE_FONT_FACE_KEY = "lis:fontFace";

const setFontFace = (face) => {
  if (face === DEFAULT_FONT_FACE) {
    localStorage.removeItem(LOCAL_STORAGE_FONT_FACE_KEY);
    document.body.style.fontFamily = "";
  } else {
    localStorage.setItem(LOCAL_STORAGE_FONT_FACE_KEY, face);
    document.body.style.fontFamily = face;
  }
};

const loadFontFaceSelection = () => {
  const selection = localStorage.getItem(LOCAL_STORAGE_FONT_FACE_KEY);
  if (!selection) return;
  const select = document.getElementById(FONT_FACE_SELECT_ELEMENT_ID);
  if (!select) return;
  select.value = selection;
};

const alreadySet = () => {
  return document.body.style.fontFamily !== "";
};

window.addEventListener(STORAGE_EVENT, (e) => {
  e.key === LOCAL_STORAGE_FONT_FACE_KEY;
  setFontFace(e.newValue || DEFAULT_FONT_FACE);
});

window.addEventListener(LOCAL_STORAGE_FONT_FACE_KEY, (event) => {
  setFontFace(event.target.value);
});

window.addEventListener(LOAD_ACCESSIBILITY_SELECTIONS_EVENT, loadFontFaceSelection);

if (!alreadySet()) {
  setFontFace(localStorage.getItem(LOCAL_STORAGE_FONT_FACE_KEY) || DEFAULT_FONT_FACE);
}
