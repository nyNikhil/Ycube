// Mobile navigation toggle
const toggle = document.querySelector('.nav-toggle');
const nav = document.querySelector('.site-nav');
if (toggle && nav) {
  toggle.addEventListener('click', () => {
    const isOpen = nav.classList.toggle('open');
    toggle.setAttribute('aria-expanded', String(isOpen));
  });
}

// Footer year
const yearEl = document.getElementById('year');
if (yearEl) {
  yearEl.textContent = String(new Date().getFullYear());
}

// Basic contact form validation
const contactForm = document.getElementById('contact-form');
if (contactForm) {
  contactForm.addEventListener('submit', (e) => {
    const name = /** @type {HTMLInputElement} */(document.getElementById('name'));
    const email = /** @type {HTMLInputElement} */(document.getElementById('email'));
    const message = /** @type {HTMLTextAreaElement} */(document.getElementById('message'));
    const notice = document.getElementById('form-notice');

    let errors = [];
    if (!name.value.trim()) errors.push('Name is required');
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.value)) errors.push('Valid email is required');
    if (message.value.trim().length < 10) errors.push('Message should be at least 10 characters');

    if (errors.length) {
      e.preventDefault();
      if (notice) {
        notice.textContent = errors.join(' • ');
        notice.className = 'error';
      }
    } else {
      e.preventDefault();
      if (notice) {
        notice.textContent = 'Thanks! Your message has been recorded.';
        notice.className = 'success';
      }
      contactForm.reset();
    }
  });
}

