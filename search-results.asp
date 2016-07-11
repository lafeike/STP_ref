<!-- #include virtual=/assets/lib/utils.asp -->
<!-- #include file=inc/check_access.asp -->

<!-- #include file=inc/header.asp -->
<%
rc = 0
sdrc = 0
	acronym = session("pub")
		
	SQL = 	"SELECT " &_
			"  t.topicKey, t.acronym, t.releaseNum, t.topic, " &_
			"  r.rbKey, r.rbName, " &_							
			"  s.rbSectKey, s.rbSectNum, s.rbSectName, " &_
			"  p.paraNum, p.question, p.guideNote " &_
			"FROM tblTopic t " &_
			"INNER JOIN (select acronym, max(releaseNum) as releaseNum " &_
			"			from tblTopic t " &_
			"			group by acronym) a ON " &_ 
			"  a.acronym = t.acronym AND t.releaseNum = a.releaseNum " &_
			"LEFT OUTER JOIN tblRulebook r on t.topickey = r.topickey " &_
			"LEFT OUTER JOIN tblRbSection s on s.rbKey = r.rbKey " &_
			"LEFT OUTER JOIN tblRbParagraph p on p.rbSectKey = s.rbSectKey " &_
			"WHERE 1 = 1 " &_
			"	AND (p.question like '%" & request("search") & "%' or p.guideNote like '%" & request("search") & "%') " &_
			"	AND t.acronym in ('" & acronym & "') " &_
			"order by t.acronym"
	set rsSearch = conn_pub.execute(SQL)

	'rsSearch.filter = "stateDiff LIKE '*"&  &"*'"
	'rsSearch.filter = "stateDiff LIKE '*State Difference*'"
	
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

		<h2>STP Online Pocket Reference</h2>

		<h4>Search Results for <em><%=request("search")%></em></h4>
		<ul data-role="listview" data-inset="true" data-filter="false" data-theme="d" data-divider-theme="d" data-icon="false" class="jqm-list">
		<%
			if not (rsSearch.eof and rsSearch.bof) then
				Sectionheader = ""
				SectionheaderSD = ""
				while not rsSearch.eof
					if rsSearch("rbSectName") <> Sectionheader then
						%>
						<li data-role="list-divider" role="heading" class="ui-li ui-li-divider ui-bar-d ui-first-child"><%=rsSearch("rbSectName")%></li>
						<%
						Sectionheader = rsSearch("rbSectName")
					end if
		%>

					<li><a href="set.asp?p=<%=rsSearch("paraNum")%>&t=<%=rsSearch("topickey")%>&r=<%=rsSearch("rbKey")%>&s=<%=rsSearch("rbSectKey")%>&search=1"><%=rsSearch("paraNum")%>: <%=pull_citation(HTMLDecode(rsSearch("question")))%></a></li>
		<%
					rsSearch.movenext
				wend
				rc = 1
			end if

			'Check State Differences
			if len(Session("sdid")) > 0 and len(session("state")) > 0 then
				SDacronym = split(session("state"),"A-")(0)
				state = split(session("state"),"A-")(1)
				SQL = 	"SELECT	t.acronym,  t.releaseNum, t.topic, " &_
						"		sdr.slID, " &_
						"		sd.stateDiff, sd.sdKey, " &_
						"		sdt.sdType, " &_
						"		states.stateCode, states.stateName " &_
						"FROM tblTopic t " &_
						"INNER JOIN (select acronym, max(releaseNum) as releaseNum " &_
						"			from tblTopic t " &_
						"			where acronym in ('SDE','SDO') " &_
						"			group by acronym) a ON " &_
						"			a.acronym = t.acronym AND t.releaseNum = a.releaseNum " &_
						"LEFT OUTER JOIN tblStateDifferences sd on sd.topicKey = t.topicKey " &_
						"LEFT OUTER JOIN tblSDType sdt on sdt.sdTypeKey = sd.sdTypeKey " &_
						"LEFT OUTER JOIN tblStates states on states.stateKey = sd.stateKey " &_
						"LEFT OUTER JOIN tblSDReferences sdr on sdr.sdKey = sd.sdKey " &_
						"WHERE 1 = 1 " &_
						"	AND (sd.stateDiff like '%" & request("search") & "%') " &_
						"	AND t.acronym in ('" & SDacronym & "') " &_
						"	AND states.stateCode in ('" & state & "') " &_
						"Order by t.acronym, sdt.sdType "
				set rsSearchSD = conn_pub.execute(SQL)

				if not (rsSearchSD.eof and rsSearchSD.bof) then
				%>
				</ul>
				<h5><%=state%> State Differences</h5>
				<ul data-role="listview" data-inset="true" data-filter="false" data-theme="d" data-divider-theme="d" data-icon="false" class="jqm-list">
				<%
				slid = ""
				section = 0
				para = 0
					while not rsSearchSD.eof
						if slid <> rsSearchSD("slid") then
							slid = rsSearchSD("slid")

							SQL = 	"SELECT " &_
								"  t.acronym, t.releaseNum, t.topic, t.topicKey, " &_
								"	r.rbName, r.rbKey, " &_							
								"	s.rbSectNum, s.rbSectName,s.rbSectKey " &_
								"FROM tblTopic t " &_
								"INNER JOIN (select acronym, max(releaseNum) as releaseNum " &_
								"			from tblTopic t " &_
								"			group by acronym) a ON  " &_
								"  a.acronym = t.acronym AND t.releaseNum = a.releaseNum " &_
								"LEFT OUTER JOIN tblRulebook r on t.topickey = r.topickey " &_
								"LEFT OUTER JOIN tblRbSection s on s.rbKey = r.rbKey " &_
								"WHERE 1 = 1 " &_
								"	AND s.rbSectID = '" & slid & "'"
							set getSectionSD = conn_pub.execute(SQL)

							if not (getSectionSD.eof and getSectionSD.bof) then
								if getSectionSD("rbSectName") <> SectionheaderSD then
								%>
									<li data-role="list-divider" role="heading" class="ui-li ui-li-divider ui-bar-d ui-first-child"><%=getSectionSD("rbSectName")%></li>
									<%
									SectionheaderSD = getSectionSD("rbSectName")
									section = 1
									para = 0
								end if
								%>
								
								<%
							else 'Check at the para level
								SQL = 	"SELECT " &_
									"  t.acronym, t.releaseNum, t.topic, t.topicKey, " &_
									"  r.rbName, r.rbKey, " &_							
									"  s.rbSectNum, s.rbSectName,s.rbSectKey, " &_
									"  p.paraNum, p.question, p.guideNote " &_
									"FROM tblTopic t " &_
									"INNER JOIN (select acronym, max(releaseNum) as releaseNum " &_
									"			from tblTopic t " &_
									"			group by acronym) a ON  " &_
									"  a.acronym = t.acronym AND t.releaseNum = a.releaseNum " &_
									"LEFT OUTER JOIN tblRulebook r on t.topickey = r.topickey " &_
									"LEFT OUTER JOIN tblRbSection s on s.rbKey = r.rbKey " &_
									"LEFT OUTER JOIN tblRbParagraph p on p.rbSectKey = s.rbSectKey " &_
									"WHERE 1 = 1 " &_
									"	AND p.paraID = '" & rsSearchSD("slID") & "'"
								set getParaSD = conn_pub.execute(SQL)
								section = 0
								para = 1
								%>
								<li data-role="list-divider" role="heading" class="ui-li ui-li-divider ui-bar-d ui-first-child"><%=getParaSD("rbSectName")%></li>
								<%	
							end if
						end if

						if section = 1 then
						%>
							<li>
								<a href="set.asp?t=<%=getSectionSD("topickey")%>&r=<%=getSectionSD("rbKey")%>&s=<%=getSectionSD("rbSectKey")%>&sdKey=<%=rsSearchSD("sdKey")%>&search=1">
								<span style="float:right">
								<% if rsSearchSD("sdtype") = "Auditable_Partial" or rsSearchSD("sdtype") = "Auditable_Full" then %>
									Audit
								<% elseif rsSearchSD("sdtype") = "Applicability" then %>
									Applicability
								<% elseif rsSearchSD("sdtype") = "ExternalRef" then %>
									External
								<% elseif rsSearchSD("sdtype") = "GeneralInfo" then %>
									Info	
								<% end if %>
								</span>
								<%=state & "-" & getSectionSD("rbSectNum")%>: <%=pull_citation(HTMLDecode(rsSearchSD("statediff")))%>
								</a>									
							</li>
						<%
						else
						%>
							<li>
								<a href="set.asp?t=<%=getParaSD("topickey")%>&r=<%=getParaSD("rbKey")%>&s=<%=getParaSD("rbSectKey")%>&sdKey=<%=rsSearchSD("sdKey")%>&search=1">
								<span style="float:right">
								<% if rsSearchSD("sdtype") = "Auditable_Partial" or rsSearchSD("sdtype") = "Auditable_Full" then %>
									Audit
								<% elseif rsSearchSD("sdtype") = "Applicability" then %>
									Applicability
								<% elseif rsSearchSD("sdtype") = "ExternalRef" then %>
									External
								<% elseif rsSearchSD("sdtype") = "GeneralInfo" then %>
									Info	
								<% end if %>
								</span>
								<%=state & "-" & getParaSD("paraNum")%>: <%=pull_citation(HTMLDecode(rsSearchSD("statediff")))%>
								</a>									
							</li>
						<%
						end if
						rsSearchSD.movenext
					wend
					sdrc = 1
				end if
			end if
		%>
		</ul>
		<% if sdrc = 0 and rc = 0 then %>
			<p>Sorry... that didn't turn anything up</p>
		<% end if %>
	</div><!-- /content -->

<!-- #include file=inc/footer.asp -->