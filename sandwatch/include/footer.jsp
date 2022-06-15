</body>
</html>

<script src="lib/jquery.js"></script>
<script src="lib/popper.js"></script>
<script src="lib/bootstrap.js"></script>
<script src="lib/custom.js"></script>
<script src="lib/dataTables.1.10.20.js"></script>
<script src="lib/jquery.powertip.min.js"></script>
<script src="lib/Chart.min.js"></script>
<script src="lib/xdpick/jquery.datetimepicker.js"></script>
<script src="lib/nxlib.js"></script>

<script>
$(function() {
	$(".north").powerTip({placement: "n"});
	$(".east").powerTip({placement: "e"});
	$(".south").powerTip({placement: "s"});
	$(".west").powerTip({placement: "w"});
	$(".north-west").powerTip({placement: "nw"});
	$(".north-east").powerTip({placement: "ne"});
	$(".south-west").powerTip({placement: "sw"});
	$(".south-east").powerTip({placement: "se"});
	$(".north-west-alt").powerTip({placement: "nw-alt"});
	$(".north-east-alt").powerTip({placement: "ne-alt"});
	$(".south-west-alt").powerTip({placement: "sw-alt"});
	$(".south-east-alt").powerTip({placement: "se-alt"});
});

var langMulti = {
		"decimal" : "",
		"emptyTable" : '<%= translate("No data available in table")%>',
		"info" : '<%= translate("Showing _START_ to _END_ of _TOTAL_ entries")%>',
		"infoEmpty" : '<%= translate("Showing 0 to 0 of 0 entries")%>',
		"search" : '<%= translate("Search")%>',
		"zeroRecords" : '<%= translate("No matching records found")%>',
		"paginate" : {
			"first" : '<%= translate("First")%>',
			"last" : '<%= translate("Last")%>',
			"next" : '<%= translate("Previous")%>',
			"previous" : '<%= translate("Next")%>'
		}
	};

/*
$(document).ready(function() { 
	$("div.alert").fadeIn(300).delay(10000).fadeOut(1000);
	$("div.success").fadeIn(300).delay(10000).fadeOut(1000);
	$("div.info").fadeIn(300).delay(10000).fadeOut(1000);
	$("div.warning").fadeIn(300).delay(10000).fadeOut(1000);
});
*/
</script>