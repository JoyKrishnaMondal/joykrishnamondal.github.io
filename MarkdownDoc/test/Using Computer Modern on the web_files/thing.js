$(function() {
	function resize() {
		var size = $('#size').val()+'px';
		$('#text').css('font-size',size);
	}
	$('#size').on('change',resize);
	resize();
});
