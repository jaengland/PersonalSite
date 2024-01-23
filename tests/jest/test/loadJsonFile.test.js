import { loadJsonFile } from '../../../site_template/assets/js/utils.js';

global.fetch = jest.fn();

describe('loadJsonFile', () => {

  beforeEach(() => {
    fetch.mockClear();
  });

  it('should load and parse JSON file when response is ok', async () => {
    const mockJsonPromise = Promise.resolve({ key: 'value' });
    const mockFetchPromise = Promise.resolve({ 
      ok: true,
      json: () => mockJsonPromise,
    });
    fetch.mockImplementation(() => mockFetchPromise);

    const result = await loadJsonFile('./fixtures/import.json');
    expect(result).toEqual({ key: 'value' });
    expect(fetch).toHaveBeenCalledTimes(1);
    expect(fetch).toHaveBeenCalledWith('./fixtures/import.json');
  });

  it('should throw an error when response is not ok', async () => {
    const mockFetchPromise = Promise.resolve({
      ok: false,
    });
    fetch.mockImplementation(() => mockFetchPromise);

    await expect(loadJsonFile('./fixtures/import.json')).rejects.toThrow('Network response was not ok');
  });

  it('should log an error when fetch operation fails', async () => {
    fetch.mockImplementation(() => Promise.reject('Network error'));

    console.error = jest.fn(); 

    await loadJsonFile('./fixtures/import.json');
    expect(console.error).toHaveBeenCalledWith('There has been a problem with your fetch operation:', 'Network response was not ok');
  });
});
