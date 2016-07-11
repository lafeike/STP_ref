<!DOCTYPE html>
<html>
<head>
	<meta charset="utf-8">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title>STP Online - Reference Tool</title>
	<link rel="stylesheet"  href="css/jquery.mobile.min.css">
	<link rel="stylesheet"  href="css/jqm-custom.css">
	<link rel="stylesheet" href="http://fonts.googleapis.com/css?family=Open+Sans:300,400,700">
	<script src="js/jquery.js"></script>
	<script src="js/index.js"></script>
	<script src="js/jquery.mobile.min.js"></script>
	<%
		Response.CacheControl = "no-cache, no-store, must-revalidate"
	%>
	<!-- Google Analytics Tracking -->
	<script type="text/javascript">
		var _gaq = _gaq || [];
		_gaq.push(['_setAccount', 'UA-19972971-1']);
		_gaq.push(['_setDomainName', '.stpub.com']);
		_gaq.push(['_trackPageview']);

		(function() {
		var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
		ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
		var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
		})();
	</script>

	<link rel="shortcut icon" href="/assets/ico/favicon.ico">
</head>

<div data-role="page" class="jqm-demos jqm-demos-home">
	<div data-role="header" class="jqm-header">
		<h1 class="jqm-logo"><img src="img/STP_logo_tagline_colour.png" alt="STP Online"></h1>
		<% if len(Session("pub")) > 0 then %>
		<a href="#" class="jqm-navmenu-link" data-icon="bars" data-iconpos="notext">Navigation</a>
		<!-- #include file=search.asp -->
		<% end if %>

	</div><!-- /header -->

	