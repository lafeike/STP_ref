
<div data-role="panel" class="jqm-nav-panel jqm-navmenu-panel" data-position="left" data-display="reveal" data-theme="c">
    <ul data-role="listview" data-theme="d" data-divider-theme="d" data-icon="false" data-global-nav="demos" class="jqm-list">
        <li data-role="list-divider">STP Pocket Reference</li>
		<li><a href="index.asp">Home</a></li>
        <li><a href="/logoff.asp" rel="external">Logoff</a></li>
        <%
            ' build out a breadcrumb style navigation
            if session("pub") <> "" then
                if InStr(session("pub"),"-") > 0 then
                    file_name = replace(session("pub"),"SDEA-","SDE_")
        %>          

                    <li><a target="_newPDF" href='/pubs/ENV/<%=session("pub")%>/<%=file_name%>.pdf'>Download PDF</a></li>
        <%
                end if
        %>
                <li><a href='set.asp?pub=<%=session("pub")%>'><%=session("title")%></a></li>
        <%
            end if
            if session("t") <> "" then
        %>
                <li><a href='set.asp?t=<%=split(session("t"),"|")(0)%>'><%=split(session("t"),"|")(1)%></a></li>
        <%
            end if
            if session("r") <> "" then
        %>
                <li><a href='set.asp?r=<%=split(session("r"),"|")(0)%>'><%=split(session("r"),"|")(1)%></a></li>
        <%
            end if
            if session("s") <> "" then
        %>
                <li><a href='set.asp?s=<%=split(session("s"),"|")(0)%>'><%=split(session("s"),"|")(1)%></a></li>
        <%
            end if 
        %>
        <!-- <li><a href="#">Logout</a></li> -->

        <% if not (getpubs.eof and getpubs.bof) then %>
        <li data-role="list-divider">My Publications</li>
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
				getPubs.movenext
			wend
		%>
		<% end if %>
    </ul>
</div><!-- /panel -->