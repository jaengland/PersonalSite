/**
 * @jest-environment jsdom
 */
import { selectFn } from '../../../site_template/assets/js/utils.js';

describe('selectFn', () => {
  beforeEach(() => {
    // Clear all mocks before each test
    jest.clearAllMocks();
  });

  test('selects a single element', () => {
    document.querySelector = jest.fn().mockReturnValue('single-element');
    const result = selectFn('#single');
    expect(document.querySelector).toHaveBeenCalledWith('#single');
    expect(result).toBe('single-element');
  });

  test('selects multiple elements', () => {
    document.querySelectorAll = jest.fn().mockReturnValue(['element1', 'element2']);
    const result = selectFn('.multiple', true);
    expect(document.querySelectorAll).toHaveBeenCalledWith('.multiple');
    expect(result).toEqual(['element1', 'element2']);
  });
});
