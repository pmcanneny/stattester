

/* -------------------------- */
/* --------- jQuery --------- */
/* -------------------------- */

$(document).ready(function() {

$("#5ybutton").toggle(
	function() {
	$("#container").animate({"width":"1500px" }, 300 );
	$("#trade5y").animate({"width":"300px" }, 400 );
	$("#company5y").animate({"width":"300px" }, 400 );
	},
	function() {
	$("#container").animate({"width":"1200px" }, 400 );
	$("#trade5y").animate({"width":"1px" }, 300 );
	$("#company5y").animate({"width":"1px" }, 300 );
	});
	
$("#5ytradebutton").toggle(
	function() {
	$("#container").animate({"width":"1500px" }, 300 );
	$("#trade5y").animate({"width":"300px" }, 400 );
	$("#company5y").animate({"width":"300px" }, 400 );
	},
	function() {
	$("#container").animate({"width":"1200px" }, 400 );
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


$("#datainlist").hover(
	function() {
	$("#datainlist").animate({"height":"190px" }, "fast" );
	},
	function() {
	$("#datainlist").animate({"height":"20px" }, "fast" );
	});

$("#dataoutlist").hover(
	function() {
	$("#dataoutlist").animate({"height":"100px" }, "fast" );
	},
	function() {
	$("#dataoutlist").animate({"height":"20px" }, "fast" );
	});
	
});


/* -------------------------- */
/* --------- Custom --------- */
/* -------------------------- */

function getChart(c) {
	$("div.topchart").animate({"top":"280px" }, 300 );
	$("div.bottomchart").removeClass("bottomchart").addClass("hiddenchart");
	$("div.topchart").removeClass("topchart").addClass("bottomchart");
	$("#chart"+c+"container").css("top","1px");
	$("#chart"+c+"container").removeClass("hiddenchart").addClass("topchart");
	}

