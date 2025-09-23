import {
  LOAD_ACCESSIBILITY_SELECTIONS_EVENT,
  STORAGE_EVENT
} from "./constants"

const DEFAULT_THEME = "system"
const LOCAL_STORAGE_THEME_KEY = "lis:theme";
const THEME_ATTRIBUTE = "data-theme"
const THEME_SELECT_ELEMENT_ID = "theme-toggle"

const setTheme = (theme) => {
  if (theme === DEFAULT_THEME) {
    localStorage.removeItem(LOCAL_STORAGE_THEME_KEY);
    document.documentElement.removeAttribute(THEME_ATTRIBUTE);
  } else {
    localStorage.setItem(LOCAL_STORAGE_THEME_KEY, theme);
    document.documentElement.setAttribute(THEME_ATTRIBUTE, theme);
  }
};

const loadThemeSelection = () => {
  const selection = localStorage.getItem(LOCAL_STORAGE_THEME_KEY);
  if (!selection) return;
  const select = document.getElementById(THEME_SELECT_ELEMENT_ID);
  if (!select) return;
  select.value = selection;
};

window.addEventListener(STORAGE_EVENT, (e) => {
  e.key === LOCAL_STORAGE_THEME_KEY;
  setTheme(e.newValue || DEFAULT_THEME);
});

window.addEventListener(LOCAL_STORAGE_THEME_KEY, (event) => {
    console.log("theme event received")
  setTheme(event.target.value);
});

window.addEventListener(LOAD_ACCESSIBILITY_SELECTIONS_EVENT, loadThemeSelection);

if (!document.documentElement.hasAttribute(THEME_ATTRIBUTE)) {
  setTheme(localStorage.getItem(LOCAL_STORAGE_THEME_KEY) || DEFAULT_THEME);
}