import {
  LOAD_ACCESSIBILITY_SELECTIONS_EVENT
} from "./constants"

const LOCAL_STORAGE_FONT_SIZE_KEY = "lis:fontSize";

const setFontSize = (percent) => {
  localStorage.setItem(LOCAL_STORAGE_FONT_SIZE_KEY, `${percent}`);
  document.documentElement.style.fontSize = `${percent}%`;
};

const loadFontSizeSelection = () => {
  const selection = localStorage.getItem(LOCAL_STORAGE_FONT_SIZE_KEY);
  if (selection) {
    const select = document.getElementById("accessibility-modal-select-font-size");
    if (select) {
      select.value = selection;
    }
  }
};

window.addEventListener("storage", (e) => {
  e.key === LOCAL_STORAGE_FONT_SIZE_KEY;
  setFontSize(e.newValue || "");
});

window.addEventListener(LOCAL_STORAGE_FONT_SIZE_KEY, (event) => {
  setFontSize(event.target.value);
});

window.addEventListener(LOAD_ACCESSIBILITY_SELECTIONS_EVENT, loadFontSizeSelection);

const fontSize = localStorage.getItem(LOCAL_STORAGE_FONT_SIZE_KEY);
setFontSize(fontSize ? fontSize : '');