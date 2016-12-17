import React, { Component } from 'react'
import { render } from 'react-dom'
import css from './home.scss'
import Header from '../../Layout/Header/Header'
import Footer from '../../Layout/Footer/Footer'
import DevSite from '../../DevSites/Show/Show'
import Autocomplete from '../../Utility/Autocomplete/Autocomplete'
import Carousel from '../../Utility/Carousel/Carousel'
import { debounce } from 'lodash'
import i18n from './locale'

export default class Home extends Component {
  constructor() {
    super()
    this.state = { isMobile: (window.innerWidth < 600) }
    this.autocompleteCallback = (address, autocomplete) => this._autocompleteCallback(address, autocomplete)
    this.handleAutocompleteSelect = (address) => this._handleAutocompleteSelect(address)

    window.addEventListener('resize',
      debounce(() => {
        this.setState({ isMobile: (window.innerWidth < 600) })
      }, 100)
    );
  }
  _autocompleteCallback(address, autocomplete) {
    const googleLocationAutocomplete = new google.maps.places.AutocompleteService()
    const request = { input: address, types: ['address'], componentRestrictions: {country: 'ca'} }
    googleLocationAutocomplete.getPlacePredictions(request, (predictions) => {
      const suggestions = predictions ? predictions.map(function(prediction){ return prediction.description }) : []
      autocomplete.setState({ suggestions })
    })
  }
  _handleAutocompleteSelect(address) {
    const { locale } = document.body.dataset;
    const geocoder = new google.maps.Geocoder()
    geocoder.geocode({'address': address}, (result) => {
      if(result.length > 0){
        const [latitude, longitude] = [result[0].geometry.location.lat(), result[0].geometry.location.lng()]
        Turbolinks.visit(`/${locale}/dev_sites?latitude=${latitude}&longitude=${longitude}`);
      } else {
        Turbolinks.visit(`/${locale}/dev_sites`);
      }
    })
  }
  render() {
    const { isMobile } = this.state;
    const { locale } = document.body.dataset;
    i18n.setLanguage(locale);

    return (
      <div>
        <Header />
        <div className={css.landingContainer}>
          <img src={require('./images/ui.jpg')} alt='Image of a modern city' />
          <div>
            <h1 className={css.title}>{i18n.title}</h1>
            <div className={css.search}>
              <Autocomplete callback={this.autocompleteCallback} placeholder={i18n.enterAddress} type='autocomplete' onSelect={this.handleAutocompleteSelect}/>
            </div>
          </div>
        </div>
        <div className={css.featuredContainer}>
          <h2 className={css.title}>{i18n.featuredDevelopments}</h2>

          <div className={css.featured}>
            <a href={`/${locale}/dev_sites?activeDevSiteId=1822`}><DevSite id={1822} preview={true} horizontal={isMobile} /></a>
            <a href={`/${locale}/dev_sites?activeDevSiteId=1869`}><DevSite id={1869} preview={true} horizontal={isMobile} /></a>
            <a href={`/${locale}/dev_sites?activeDevSiteId=1870`}><DevSite id={1870} preview={true} horizontal={isMobile} /></a>
          </div>

        </div>
        <div className={css.articleContainer}>
          <Carousel>
            <a title={'Go to Milieu\'s article of Zoning 101'} href='https://medium.com/@MilieuCities/zoning-101-a88c1e397455#.du6yt0qgk' target='_blank' className={css.article}>
              <div className={css.type}>Article</div>
              <h2 className={css.title}>Zoning 101</h2>
              <div className={css.summary}>Zoning regulations are the rules of the game if you — or a developer — want to construct a building.</div>
            </a>
            <a title={'Go to Milieu\'s article of Whose streets are we planning?'} href='https://medium.com/@MilieuCities/whose-streets-are-we-planning-88f3ed1bc613#.hv858aafk' target='_blank' className={css.article}>
              <div className={css.type}>Article</div>
              <h2 className={css.title}>Whose streets are we planning?</h2>
              <div className={css.summary}>Transportation planning offers huge opportunities to enable equity.</div>
            </a>
            <a title={'Go to Milieu\'s article of What we learned from pop-up engagement'} href='https://medium.com/@MilieuCities/what-we-learned-from-pop-up-engagement-65cec34fefde#.l84ns3xc6' target='_blank' className={css.article}>
              <div className={css.type}>Article</div>
              <h3 className={css.title}>What we learned from pop-up engagement</h3>
              <div className={css.summary}>Milieu’s on-going goal is to facilitate a human-centered approach to urban planning and development.</div>
            </a>
          </Carousel>
        </div>
      <Footer />
      </div>
    )
  }
}

document.addEventListener('turbolinks:load', () => {
  const home = document.querySelector('#home')
  home && render(<Home/>, home)
})