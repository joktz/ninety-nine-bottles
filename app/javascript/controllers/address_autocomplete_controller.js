import { Controller } from "@hotwired/stimulus";
import MapboxGeocoder from "@mapbox/mapbox-gl-geocoder";

// Connects to data-controller="origin-autocomplete"
export default class extends Controller {
  static values = { apiKey: String };

  static targets = [ "origin" ];

  connect() {
    console.log("Autocomplete connected");
    this.geocoder = new MapboxGeocoder({
      accessToken: this.apiKeyValue,
      types: "country,region,place,postcode,locality,neighborhood, address",
    });
    this.geocoder.addTo(this.element);
    this.geocoder.on("result", event => this.#setInputValue(event));
    this.geocoder.on("clear", () => this.#clearInputValue());
  }

  #setInputValue(event) {
    console.log(event.result)
    const selectedPlace = event.result.place_name
    this.originTarget.value = selectedPlace
  }

  #clearInputValue() {
    this.originTarget.value = ""
  }
}
