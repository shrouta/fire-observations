var sliderControl = null;

var map = L.map('mapid').setView([41.96, -122.54], 12);

var fire = $.ajax({
	url:"file:///Users/Marple/Dropbox%20(Personal)/Information_visualization/fire/leaflet/data/fire.geojson",
	dataType: "json",
	success: console.log("Fire data successfully loaded."),
	error: function (xhr) {
		alert(xhr.statusText)
	}
})

function getValue(x) {
	return 	x > 350 ? "#99000d" :
		   	x >	333 ? "#cb181d" :
		   	x > 316 ? "#ef3b2c" :
		   	x > 299 ? "#fb6a4a" :
		   	x > 282 ? "#fc9272" :
		   	x > 265 ? "#fcbba1" :
		   			  "#fee5d9";   	
}

function style (feature) {
	return {
		"color": getValue(feature.properties.bright),
		"stroke": false,
		"fillOpacity": 0.5,
		"radius": 15
	};
}

$.when(fire).done(function() {
	
	var basemap = L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token=pk.eyJ1Ijoic2hyb3V0YSIsImEiOiJjampoY25ubXAwMzh0M3BreGRrY3V4dzRxIn0.2NHcKHH_S4uugonmZO6LOA', {
		maxZoom: 18,
		attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/">OpenStreetMap</a> contributors, ' +
			'<a href="https://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, ' +
			'Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
		id: 'mapbox.streets'
	}).addTo(map);
	
	var recentFire = L.geoJSON(fire.responseJSON, {
		pointToLayer: function (feature, latlng) {
			return L.circleMarker(latlng, style(feature));
		}
	}).addTo(map);
	
	var sliderControl=L.control.sliderControl({
		position: "topright",
		layer: recentFire,
		range: true
	});
	
	map.addControl(sliderControl);
	sliderControl.startSlider();
});