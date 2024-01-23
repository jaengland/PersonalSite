import { generateAndPlaceTiles } from '../../../site_template/assets/js/utils.js';

describe('generateAndPlaceTiles', () => {
  const mockContainer = {
    innerHTML: '',
    appendChild: jest.fn()
  };

  const mockSelectFn = jest.fn(selector => {
    if (selector === '.tiles-container') {
      return mockContainer;
    }
    return null;
  });

  it('should generate and place tiles correctly', () => {
    const jsonArray = [
      { "image": "img1.png", "technology": "Tech 1", "description": "Desc 1", "confidence": 9.5 },
      { "image": "img2.png", "technology": "Tech 2", "description": "Desc 2", "confidence": 7.5 }
    ];

    generateAndPlaceTiles(jsonArray, mockSelectFn);

    expect(mockSelectFn).toHaveBeenCalledWith('.tiles-container');

    expect(mockContainer.innerHTML).toBe('');

    expect(mockContainer.appendChild).toHaveBeenCalledTimes(2);
  });

  it('should handle stringified JSON array', () => {
    const jsonString = '[{"image": "img1.png", "technology": "Tech 1", "description": "Desc 1", "confidence": 9.5}]';
    generateAndPlaceTiles(jsonString, mockSelectFn);

    expect(mockSelectFn).toHaveBeenCalledWith('.tiles-container');
    expect(mockContainer.appendChild).toHaveBeenCalled();
  });
});
