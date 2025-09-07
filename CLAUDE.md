# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Jekyll-based technical blog hosted on GitHub Pages (subicura.com). The blog features articles about Docker, Kubernetes, and various development topics.

## Development Commands

### Local Development

```bash
# Install dependencies (first time setup)
bundle install
npm install

# Run local Jekyll server
bundle exec jekyll serve
# Or with incremental builds for faster reloading
bundle exec jekyll serve --incremental
```

### Deployment

```bash
# Deploy to GitHub Pages (master branch)
npm run deploy
# This runs: jekyll build → gh-pages -d _site -b master
```

## Architecture & Key Components

### Jekyll Configuration

- **Main config**: `_config.yml` - Contains site settings, plugins, and social media configuration
- **Ruby version**: 3.2.9 (via asdf)
- **Node version**: 22.19.0 (via asdf)
- **Deployment branch**: `master` (GitHub Pages)
- **Source branch**: `source` (development)

### Content Structure

- **Posts**: `_posts/` - Blog posts in markdown format (YYYY-MM-DD-title.markdown)
- **Layouts**: `_layouts/` - HTML templates (default, page, post)
- **Includes**: `_includes/` - Reusable HTML components
- **Assets**:
  - `assets/article_images/` - Images for blog posts
  - `assets/asciinema/` - Terminal recordings
  - `assets/og/` - Open Graph images

### Key Jekyll Plugins

- `jekyll-paginate` - Pagination support
- `jekyll-sitemap` - Auto-generates sitemap
- `jekyll-toc` - Table of contents generation
- `jekyll_picture_tag` - Responsive image generation with WebP support
- `jemoji` - GitHub-style emoji support

### Special Features

#### Asciinema Player Integration

For terminal recordings in blog posts:

```html
<div class="asciinema-player-section">
  <asciinema-player
    src="{{ site.url }}/assets/asciinema/[post-date]/[recording].json"
    poster="data:text/plain,$ # Title"
    speed="2"
  ></asciinema-player>
  <figcaption>Description</figcaption>
</div>
```

#### Image Handling

Uses `jekyll_picture_tag` for responsive images with WebP format support. Configuration in `_data/picture.yml`.

### Blog Post Workflow

1. Create new post in `_posts/` with format: `YYYY-MM-DD-title.markdown`
2. Add images to `assets/article_images/YYYY-MM-DD-title/`
3. Add Open Graph image to `assets/og/` if needed
4. Test locally with `bundle exec jekyll serve`
5. Deploy with `npm run deploy` from `source` branch

### Important Notes

- The site deploys to `master` branch via `gh-pages` package
- Development happens on `source` branch
- Site uses Utterances for comments (GitHub issues-based)
- Analytics: Google Analytics & Google Tag Manager configured
