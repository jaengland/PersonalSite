import { selectFn} from './utils.js';

export const closeMobileNav = (selectFn) => {
    const navbar = selectFn('#navbar');
    if (navbar.classList.contains('navbar-mobile')) {
        navbar.classList.remove('navbar-mobile');
        const navToggle = selectFn('.mobile-nav-toggle');
        navToggle.classList.toggle('bi-list');
        navToggle.classList.toggle('bi-x');
    };
};

export const updateActiveTab = (selectFn, newtab) => {
    const focusLink = selectFn('.active')
    focusLink.classList.remove('active')

    const newFocus = selectFn(newtab)
    newFocus.classList.add('active')
}

export const startTyped = (selectFn)  => {
    const typed = selectFn('.typed')
    if (typed) {
      let typed_strings = typed.getAttribute('data-typed-items')
      typed_strings = typed_strings.split(',')
      new Typed('.typed', {
        strings: typed_strings,
        loop: true,
        typeSpeed: 100,
        backSpeed: 50,
        backDelay: 2000
      });
    }
}