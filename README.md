# subicura.com blog

by jekyll

## requirement

- ruby 2.5
- bundler 1.17 (`gem install bundler -v '1.17.3'`)
  - `bundle install`

## test

```
$ bundle exec jekyll serve
$ bundle exec jekyll serve --incremental
```

## deploy

```
npm install
npm run deploy
```

## asciinema player

```
<div class="asciinema-player-section">
  <asciinema-player src="{{ site.url }}/assets/asciinema/2017-01-19-docker-guide-for-beginners-2/docker-install-on-linux.json" poster="data:text/plain,$ # Docker Install (ubuntu)" speed="2"></asciinema-player>
  <figcaption>Docker Install (ubuntu)</figcaption>
</div>
```
