// Algolia
var client = algoliasearch('SM5SAVK5I5', 'd689be359feed27adddd4775aca3e86b');
var index = client.initIndex('Ingredient');
index.search('something', { hitsPerPage: 10, page: 0 })
  .then(function searchDone(content) {
    console.log(content)
  })
  .catch(function searchFailure(err) {
    console.error(err);
  });

