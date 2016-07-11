<!-- #include virtual=/assets/lib/utils.asp -->
<!-- #include virtual=/assets/lib/xml_utils.asp -->
<!-- #include file=inc/check_access.asp -->

<!-- #include file=inc/header.asp -->

<%
	topickey = split(session("t"),"|")(0)
	state = split(session("pub"),"-")(1)

	SQL = "exec spGetStateDifferencesId " & topickey & ", '" & state & "'"
	set rsRulebooks = conn_pub.execute(SQL)
%>

	<div data-role="content" class="jqm-content">

		<h2><%=session("Title")%></h2>

		<p class="jqm-intro">Select one of the rulebooks below to continue.</p>

		<ul data-role="listview" data-inset="true" data-filter="false" data-theme="d" data-divider-theme="d" data-icon="false" class="jqm-list">
			
			<li data-role="list-divider" role="heading" class="ui-li ui-li-divider ui-bar-d ui-first-child"><%=chtml(split(session("t"),"|")(1))%></li>
			<% 
			rbsectnum = ""
			if rsRulebooks.eof and rsRulebooks.bof then 
			
			else
				while not rsRulebooks.eof
					if rbsectnum <> rsRulebooks("rbsectnum") then
				%>
					 
					<li><a href="set.asp?rb=<%=(rsRulebooks("rbsectnum"))%>"><%=chtml(rsRulebooks("rbName"))%>:<br /><%=chtml(rsRulebooks("rbSectName"))%></a></li>

				<% 
						rbsectnum = rsRulebooks("rbsectnum")
					end if

					rsRulebooks.MoveNext
				Wend	
			end if
			%>
		</ul>

	</div><!-- /content -->
	<script type="text/javascript">
		$( document ).ready(function() {
			$(".summary > p").addClass("jqm-intro")
		});
	</script>
<!-- #include file=inc/footer.asp -->
	