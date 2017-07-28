# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

init_distance_syncer = (start_meter) ->
	end_meter_input = document.getElementById('drive-end-meter')
	distance = document.getElementById('drive-distance')
	end_meter_input.addEventListener 'change', (evt) ->
		distance.textContent = parseInt(evt.target.value) - start_meter
		return
	return

window.init_distance_syncer = init_distance_syncer