<% 

Session("pub") = ""
Session("title") = ""
Session("sdid") = ""
Session("state") = ""
Session("t") = ""
Session("r") = ""
Session("s") = ""
Session("p") = ""
%>
<!-- #include virtual=/assets/lib/utils.asp -->
<!-- #include file=inc/check_access.asp -->

<!-- #include file=inc/header.asp -->

	<div data-role="content" class="jqm-content">

		<h2>STP Online Pocket Reference</h2>

		<p class="jqm-intro">The STP Pocket Reference puts your EH&amp;S content at your finger tips.  To get started select a publication below.</p>

		<ul data-role="listview" data-inset="true" data-filter="true" data-theme="d" data-divider-theme="d" data-icon="false" data-filter-placeholder="Filter Publications..." data-global-nav="demos" class="jqm-list">

			<% if not (getpubs.eof and getpubs.bof) then %>
	        <%
	        	while not getpubs.eof
	        		if getpubs("categoryName") = "International" then
						pub_acro = left(getPubs("acronym"),len(getPubs("acronym"))-2)
						pub_acro = right(pub_acro,len(pub_acro)-2)
						if pub_acro = "CANBC" then
							pub_acro = "BC"
						
						elseif pub_acro = "CANNS" then
							pub_acro = "NS"
						
						elseif pub_acro = "AUSNT" then
							pub_acro = "NT"
						
						elseif pub_acro = "AUSQ" then
							pub_acro = "QLD"

						elseif pub_acro = "AUSSA" then
							pub_acro = "SA"

						elseif pub_acro = "AUSWA" then
							pub_acro = "AUSW"

						elseif pub_acro = "NZL" then
							pub_acro = "NZ"

						end if
					else
						pub_acro = getPubs("acronym")
					end if
	        %>

				<li data-section="Widgets" data-filtertext="<%=getPubs("Acronym")%> <%=getPubs("Title")%>"><a href="set.asp?pub=<%=pub_acro%><%if len(getPubs("StateDifferenceID")) > 0 then%>&sdid=<%=getPubs("StateDifferenceID")%><%end if%>"><%=getPubs("Acronym")%>: <%=getPubs("Title")%></a></li>
				<%
				'if getPubs("StateDifferenceID") <> "" then 
                ''	SQL = "exec checkPub " & session("stp_userid") & "," & session("stp_companyid") & "," & getPubs("StateDifferenceID")
                ''	Set checkPub = conn.Execute(SQL) 
                	
                ''	if not(checkpub.eof and checkpub.bof) then

                 ''     sql = "select acronym, right(title, len(title) - charindex(':', title)) as State from Publications where Code = " & getPubs("StateDifferenceID")
				''	  Set rsSD = conn.Execute(SQL) 
                 ''     	if not (rsSD.eof and rsSD.bof) then  

	             ''         	While Not rsSD.EOF
	                %>
	                		<!-- 
	                			<li data-section="Widgets" data-filtertext="<%'=rsSD("Acronym")%> <%'=rsSD("State")%>"><a href="set.asp?pub=<%'=rsSD("Acronym")%>&sd=1"><%'=rsSD("Acronym")%>: <%'=rsSD("State")%></a></li> 
	                		-->
	                
	                <%			
	             
	              ''  			rsSD.movenext
	             ''   		wend
                ''		end if
                ''	end if
                'end if
                %>
			<%
					getPubs.movenext
				wend
				getPubs.movefirst
			%>
			<% end if %>
        </ul>

	</div><!-- /content -->

<!-- #include file=inc/footer.asp -->