# subicura.com blog

by jekyll

## test

```
$ bundle exec jekyll serve
$ bundle exec jekyll serve --incremental
```

## build & deploy

```
(source)$ bundle exec jekyll build
(source)$ git add .
(source)$ git commit -a
(source)$ git branch -D master
(source)$ git checkout -b master
(master)$ git filter-branch --subdirectory-filter _site/ -f
(master)$ git push --all
(source)$ git checkout source
```
