# Uutiskirjepohja

## Näin luot uutiskirjeen
Ensin luo uusi tyhjä tekstitiedosto uutta uutiskirjettä varten: `_posts/2015-05-05-uusi-uutiskirjeeni.md`.

Tämän jälkeen kirjoita uutiskirjeen sisältö. Muotoilussa käytetään Markdownia, mutta mukaan voi sisällyttää myös HTML-koodia, kunhan sähköpostiohjelmien rajoitukset huomioidaan.

Kuvat kopioidaan hakemistoon `images/original`. Uutiskirjettä käännettäessä kuvat muutetaan automaattisesti oikeaan leveyteen (580px, muokattavissa `_config.yml` -tiedostosta).

Kun pohja on valmis, tai sitä tahdotaan esikatsella, suoritetaan komento

    make build

joka kääntää valmiin HTML-tiedoston. Tiedosto löytyy polusta `_site/2015/05/05/uusi-uutiskirjeeni.html`. Tämän pohjan voi avata esimerkiksi nettiselaimeen.

Varsinaisen sähköpostiin liitettävän pohjan voi luoda komennolla `make _site/2015/05/05/uusi-uutiskirjeeni.html`. Eli `make`-komennolle kerrotaan `make build` komennon tuottaman tiedoston polku. Tämän jälkeen tehdään tarvittavat muuntotoimenpiteet, ja ohjelma tulostaa lopullisten tiedostojen polut.


## Sivupohjan muokkaaminen
Sivupohjan muokkaaminen tyylien osalta tapahtuu tiedoston `styles.sass` kautta ja HTML-pohjan tiedostosta `_layouts/_default.html`.


## Dependencies

    apt-get install bundler
    bundle install
