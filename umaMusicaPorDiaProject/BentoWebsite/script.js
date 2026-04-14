document.addEventListener('DOMContentLoaded', () => {
  let currentLang = 'en';
  let currentTab = 'terms';

  const contentContainer = document.getElementById('content-container');
  const langButtons = document.querySelectorAll('.lang-switcher button');
  const tabButtons = document.querySelectorAll('.tab-btn');
  const footerText = document.getElementById('footer-text');

  function renderContent() {
    const localeData = locales[currentLang];
    const data = localeData[currentTab];
    
    // Quick reflow hack to trigger CSS animation on every render
    contentContainer.style.animation = 'none';
    contentContainer.offsetHeight; 
    contentContainer.style.animation = null;

    contentContainer.innerHTML = `
      <p class="last-updated">${data.lastUpdated}</p>
      ${data.content}
    `;

    document.getElementById('tab-terms-btn').textContent = localeData.tabTerms;
    document.getElementById('tab-privacy-btn').textContent = localeData.tabPrivacy;
    footerText.textContent = localeData.footerText;
  }

  function setActiveButton(buttons, activeValue, dataAttr) {
    buttons.forEach(btn => {
      if (btn.getAttribute(dataAttr) === activeValue) {
        btn.classList.add('active');
      } else {
        btn.classList.remove('active');
      }
    });
  }

  langButtons.forEach(btn => {
    btn.addEventListener('click', (e) => {
      currentLang = e.target.getAttribute('data-lang');
      setActiveButton(langButtons, currentLang, 'data-lang');
      document.documentElement.lang = currentLang;
      renderContent();
    });
  });

  tabButtons.forEach(btn => {
    btn.addEventListener('click', (e) => {
      currentTab = e.target.getAttribute('data-tab');
      setActiveButton(tabButtons, currentTab, 'data-tab');
      renderContent();
    });
  });

  // Auto-detect browser language or default to English
  const browserLang = navigator.language.split('-')[0];
  if (['en', 'pt', 'es'].includes(browserLang)) {
    currentLang = browserLang;
    setActiveButton(langButtons, currentLang, 'data-lang');
    document.documentElement.lang = currentLang;
  }
  
  renderContent();
});