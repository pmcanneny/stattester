




/* -------------------------- */
/* --------- jQuery --------- */
/* -------------------------- */



$(document).ready(function() {

$("#5ybutton").toggle(
	function() {
	$("#container").animate({"width":"1400px" }, 300 );
	$("#trade5y").animate({"width":"260px" }, 400 );
	$("#company5y").animate({"width":"260px" }, 400 );
	},
	function() {
	$("#container").animate({"width":"1100px" }, 400 );
	$("#trade5y").animate({"width":"1px" }, 300 );
	$("#company5y").animate({"width":"1px" }, 300 );
	});
	
	
$("#5ytradebutton").toggle(
	function() {
	$("#container").animate({"width":"1400px" }, 300 );
	$("#trade5y").animate({"width":"260px" }, 400 );
	$("#company5y").animate({"width":"260px" }, 400 );
	},
	function() {
	$("#container").animate({"width":"1100px" }, 400 );
	$("#trade5y").animate({"width":"1px" }, 300 );
	$("#company5y").animate({"width":"1px" }, 300 );
	});
	
$("#4ybutton").toggle(
	function() {
	$("#company4y").animate({"width":"130px" }, "fast" );
	},
	function() {
	$("#company4y").animate({"width":"1px" }, "fast" );
	});
	
$("#datain").toggle(
	function() {
	$("#datainlist").animate({"height":"100px" }, "fast" );
	},
	function() {
	$("#datainlist").animate({"height":"20px" }, "fast" );
	});

$("#dataout").toggle(
	function() {
	$("#dataoutlist").animate({"height":"100px" }, "fast" );
	},
	function() {
	$("#dataoutlist").animate({"height":"20px" }, "fast" );
	});
	

	
});




