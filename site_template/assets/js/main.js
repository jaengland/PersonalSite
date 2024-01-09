import { selectFn, getRandomImage} from './utils.js';
import { closeMobileNav, updateActiveTab, startTyped} from './nav.js';

(function () {
  "use strict";
  
  /**
   * Reload home page
   */
  $(document).on('click', "#home-link", function () {
    // change focus
    updateActiveTab(selectFn, '.home-link')

    const previousImageDiv = selectFn('.previousImage')
    const previousImage = previousImageDiv.classList[1]
    previousImageDiv.classList.remove(previousImage)

    //swap to home
    $("#content").fadeOut(200, function () {
      $("#content").load("home.html", function () {

        const randomImage = getRandomImage(previousImage)
        const newImage = randomImage.split("/")[2]

        // Get the home div and update its background image
        const homeDiv = selectFn('.bg-image')
        homeDiv.style.backgroundImage = `url(${randomImage})`;
        previousImageDiv.classList.add(newImage)
        // fade in
        $("#content").fadeIn(200, function () {
          // startup typed now that page is loaded
          startTyped(selectFn)
        });
      });
    });

    closeMobileNav(selectFn)
    return false;
  });

  /**
   * Load About page
   */
  $(document).on('click', '#about-link', function () {
    // change focus
    updateActiveTab(selectFn, '.about-link')

    $("#content").fadeOut(200, function () {
      $("#content").load("about.html", function () {
        $("#content").fadeIn(200);
      });
    });
    closeMobileNav(selectFn)
    return false;
  });

  /**
   * Load Projects page
   */
  $(document).on('click', '#projects-link', function () {
    // change focus
    updateActiveTab(selectFn, '.projects-link')

    $("#content").fadeOut(200, function () {
      $("#content").load("projects.html", function () {
        $("#content").fadeIn(200);
      });
    });
    closeMobileNav(selectFn)
    return false;
  });

  /**
   * Easy event listener function
   */
  const on = (type, el, listener, all = false) => {
    let selectEl = selectFn(el, all)
    if (selectEl) {
      if (all) {
        selectEl.forEach(e => e.addEventListener(type, listener))
      } else {
        selectEl.addEventListener(type, listener)
      }
    }
  }


  /**
   * Mobile nav toggle
   */
  on('click', '.mobile-nav-toggle', function (e) {
    selectFn('#navbar').classList.toggle('navbar-mobile')
    this.classList.toggle('bi-list')
    this.classList.toggle('bi-x')
  })

  /**
   * Mobile nav dropdowns activate
   */
  on('click', '.navbar .dropdown > a', function (e) {
    if (selectFn('#navbar').classList.contains('navbar-mobile')) {
      e.preventDefault()
      this.nextElementSibling.classList.toggle('dropdown-active')
    }
  }, true)

  /**
   * Intro type effect
   */
  startTyped(selectFn)

})()