QUnit.module("select function tests", function() {
    QUnit.test("select single element", function(assert) {
      document.body.innerHTML = '<div id="test-div"></div>';
      const element = select("#test-div");
      assert.ok(element, "Element is selected");
    });
  
    QUnit.test("select multiple elements", function(assert) {
      document.body.innerHTML = '<div class="test-div"></div><div class="test-div"></div>';
      const elements = select(".test-div", true);
      assert.equal(elements.length, 2, "Two elements are selected");
    });
  });
  
  QUnit.module("getRandomImage function tests", function() {
    QUnit.test("getRandomImage returns a string", function(assert) {
      const result = getRandomImage("photog1");
      assert.equal(typeof result, "string", "Result should be a string");
    });
  
    QUnit.test("getRandomImage avoids specified substring", function(assert) {
      const result = getRandomImage("photog1");
      assert.notOk(result.includes("photog1"), "Result should not include 'photog1'");
    });
  });
  