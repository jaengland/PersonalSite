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

export const loadJsonFile = (filePath) => {
    return fetch(filePath)
        .then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            return response.json();
        })
        .catch(error => {
            console.error('There has been a problem with your fetch operation:', error);
            throw error;
        });
  };

  export const generateAndPlaceTiles = (jsonArray, selectFn) => {
    // Parse the JSON array if it's a string
    const items = typeof jsonArray === 'string' ? JSON.parse(jsonArray) : jsonArray;

    // Sort the items by confidence in descending order
    items.sort((a, b) => b.confidence - a.confidence);

    // Select the container where tiles will be appended
    const container = selectFn('.tiles-container');
    console.log(container);

    // Clear the container before appending new tiles
    container.innerHTML = '';

    // Create and append tiles for each item
    items.forEach(item => {
        const tile = document.createElement('div');
        tile.className = 'tile'; // You can set a CSS class for styling

        tile.innerHTML = `
            <div class="tile-image"><img src="${item.image}" alt="${item.technology}"></div>
            <div class="tile-content">
                <div class="tile-title"><h3>${item.technology}</h3></div>
                <div class="tile-body"><p>${item.description}</p></div>
            </div>
        `;

        container.appendChild(tile);
    });
};