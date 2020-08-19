var list = ''
document
  .querySelectorAll('.study-plans-trail-tree li.tree-item article.tree-item-box')
  .forEach(el => list +=
    '    - [ ] ' +
    el.querySelector('h3').innerText +
    ' [link](' +
    el.querySelector('a.btn').href +
    ')\n'
  );