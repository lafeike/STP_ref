<%
if len(Session("sdid")) > 0 then 
	SQL = "exec checkPub " & session("stp_userid") & "," & session("stp_companyid") & "," & Session("sdid")
	  Set checkPub = conn.Execute(SQL) 

	if not(checkpub.eof and checkpub.bof) then
		pubs = ""
		pub_count = 0
		While Not checkpub.EOF
			pubs = pubs & checkpub("publicationID") & ","
			pub_count = pub_count + 1
			checkpub.movenext
		wend
		pubs = left(pubs,len(pubs)-1)

		if pub_count > 1 then
			sql = "select acronym, right(title, len(title) - charindex(':', title)) as State from Publications where PublicationID in (" & pubs & ")"
			Set rsSD = conn.Execute(SQL) 
		else
			sql = "select acronym, right(title, len(title) - charindex(':', title)) as State from Publications where Code = " & Session("sdid")
			Set rsSD = conn.Execute(SQL) 
		end if
		if not (rsSD.eof and rsSD.bof) then  
%>

<div data-role="panel" id="statediff" data-position="right" data-display="overlay" data-theme="b">

    <form id="statedifferences" action="setsd.asp" method="get">
	    <fieldset data-role="controlgroup">
	        <legend>Available States</legend>
	        <input type="radio" class="SD" name="sd" id="NONE" value="NONE"
	        <% if session("state") = rsSD("Acronym") or  len(session("state")) = 0 then %>
	    		checked="checked" checked
    		<% end if %>
		    >
	        <label for="NONE">None</label>

	        <% 
	        While Not rsSD.EOF 
	        %>
		        <input 	type="radio" 
		        		name="sd" id="<%=rsSD("Acronym")%>" 
		        		value="<%=rsSD("Acronym")%>" 
		        		class="SD"
		        		<% if instr(rsSD("Acronym"),"CA") > 0 then %>
		        		disabled="true" disabled
		        		<% end if %>
		        		<% if session("state") = rsSD("Acronym") then %>
		        		checked="checked" checked
		        		<% end if %>
		        >
		        <label for="<%=rsSD("Acronym")%>"><%=rsSD("State")%></label>
	        <% 
	        	rsSD.movenext
	        wend
	        %>
	       <input type="hidden" id="searchquery" name="searchquery" value="<%=request("search")%>"
	    </fieldset>	    
	</form>
    <!-- 
    <a href="#demo-links" data-rel="close" data-role="button" data-theme="c" data-icon="delete" data-inline="true">Close panel</a>
	-->
</div>
<%
		end if
	end if
%>
<script >
	$(document).ready(function () {
		$(".SD").click( function (e) {
			 $("form#statedifferences").submit();
			//console.log( $(this).attr("id") )
		})
	});
</script>
<%
end if
%>

<div data-role="footer" class="jqm-footer">
	<p><a href="nomobile.asp" rel="external">Go to full site</a></p>

	<p class="jqm-version"></p>
	<p>Copyright 2015 Specialty Technical Publishers - All rights reserved</p>

</div><!-- /jqm-footer -->
	
	<!-- #include file=panel.asp -->

</div><!-- /page -->
</body>
</html>