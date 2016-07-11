<!-- #include virtual=/assets/lib/utils.asp -->
<!-- #include virtual=/assets/lib/xml_utils.asp -->
<!-- #include file=inc/check_access.asp -->

<!-- #include file=inc/header.asp -->

<%
	acronym = session("pub")
	publ = split(session("pub"),"-")(0)
	state = split(session("pub"),"-")(1)
	if publ = "SDEA" then
		chkPub = "EAF"
	else
		chkPub = "OF"
	end if
	SQL = "select * from tbltopic where acronym = '" & chkPub & "' " &_
		   "and releasenum = (select MAX(releasenum) as ReleaseNum from tblTopic where acronym = '" & chkPub & "')"
	set rsTopicKey = conn_pub.execute(SQL)

%>
	<div data-role="content" class="jqm-content">
		
		<h2><%=session("Title")%></h2>
		<p class="jqm-intro">Select one of the topics below.</p>

		<ul data-role="listview" data-inset="true" data-filter="false" data-theme="d" data-divider-theme="d" data-icon="false" class="jqm-list">
		<%
		if not (rsTopicKey.eof and rsTopicKey.bof) then
			while not rsTopicKey.eof
			
			SQL = "exec spGetStateDifferences " & rsTopicKey("TopicKey") & ", '" & state & "'"
			set rsChkState = conn_pub.execute(SQL)

			if not (rsChkState.eof and rsChkState.bof) then			

		%>
			<li><a href="set.asp?t=<%=(rsTopicKey("topickey"))%>&sd=1"><%=chtml(rsTopicKey("topic"))%></a></li>
		<% 

			end if
			rsTopicKey.movenext
			wend
		end if	
		%>
		
		</ul>

	</div><!-- /content -->

<!-- #include file=inc/footer.asp -->