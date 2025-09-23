import {
  LOAD_ACCESSIBILITY_SELECTIONS_EVENT,
  STORAGE_EVENT
} from "./constants"

const DEFAULT_FONT_SIZE = "System"
const FONT_SIZE_SELECT_ELEMENT_ID = "accessibility-modal-select-font-size";
const LOCAL_STORAGE_FONT_SIZE_KEY = "lis:fontSize";

const setFontSize = (percent) => {
  if (percent === DEFAULT_FONT_SIZE) {
    localStorage.removeItem(LOCAL_STORAGE_FONT_SIZE_KEY);
    document.documentElement.style.fontSize = "";
  } else {
    localStorage.setItem(LOCAL_STORAGE_FONT_SIZE_KEY, `${percent}`);
    document.documentElement.style.fontSize = `${percent}%`;
  }
};

const loadFontSizeSelection = () => {
  const selection = localStorage.getItem(LOCAL_STORAGE_FONT_SIZE_KEY);
  if (!selection) return;
  const select = document.getElementById(FONT_SIZE_SELECT_ELEMENT_ID);
  if (!select) return;
  select.value = selection;
};

window.addEventListener(STORAGE_EVENT, (e) => {
  e.key === LOCAL_STORAGE_FONT_SIZE_KEY;
  setFontSize(e.newValue || DEFAULT_FONT_SIZE);
});

window.addEventListener(LOCAL_STORAGE_FONT_SIZE_KEY, (event) => {
  setFontSize(event.target.value);
});

window.addEventListener(LOAD_ACCESSIBILITY_SELECTIONS_EVENT, loadFontSizeSelection);

setFontSize(localStorage.getItem(LOCAL_STORAGE_FONT_SIZE_KEY) || DEFAULT_FONT_SIZE);