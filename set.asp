
<!-- #include virtual=/assets/lib/utils.asp -->


<%

Response.CacheControl = "no-cache, no-store, must-revalidate"

	if request("pub") <> "" then

            pub_acro = request("pub")
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
			else
				pub_acro = request("pub")
			end if

		SQL = "select title from publications where acronym = '" & pub_acro & "'"
		set getTitle = conn.execute(SQL)

		if not(getTitle.eof and getTitle.bof) then
			session("title") = getTitle("title")
		else
			session("title") = ""
		end if

		if len(request("sdid")) > 0 then
			Session("sdid") = request("sdid")
		else
			Session("sdid") = ""
		end if

		Session("pub") = request("pub")
		Session("t") = ""
		Session("r") = ""
		Session("s") = ""
		Session("p") = ""

		if len(request("sd")) > 0 then
			response.redirect("/ref/topicsd.asp")
		else
			response.redirect("/ref/topic.asp")
		end if
	
	elseif len(request("search")) >= 1 then
		' set everything from search
		SQL = "select topic from tblTopic rb where rb.topickey = '" & request("t") & "'"
		set gettopic = conn_pub.execute(SQL)
	
		Session("t") = request("t") & "|" & gettopic("Topic")

		SQL = "select rbName from tblRulebook rb where rb.rbKey = '" & request("r") & "'"
		set getRbTitle = conn_pub.execute(SQL)

		Session("r") = request("r") & "|" & getRbTitle("rbName")

		SQL = "select rbSectName from tblRbSection s where s.rbSectKey = '" & request("s") & "'"
		set getRbSec = conn_pub.execute(SQL)
		
		Session("s") = request("s") & "|" & getRbSec("rbSectName")
		
		if request("sdkey") <> "" then
			Session("p") = request("sdkey")
			response.redirect("/ref/sd.asp")
		else
			Session("p") = request("p")
			response.redirect("/ref/para.asp")
		end if

	elseif request("t") <> "" then
		SQL = "select topic from tblTopic rb where rb.topickey = '" & request("t") & "'"
		set gettopic = conn_pub.execute(SQL)
		
		Session("t") = request("t") & "|" & gettopic("Topic")
		Session("r") = ""
		Session("s") = ""
		Session("p") = ""

		if len(request("sd")) > 0 then
			response.redirect("/ref/rbsd.asp")
		else
			response.redirect("/ref/rb.asp")
		end if
	
	elseif request("rb") <> "" then
		topickey = split(session("t"),"|")(0)
		state = split(session("pub"),"-")(1)
		SQL = "exec spGetStateDifferences " & topickey & ", '" & state & "'"
		set rsRulebooks = conn_pub.execute(SQL)
		
		Session("r") = request("rb") & "|" & rsRulebooks("rbName")
		Session("s") = request("rb") & "|" & rsRulebooks("rbSectName")
		Session("p") = ""

		response.redirect("/ref/sd.asp")

	elseif request("r") <> "" then
		SQL = "select rbName from tblRulebook rb where rb.rbKey = '" & request("r") & "'"
		set getRbTitle = conn_pub.execute(SQL)
		
		Session("r") = request("r") & "|" & getRbTitle("rbName")
		Session("s") = ""
		Session("p") = ""

		Response.Redirect("/ref/section.asp")

	elseif request("s") <> "" then
		SQL = "select rbSectName from tblRbSection s where s.rbSectKey = '" & request("s") & "'"
		set getRbSec = conn_pub.execute(SQL)
		
		Session("s") = request("s") & "|" & getRbSec("rbSectName")
		Session("p") = ""

		response.redirect("/ref/para.asp")
	
	elseif request("ts") <> "" then	
		SQL = "select topic from tblTopic rb where rb.topickey = '" & request("ts") & "'"
		set gettopic = conn_pub.execute(SQL)
		
		Session("t") = request("ts") & "|" & gettopic("Topic")

		state = split(session("pub"),"-")(1)
		SQL = "exec spGetStateDifferences " & request("ts") & ", '" & state & "'"
		set getRbSec = conn_pub.execute(SQL)
		Session("s") = request("ss") & "|" & getRbSec("rbSectName")
		Session("p") = request("sd")

		response.redirect("/ref/sd.asp")

	elseif request("sdkey") <> "" then
		Session("p") = request("sdkey")
		response.redirect("/ref/sd.asp")

	elseif request("p") <> "" then
		Session("p") = request("p")

		response.redirect("/ref/para.asp")

	else
		Session("pub") = ""
		Session("title") = ""
		Session("sdid") = ""
		Session("state") = ""
		Session("t") = ""
		Session("r") = ""
		Session("s") = ""
		Session("p") = ""

		response.redirect("/ref/index.asp")
	end if


%>
