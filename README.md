# Uutiskirjepohja

## Näin luot uutiskirjeen
Ensin luo uusi tyhjä tekstitiedosto uutta uutiskirjettä varten: `_posts/2015-05-05-uusi-uutiskirjeeni.md`.

Tämän jälkeen kirjoita uutiskirjeen sisältö. Muotoilussa käytetään Markdownia, mutta mukaan voi sisällyttää myös HTML-koodia, kunhan sähköpostiohjelmien rajoitukset huomioidaan.

Kun pohja on valmis, tai sitä tahdotaan esikatsella, suoritetaan komento

    make

joka kääntää valmiin HTML-tiedoston. Tiedosto löytyy polusta `_site/2015/05/05/uusi-uutiskirjeeni.html`.


## Sivupohjan muokkaaminen
Sivupohjan muokkaaminen tyylien osalta tapahtuu tiedoston `styles.sass` kautta ja HTML-pohjan tiedostosta `_layouts/_default.html`.


## Työkaluja

 - [CSS Inliner Tool](http://templates.mailchimp.com/resources/inline-css/)


## Dependencies

    apt-get install bundler
    bundle install
