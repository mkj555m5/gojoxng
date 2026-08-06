# About GojoXNG

GojoXNG is a [metasearch engine] based on [SearXNG], aggregating the results
of other {{link('search engines', 'preferences')}} while not storing
information about its users.

GojoXNG is driven by the open-source community and built on the SearXNG
project, which is free software licensed under AGPL-3.0-or-later.

## Why use GojoXNG?

- GojoXNG does not offer personalized results like Google, but it does not
  generate a profile about you either.
- GojoXNG does not care about what you search for, never shares anything with
  a third-party, and cannot be used to compromise you.
- GojoXNG is free software; the code is 100% open, and everyone is welcome to
  make it better.

If you care about privacy, want to be a conscious user, or otherwise believe
in digital freedom, make GojoXNG your default search engine or run it on your
own server!

## Privacy features

GojoXNG is configured with privacy as the top priority:

- **No tracking**: We do not track your searches or store your IP address.
- **No logs**: Search queries are sent via POST to keep them out of server logs.
- **Image proxy**: Images are proxied through the server to hide your IP.
- **No metrics**: Usage statistics collection is disabled.
- **No referrer**: Your browser never sends referrer information.
- **Noindex**: Search result pages are not indexed by search engines.

## How do I set it as the default search engine?

GojoXNG supports [OpenSearch]. For more information on changing your default
search engine, see your browser's documentation:

- [Firefox]
- [Microsoft Edge]
- [Chromium]-based browsers only add websites that the user navigates to
  without a path.

## How does it work?

GojoXNG is a customized fork of [SearXNG], which is itself a fork of the
well-known [searx] [metasearch engine]. It provides basic privacy by mixing
your queries with searches on other platforms without storing search data.

## How can I make it my own?

GojoXNG appreciates your concern regarding logs, so take the code from the
[SearXNG sources] and run it yourself!

Add your instance to the [list of public
instances]({{get_setting('brand.public_instances')}}) to help other people
reclaim their privacy and make the internet freer. The more decentralized the
internet is, the more freedom we have!

## Credits

- **GojoXNG branding**: Original anime-style mascot design
- **Base engine**: [SearXNG](https://github.com/searxng/searxng)
- **License**: AGPL-3.0-or-later


[SearXNG sources]: {{GIT_URL}}
[SearXNG]: https://github.com/searxng/searxng
[#searxng:matrix.org]: https://matrix.to/#/#searxng:matrix.org
[SearXNG docs]: {{get_setting('brand.docs_url')}}
[searx]: https://github.com/searx/searx
[metasearch engine]: https://en.wikipedia.org/wiki/Metasearch_engine
[Weblate]: https://translate.codeberg.org/projects/searxng/
[Seeks project]: https://beniz.github.io/seeks/
[OpenSearch]: https://github.com/dewitt/opensearch/blob/master/opensearch-1-1-draft-6.md
[Firefox]: https://support.mozilla.org/en-US/kb/add-or-remove-search-engine-firefox
[Microsoft Edge]: https://support.microsoft.com/en-us/help/4028574/microsoft-edge-change-the-default-search-engine
[Chromium]: https://www.chromium.org/tab-to-search
