<!-- #include virtual=/assets/lib/utils.asp -->
<!-- #include virtual=/assets/lib/xml_utils.asp -->
<!-- #include file=inc/check_access.asp -->

<!-- #include file=inc/header.asp -->

<%
	topickey = split(session("t"),"|")(0)

	SQL = "select * from tblRulebook rb where rb.topickey = '" & topickey & "'"
	set rsRulebooks = conn_pub.execute(SQL)
%>

	<div data-role="content" class="jqm-content">

		<% if len(Session("sdid")) > 0 then %>
			<a 	href="#statediff" 
				style="float:right" 
				data-icon="plus" 
				data-role="button" 
				data-inline="true" 
				data-mini="true">
			State Difference</a>
		<% end if %>
		
		<h2><%=session("Title")%></h2>
		
		<% if len(rsRulebooks("summary")) > 0 then 
			summary = replace(HTMLDecode(rsRulebooks("summary")),"<b>Summary: </b>","")
		%>
			<div class="summary">
				<%=removeLinks(summary)%>
			</div>
		<% end if %>

		<p class="jqm-intro">Select one of the rulebooks below to continue.</p>

		<ul data-role="listview" data-inset="true" data-filter="false" data-theme="d" data-divider-theme="d" data-icon="false" class="jqm-list">
			
			<li data-role="list-divider" role="heading" class="ui-li ui-li-divider ui-bar-d ui-first-child"><%=chtml(split(session("t"),"|")(1))%></li>
			<% 
			if rsRulebooks.eof and rsRulebooks.bof then 
			else
				while not rsRulebooks.eof
				%>
					<li><a href="set.asp?r=<%=(rsRulebooks("rbkey"))%>"><%=chtml(rsRulebooks("rbName"))%></a></li>
				<% 
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
	