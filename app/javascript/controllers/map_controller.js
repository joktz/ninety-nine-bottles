import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map"
export default class extends Controller {

  static values = {
    apiKey: String,
    markers: Array
  };

  connect() {
    mapboxgl.accessToken = this.apiKeyValue;
    this.map = new mapboxgl.Map({
      container: 'map', // container ID
      style: 'mapbox://styles/mapbox/streets-v12', // style URL
      zoom: 9, // starting zoom
      projection: 'mercator'
    });
    this.addMarkerstoMap();
    this.fitMapToMarkers();
  }

  addMarkerstoMap() {
    this.markersValue.forEach((marker) => {
      new mapboxgl.Marker()
        .setLngLat([marker.lng, marker.lat])
        .addTo(this.map);
    });
  }

  fitMapToMarkers() {
    const bounds = new mapboxgl.LngLatBounds();
    this.markersValue.forEach((marker) => {
      bounds.extend([marker.lng, marker.lat]);
    });
    this.map.fitBounds(bounds, { padding: 40, maxZoom: 15, duration: 10 });
  }
}
