export const selectFn = (el, all = false) => {
    el = el.trim();
    return all ? [...document.querySelectorAll(el)] : document.querySelector(el);
};

export const getRandomImage = (substring) => {
    const images = [
        'assets/img/photog1.jpg',
        'assets/img/photog2.jpg',
        'assets/img/photog3.jpg',
    ];
    let randomImage;
    do {
        randomImage = images[Math.floor(Math.random() * images.length)];
    } while (randomImage.includes(substring));
    return randomImage;
};