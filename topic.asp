<!-- #include virtual=/assets/lib/utils.asp -->
<!-- #include virtual=/assets/lib/xml_utils.asp -->
<!-- #include file=inc/check_access.asp -->

<!-- #include file=inc/header.asp -->

<%
	acronym = session("pub")
	SQL = "select releasenum from tblTopic t " &_
		   "where t.acronym = '" & acronym & "' and topic <> 'Wetlands' " &_
		   "and releasenum = (select DISTINCT top 1 releasenum from tbltopic where acronym = '" & acronym & "' order by releasenum desc)" &_
	       "order by t.topic"
	set rsTopicKey = conn_pub.execute(SQL)

	SQL = "select * from tbltopic t where t.acronym = '" & acronym & "' and releasenum = " & rsTopicKey("releasenum")
	set rsTopics = conn_pub.execute(SQL)
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
		<p class="jqm-intro">Select one of the topics below.</p>

		<ul data-role="listview" data-inset="true" data-filter="false" data-theme="d" data-divider-theme="d" data-icon="false" class="jqm-list">
			<% 
			if rsTopics.eof and rsTopics.bof then 
			else
				while not rsTopics.eof
				%>
					<li><a href="set.asp?t=<%=(rsTopics("topickey"))%>"><%=chtml(rsTopics("topic"))%></a></li>
				<% 
					rsTopics.MoveNext
				Wend	
			end if
			%>
		</ul>

	</div><!-- /content -->

<!-- #include file=inc/footer.asp -->