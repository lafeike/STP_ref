<!-- #include virtual=/assets/lib/utils.asp -->
<!-- #include file=inc/check_access.asp -->

<!-- #include file=inc/header.asp -->
<%

	topickey = split(session("t"),"|")(0)
	state = split(session("state"),"-")(1)
	rbSec = split(session("s"),"|")(0)

	SQL = "select paranum, question, rbSectName, rbsectNum, paraid, rbSectID from tblrbParagraph p left outer join tblrbSection s on s.rbSectKey = p.rbSectKey " &_
		  "where p.rbSectKey = '" & rbSec & "' ORDER BY rbparakey"
	set rsPara = conn_pub.execute(SQL)

	if session("p") <> "" then
		para = session("p")
	else
		para = rsPara("sdKey")
	end if
	if inStr(session("p"),".") > 0 then
		response.redirect("/ref/para.asp")
	end if

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
		
		<h4><%=rsPara("rbSectName")%></h4>
		
		<% 
		SQL = "SELECT	t.acronym,  t.releaseNum, t.topic, "&_
		"			sdr.slID, "&_
		"			sd.stateDiff, sd.sdKey, "&_
		"			sdt.sdType, "&_
		"			states.stateCode, states.stateName "&_
		"	FROM tblTopic t "&_
		"	INNER JOIN (select acronym, max(releaseNum) as releaseNum "&_
		"				from tblTopic t "&_
		"				where acronym in ('SDE','SDO') "&_
		"				group by acronym) a ON   "&_
		"				a.acronym = t.acronym AND t.releaseNum = a.releaseNum "&_
		"	LEFT OUTER JOIN tblStateDifferences sd on sd.topicKey = t.topicKey "&_
		"	LEFT OUTER JOIN tblSDType sdt on sdt.sdTypeKey = sd.sdTypeKey "&_
		"	LEFT OUTER JOIN tblStates states on states.stateKey = sd.stateKey "&_
		"	LEFT OUTER JOIN tblSDReferences sdr on sdr.sdKey = sd.sdKey "&_
		"	WHERE 1 = 1 "&_
		"		AND sd.sdkey = '" & Session("p") & "' "&_
		"		AND states.stateCode in ('" & state & "') "&_
		"	Order by t.acronym, sdt.sdType"
		set getSD = conn_pub.execute(SQL)

		if not (getSD.eof and getSD.bof) then 
			%>
				<p><a name="<%=getSD("stateCode")%>"></a><b><%=getSD("stateName")%></b><br><%=replace(removeHTML(HTMLDecode(getSD("statediff"))),"State Difference:","")%></p>
				
			<% 
		end if
		%>

		<ul data-role="listview" data-inset="true" data-filter="false" data-theme="d" data-divider-theme="d" data-icon="false" class="jqm-list">
			<li data-role="list-divider" role="heading" class="ui-li ui-li-divider ui-bar-d ui-first-child"><%=rsPara("rbSectName")%></li>
			<% 
			if len(session("state")) > 0 then
				state = split(session("state"),"-")(1)
				SQL = "SELECT	t.acronym,  t.releaseNum, t.topic, "&_
					"			sdr.slID, "&_
					"			sd.stateDiff, sd.sdKey, "&_
					"			sdt.sdType, "&_
					"			states.stateCode, states.stateName "&_
					"	FROM tblTopic t "&_
					"	INNER JOIN (select acronym, max(releaseNum) as releaseNum "&_
					"				from tblTopic t "&_
					"				where acronym in ('SDE','SDO') "&_
					"				group by acronym) a ON   "&_
					"				a.acronym = t.acronym AND t.releaseNum = a.releaseNum "&_
					"	LEFT OUTER JOIN tblStateDifferences sd on sd.topicKey = t.topicKey "&_
					"	LEFT OUTER JOIN tblSDType sdt on sdt.sdTypeKey = sd.sdTypeKey "&_
					"	LEFT OUTER JOIN tblStates states on states.stateKey = sd.stateKey "&_
					"	LEFT OUTER JOIN tblSDReferences sdr on sdr.sdKey = sd.sdKey "&_
					"	WHERE 1 = 1 "&_
					"		AND sdr.slID = '" & rsPara("rbSectID") & "' "&_
					"		AND states.stateCode in ('" & state & "') "&_
					"	Order by t.acronym, sdt.sdType"
				set getSD = conn_pub.execute(SQL)	
				if not(getSD.eof and getSD.bof) then
					while not getSD.eof
						%>
						
						<li <% if int(para) = int(getSD("sdKey")) then %>data-theme="b"<% end if %>>
							<a href="set.asp?sdKey=<%=getSD("sdKey")%>">
							<span style="float:right">
							<% if getSD("sdtype") = "Auditable_Partial" or getSD("sdtype") = "Auditable_Full" then %>
								Audit
							<% elseif getSD("sdtype") = "Applicability" then %>
								Applicability
							<% elseif getSD("sdtype") = "ExternalRef" then %>
								External
							<% elseif getSD("sdtype") = "GeneralInfo" then %>
								Info	
							<% end if %>
							</span>
							<%=state & "-" & rsPara("rbsectNum")%>: <%=pull_citation(HTMLDecode(getSD("statediff")))%>
							</a>
						
						</li>
						<%
						getSD.MoveNext
					wend
				end if
			end if
			
			if rsPara.eof and rsPara.bof then 
			else
				while not rsPara.eof
				%>
					<li <% if para = rsPara("paraNum") then %>data-theme="b"<% end if %>><a href="set.asp?p=<%=rsPara("paraNum")%>"><%=rsPara("paraNum")%>: <%=pull_citation(HTMLDecode(rsPara("question")))%></a></li>
				<% 
					if len(session("state")) > 0 then
						state = split(session("state"),"-")(1)
						SQL = "SELECT	t.acronym,  t.releaseNum, t.topic, "&_
							"			sdr.slID, "&_
							"			sd.stateDiff, sd.sdKey, "&_
							"			sdt.sdType, "&_
							"			states.stateCode, states.stateName "&_
							"	FROM tblTopic t "&_
							"	INNER JOIN (select acronym, max(releaseNum) as releaseNum "&_
							"				from tblTopic t "&_
							"				where acronym in ('SDE','SDO') "&_
							"				group by acronym) a ON   "&_
							"				a.acronym = t.acronym AND t.releaseNum = a.releaseNum "&_
							"	LEFT OUTER JOIN tblStateDifferences sd on sd.topicKey = t.topicKey "&_
							"	LEFT OUTER JOIN tblSDType sdt on sdt.sdTypeKey = sd.sdTypeKey "&_
							"	LEFT OUTER JOIN tblStates states on states.stateKey = sd.stateKey "&_
							"	LEFT OUTER JOIN tblSDReferences sdr on sdr.sdKey = sd.sdKey "&_
							"	WHERE 1 = 1 "&_
							"		AND sdr.slID = '" & rsPara("paraID") & "' "&_
							"		AND states.stateCode in ('" & state & "') "&_
							"	Order by t.acronym, sdt.sdType"
						set getSD = conn_pub.execute(SQL)	
						if not(getSD.eof and getSD.bof) then
							while not getSD.eof
								%>
								
								<li  <% if int(para) = int(getSD("sdKey")) then %>data-theme="b"<% end if %>>
									<a href="set.asp?sdKey=<%=getSD("sdKey")%>">
									<span style="float:right">
									<% if getSD("sdtype") = "Auditable_Partial" or getSD("sdtype") = "Auditable_Full" then %>
										Audit
									<% elseif getSD("sdtype") = "Applicability" then %>
										Applicability
									<% elseif getSD("sdtype") = "ExternalRef" then %>
										External
									<% elseif getSD("sdtype") = "GeneralInfo" then %>
										Info	
									<% end if %>
									</span>
									<%=state & "-" & rsPara("paraNum")%>: <%=pull_citation(HTMLDecode(getSD("statediff")))%>
									</a>
								
								</li>
								<%
								getSD.MoveNext
							wend
						end if
					end if

					rsPara.MoveNext
				Wend	
			end if
			%>
		</ul>
	</div><!-- /content -->

<!-- #include file=inc/footer.asp -->