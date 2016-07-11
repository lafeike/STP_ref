<!-- #include virtual=/assets/lib/utils.asp -->
<!-- #include virtual=/assets/lib/xml_utils.asp -->
<!-- #include file=inc/check_access.asp -->

<!-- #include file=inc/header.asp -->

<%
	rbkey = split(session("r"),"|")(0)

	SQL = "select * from tblrbSection s where s.rbkey = '" & rbkey & "' and (rbsectname <> 'No Similar Federal Regulation' and rbsectname <> 'No Corresponding Federal Checklist') "
	set rsSec = conn_pub.execute(SQL)
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
		<p class="jqm-intro">Select one of the sections below to continue.</p>
		

		<ul data-role="listview" data-inset="true" data-filter="false" data-theme="d" data-divider-theme="d" data-icon="false" class="jqm-list">
			<li data-role="list-divider" role="heading" class="ui-li ui-li-divider ui-bar-d ui-first-child"><%=chtml(split(session("r"),"|")(1))%></li>
			<% 
			if rsSec.eof and rsSec.bof then 
			else
				while not rsSec.eof
				%>
					<li><a href="set.asp?s=<%=(rsSec("rbSectKey"))%>"><%=rsSec("rbSectName")%></a></li>
				<% 
					rsSec.MoveNext
				Wend	
			end if
			%>
		</ul>

	</div><!-- /content -->

<!-- #include file=inc/footer.asp -->