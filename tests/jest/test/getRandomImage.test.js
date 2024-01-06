import { getRandomImage } from '../../../site_template/assets/js/utils.js';

describe('getRandomImage', () => {
  test('returns a string that does not include the specified substring', () => {
    const substring = 'photog1';
    const result = getRandomImage(substring);
    expect(typeof result).toBe('string');
    expect(result.includes(substring)).toBe(false);
  });
});
