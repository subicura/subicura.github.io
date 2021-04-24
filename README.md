# subicura.com blog

by jekyll

## requirement

- ruby 2.5.8 (use asdf)
  - `asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git`
  - `asdf install ruby 2.5.8`
- `gem install bundler:2.1.4`
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
