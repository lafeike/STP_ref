<!-- #include virtual=/assets/lib/utils.asp -->
<%
Session("p") = ""

if len(request("sd")) > 0 then
	if request("sd") <> "NONE" then
		Session("state") = request("sd")
	else
		Session("state") = ""
	end if
else
	Session("state") = ""
end if

if len(request("searchquery")) > 0 then
	response.redirect("/ref/search-results.asp?search=" & request("searchquery"))
elseif len(Session("p")) > 0 then
	response.redirect("/ref/para.asp")
elseif len(Session("s")) > 0 then
	response.redirect("/ref/para.asp")
elseif len(Session("r")) > 0 then
	response.redirect("/ref/section.asp")
elseif len(Session("t")) > 0 then
	response.redirect("/ref/rb.asp")
elseif len(Session("pub")) > 0 then
	response.redirect("/ref/topic.asp")
else
	response.redirect("/ref/index.asp")
end if
%>