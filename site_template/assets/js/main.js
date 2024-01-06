(function () {
  "use strict";

  /**
   * Element selector helper function
   */
  const select = (el, all = false) => {
    el = el.trim()
    if (all) {
      return [...document.querySelectorAll(el)]
    } else {
      return document.querySelector(el)
    }
  }

  function getRandomImage(substring) {
    const images = [
      'assets/img/photog1.jpg',
      'assets/img/photog2.jpg',
      'assets/img/photog3.jpg',
    ];

    let randomImage;
    do {
      // Select a random image
      randomImage = images[Math.floor(Math.random() * images.length)];
    } while (randomImage.includes(substring)); // Keep selecting if substring is found

    return randomImage;
  }

  /**
   * Reload home page
   */
  $(document).on('click', "#home-link", function () {
    // change focus
    const focusLink = select('.active')
    focusLink.classList.remove('active')

    const newFocus = select('.home-link')
    newFocus.classList.add('active')

    const previousImageDiv = select('.previousImage')
    const previousImage = previousImageDiv.classList[1]
    previousImageDiv.classList.remove(previousImage)


    //swap to home
    $("#content").fadeOut(200, function () {
      $("#content").load("home.html", function () {

        const randomImage = getRandomImage(previousImage)
        const newImage = randomImage.split("/")[2]

        // Get the home div and update its background image
        const homeDiv = select('.bg-image')
        homeDiv.style.backgroundImage = `url(${randomImage})`;
        previousImageDiv.classList.add(newImage)
        // fade in
        $("#content").fadeIn(200, function () {
          // startup typed now that page is loaded
          const typed = select('.typed')
          console.log(typed)
          if (typed) {
            let typed_strings = typed.getAttribute('data-typed-items')
            console.log(typed_strings)
            typed_strings = typed_strings.split(',')
            new Typed('.typed', {
              strings: typed_strings,
              loop: true,
              typeSpeed: 100,
              backSpeed: 50,
              backDelay: 2000
            });
          }
        });
      });
    });

    return false;
  });

  /**
   * Load About page
   */
  $(document).on('click', '#about-link', function () {
    // change focus
    const focusLink = select('.active')
    focusLink.classList.remove('active')

    const newFocus = select('.about-link')
    newFocus.classList.add('active')

    $("#content").fadeOut(200, function () {
      $("#content").load("about.html", function () {
        $("#content").fadeIn(200);
      });
    });
    return false;
  });

  /**
   * Easy event listener function
   */
  const on = (type, el, listener, all = false) => {
    let selectEl = select(el, all)
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
    select('#navbar').classList.toggle('navbar-mobile')
    this.classList.toggle('bi-list')
    this.classList.toggle('bi-x')
  })

  /**
   * Mobile nav dropdowns activate
   */
  on('click', '.navbar .dropdown > a', function (e) {
    if (select('#navbar').classList.contains('navbar-mobile')) {
      e.preventDefault()
      this.nextElementSibling.classList.toggle('dropdown-active')
    }
  }, true)

  /**
   * Intro type effect
   */
  const typed = select('.typed')
  console.log(typed)
  if (typed) {
    let typed_strings = typed.getAttribute('data-typed-items')
    console.log(typed_strings)
    typed_strings = typed_strings.split(',')
    new Typed('.typed', {
      strings: typed_strings,
      loop: true,
      typeSpeed: 100,
      backSpeed: 50,
      backDelay: 2000
    });
  }

})()